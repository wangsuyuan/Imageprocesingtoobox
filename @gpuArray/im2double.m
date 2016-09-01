function d = im2double(img, varargin)
%IM2DOUBLE Convert gpuArray image to double precision.
%   IM2DOUBLE takes a gpuArray image as input, and returns a gpuArray image
%   of underlying class double.  If the input gpuArray image is of class
%   double, the output gpuArray image is identical to it.  If the input
%   gpuArray image is not double, IM2DOUBLE returns the equivalent gpuArray
%   image of underlying class double, rescaling or offsetting the data as
%   necessary.
%
%   I2 = IM2DOUBLE(I1) converts the gpuArray intensity image I1 to double
%   precision, rescaling the data if necessary.
%
%   RGB2 = IM2DOUBLE(RGB1) converts the truecolor gpuArray image RGB1 to
%   double precision, rescaling the data if necessary.
%
%   I = IM2DOUBLE(BW) converts the binary gpuArray image BW to a double-
%   precision intensity image.
%
%   X2 = IM2DOUBLE(X1,'indexed') converts the indexed gpuArray image X1 to
%   double precision, offsetting the data if necessary.
%
%   Class Support
%   -------------
%   Intensity and truecolor gpuArray images can be uint8, uint16, double,
%   logical, single, or int16. Indexed gpuArray images can be uint8,
%   uint16, double or logical. Binary input gpuArray images must be
%   logical. The output image is a gpuArray with underlying class of double.
%
%   Example
%   -------
%       I1 = gpuArray(reshape(uint8(linspace(1,255,25)),[5 5]))
%       I2 = im2double(I1)
%
%   See also GPUARRAY/DOUBLE, GPUARRAY/IM2SINGLE, GPUARRAY/IM2INT16,
%            GPUARRAY/IM2UINT8, GPUARRAY/IM2UINT16, GPUARRAY.

%   Copyright 2013 The MathWorks, Inc.

%% inputs
narginchk(1,2);

classIn = classUnderlying(img);
hValidateAttributes(img,...
    {'double','logical','uint8','uint16','int16','single'},...
    {},mfilename,'Image',1);

if nargin == 2
    validatestring(varargin{1}, {'indexed'}, mfilename, 'type', 2);
end

%% process

if strcmp(classIn, 'double')
    d = img;
    
elseif strcmp(classIn, 'logical') || strcmp(classIn, 'single')
    d = double(img);
    
elseif strcmp(classIn, 'uint8') || strcmp(classIn, 'uint16')
    if nargin==1
        range = getrangefromclass(img);
        d     = double(img) / range(2);
    else
        d     = double(img)+1;
    end
    
else %int16
    if nargin == 1
        d = arrayfun(@scaleDouble, img);
    else
        error(message('images:im2double:invalidIndexedImage', 'single, or logical.'));
    end
end

    function pixout = scaleDouble(pixin)
        %d = (double(img) + 32768) / 65535;
        pixout = (double(pixin)+ 32768)/ 65535;
    end

end
