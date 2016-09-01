function I = rgb2gray(X)
%RGB2GRAY Convert RGB gpuArray image or colormap to grayscale.
%   RGB2GRAY converts RGB gpuArray images to grayscale by eliminating the
%   hue and saturation information while retaining the
%   luminance.
%
%   I = RGB2GRAY(RGB) converts the truecolor gpuArray image RGB to the
%   grayscale intensity image I.
%
%   NEWMAP = RGB2GRAY(MAP) returns a grayscale colormap
%   equivalent to MAP.
%
%   Class Support
%   -------------
%   If the input is an RGB gpuArray image, it can be uint8, uint16, double,
%   or single. The output gpuArray image I has the same class as the input
%   image. If the input is a colormap, the input and output colormaps are
%   both of class double.
%
%   Example
%   -------
%   I = gpuArray(imread('board.tif'));
%   J = rgb2gray(I);
%   figure, imshow(I), figure, imshow(J);
%
%   [X,map] = gpuArray(imread('trees.tif'));
%   gmap = rgb2gray(map);
%   figure, imshow(X,map), figure, imshow(X,gmap);
%
%   See also IND2GRAY, NTSC2RGB, RGB2IND, RGB2NTSC, GPUARRAY/MAT2GRAY,
%            GPUARRAY.

%   Copyright 2013 The MathWorks, Inc.

X        = parse_inputs(X);
origSize = size(X);

% Determine if input includes a 3-D array
threeD = (ndims(X)==3);

% Calculate transformation matrix
T    = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
coef = T(1,:);

if threeD
    % RGB
    if(isfloat(X))
        % Shape input matrix so that it is a n x 3 array
        X          = reshape(X,origSize(1)*origSize(2),3);
        sizeOutput = [origSize(1), origSize(2)];
        
        I = X * coef';
        I = min(max(I,0),1);
        
        %Make sure that the output matrix has the right size
        I = reshape(I,sizeOutput);
    else        
        %I = X(:,:,1)*coef(1) + X(:,:,2)*coef(2) + X(:,:,3)*coef(3);
        s1.type = '()'   ; s2.type ='()'; s3.type ='()';
        s1.subs = {':',':',1}; s2.subs = {':',':',2}; s3.subs = {':',':',3};
        I = arrayfun(@multiplyCoef,subsref(X,s1), subsref(X,s2), subsref(X,s3));
        
        I = cast(I, classUnderlying(X));
    end
    
else
    % MAP
    I = X * coef';
    I = min(max(I,0),1);
    I = [I,I,I];
end


    %----------------------------------
    function eOut = multiplyCoef(r,g,b)
        eOut = double(r)*coef(1) + double(g)*coef(2) + double(b)*coef(3);
    end

end


%%%
%Parse Inputs
%%%
function X = parse_inputs(X)

if ismatrix(X)
    % colormap
    if (size(X,2) ~=3 || size(X,1) < 1)
        error(message('images:rgb2gray:invalidSizeForColormap'))
    end
    if ~strcmp(classUnderlying(X),'double')
        error(message('images:rgb2gray:notAValidColormap'))
    end
elseif (ndims(X)==3)
    % rgb
    if ((size(X,3) ~= 3))
        error(message('images:rgb2gray:invalidInputSizeRGB'))
    end
else
    error(message('images:rgb2gray:invalidInputSize'))
end

%no logical arrays
if islogical(X)
    error(message('images:rgb2gray:invalidType'))
end
end