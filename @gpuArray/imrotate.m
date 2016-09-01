function varargout = imrotate(varargin)
%IMROTATE Rotate image.
%   B = IMROTATE(A, ANGLE) rotates the image in gpuArray A by ANGLE degrees
%   in a counterclockwise direction around its center point. To rotate the
%   image clockwise, specify a negative value for ANGLE. IMROTATE makes the
%   output gpuArray B large enough to contain the entire rotated image.
%   IMROTATE uses nearest neighbor interpolation, setting the values of
%   pixels in B that are outside the rotated image to 0 (zero).
%
%   B = IMROTATE(A,ANGLE,METHOD) rotates the image in gpuArray A, using the
%   interpolation method specified by METHOD. METHOD is a string that can
%   have one of the following values. The default value is enclosed in
%   braces ({}).
%
%        {'nearest'}  Nearest neighbor interpolation
%
%        'bilinear'   Bilinear interpolation
%
%        'bicubic'    Bicubic interpolation. Note: This interpolation
%                     method can produce pixel values outside the original
%                     range.
%
%   B = IMROTATE(A,ANGLE,METHOD,BBOX) rotates image in gpuArray A, where
%   BBOX specifies the size of the output gpuArray B. BBOX is a text string
%   that can have either of the following values. The default value is
%   enclosed in braces
%   ({}).
%
%        {'loose'}    Make output gpuArray B large enough to contain the
%                     entire rotated image. B is generally larger than A.
%
%        'crop'       Make output gpuArray B the same size as the input
%                     gpuArray A, cropping the rotated image to fit.
%
%   Class Support
%   -------------
%   The input gpuArray image can contain uint8, uint16, single-precision
%   floating-point, or logical pixels.  The output image is of the same
%   class as the input image.
%
%   Note
%   ----
%   The 'bicubic' interpolation mode used in the GPU implementation of this
%   function differs from the default (CPU) bicubic mode.  The GPU and CPU
%   versions of this function are expected to give slightly different
%   results.
%
%   Example
%   -------
%   X = gpuArray(imread('pout.tif'));
%   Y = imrotate(X, 37, 'loose', 'bilinear');
%   figure; imshow(Y)
%
%   See also IMCROP, GPUARRAY/IMRESIZE, IMTRANSFORM, TFORMARRAY, GPUARRAY.

% Copyright 2012-2013 The MathWorks, Inc.

[A,angle,method,bbox] = parse_inputs(varargin{:});

if (isempty(A))
    
    B = A; % No rotation needed
    
else
    
    so = size(A);
    twod_size = so(1:2);
    thirdD = prod(so(3:end));
    
    r = rem(angle, 360);
    switch (r)
        case {0}
            
            B = A;
            
        case {90, 270}
            
            A = reshape(A,[twod_size thirdD]);
            
            not_square = twod_size(1) ~= twod_size(2);
            
            multiple_of_ninety = mod(floor(angle/90), 4);
            
            if strcmpi(bbox, 'crop') && not_square
                % center rotated image and preserve size
                
                if ndims(A)>2 %#ok<ISMAT>
                    dim = 3;
                else
                    dim = ndims(A);
                end
                
                v = repmat({':'},[1 dim]);
                
                imbegin = (max(twod_size) == so)*abs(diff(floor(twod_size/2)));
                vec = 1:min(twod_size);
                v(1) = {imbegin(1)+vec};
                v(2) = {imbegin(2)+vec};
                
                new_size = [twod_size thirdD];
                
                % pre-allocate array
                if islogical(A)
                    B = gpuArray.false(new_size);
                else
                    B = gpuArray.zeros(new_size,classUnderlying(A));
                end
                
                
                s.type = '()';
                s.subs = v;
                
                for k = 1:thirdD
                    s.subs{3} = k;
                    % B(:,:,k) = rot90(A(:,:,k),multiple_of_ninety);
                    B = subsasgn(B, s, rot90(subsref(A, s), multiple_of_ninety));
                end
            else
                % don't preserve original size
                new_size = [fliplr(twod_size) thirdD];
                
                B = pagefun(@rot90,A,multiple_of_ninety);
            end
            
            B = reshape(B,[new_size(1) new_size(2) so(3:end)]);
            
        case {180}
            
            v = repmat({':'},[1 ndims(A)]);
            v(1) = {twod_size(1):-1:1};
            v(2) = {twod_size(2):-1:1};
            
            s.type = '()';
            s.subs = v;
            
            B = subsref(A, s);
            
        otherwise
            
            padSize = [2 2];
            if (~ismatrix(A))
                padSize(ndims(A)) = 0;
            end
            
            %pad input gpuArray to overcome different edge behavior in NPP.
            A = padarray_algo(A, padSize, 'constant', 0, 'both');
            
            [~,~,~,~,outputSize] = getOutputBound(angle,twod_size,bbox);
            
            if (isreal(A))
                B = imrotategpumex(A, angle, method, outputSize);
            else
                B = complex(imrotategpumex(real(A), angle, method, outputSize),...
                    imrotategpumex(imag(A), angle, method, outputSize));
            end
    end
end

varargout{1} = B;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to parse inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,ang,method,bbox] = parse_inputs(varargin)
% Outputs:  A       the input gpuArray
%           ang     the angle by which to rotate the input image
%           method  interpolation method (nearest,bilinear,bicubic)
%           bbox    bounding box option 'loose' or 'crop'

% Defaults:
method = 'n';
bbox = 'l';

narginchk(2,4)
switch nargin
    case 2,             % imrotate(A,ang)
        A = varargin{1};
        ang=varargin{2};
    case 3,             % imrotate(A,ang,method) or
        A = varargin{1};  % imrotate(A,ang,box)
        ang=varargin{2};
        method=varargin{3};
    case 4,             % imrotate(A,ang,method,box)
        A = varargin{1};
        ang=varargin{2};
        method=varargin{3};
        bbox=varargin{4};
    otherwise,
        error(message('images:imrotate:invalidInputs'))
end

% Check validity of the input parameters
if ischar(method) && ischar(bbox),
    strings = {'nearest','bilinear','bicubic','crop','loose'};
    idx = strmatch(lower(method),strings);
    if isempty(idx),
        error(message('images:imrotate:unrecognizedInterpolationMethod', method))
    elseif length(idx)>1,
        error(message('images:imrotate:ambiguousInterpolationMethod', method))
    else
        if idx==4,bbox=strings{4};method=strings{1};
        elseif idx==5,bbox = strings{5};method=strings{1};
        else method = strings{idx};
        end
    end
    idx = strmatch(lower(bbox),strings(4:5));
    if isempty(idx),
        error(message('images:imrotate:unrecognizedBBox', bbox))
    elseif length(idx)>1,
        error(message('images:imrotate:ambiguousBBox', bbox))
    else
        bbox = strings{3+idx};
    end
else
    error(message('images:imrotate:expectedString'))
end

hValidateAttributes(A,...
    {'uint8','uint16','logical','single'},{},mfilename,'input image',1);

% Ang must always be double.
ang = double(ang);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Function: getOutputBound
%
function [loA,hiA,loB,hiB,outputSize] = getOutputBound(angle,twod_size,bbox)

% Coordinates from center of A
hiA = (twod_size-1)/2;
loA = -hiA;
if strcmpi(bbox, 'loose')  % Determine limits for rotated image
    
    % Compute bounding box of roated image
    phi = angle*pi/180; % Convert to radians
    
    sinPhi = sin(phi);
    cosPhi = cos(phi);
    T = [ cosPhi  sinPhi   0
        -sinPhi  cosPhi   0
        0       0     1 ];
    rotate = affine2d(T);
    
    [x,y] = rotate.outputLimits([loA(1) hiA(1)], [hiA(2) hiA(2)]);
    hiB = ceil(max(abs([x' y']))/2)*2;
    loB = -hiB;
    outputSize = hiB - loB + 1;
    
else % Cropped image
    
    hiB = hiA;
    loB = loA;
    outputSize = twod_size;
    
end
