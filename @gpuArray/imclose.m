function B = imclose(varargin)
%IMCLOSE Morphologically close image.
%   IM2 = IMCLOSE(IM,SE) performs morphological closing on the grayscale
%   or binary gpuArray image IM with the structuring element SE.  SE must 
%   be a single structuring element object, as opposed to an array of
%   objects.
%
%   IM2 = IMCLOSE(IM,NHOOD) performs closing with the structuring element
%   STREL(NHOOD), if NHOOD is an array of 0s and 1s that specifies the
%   structuring element neighborhood or STREL(GATHER(NHOOD)) if NHOOD is a
%   gpuArray object with 0s and 1s that specify the structuring element
%   neighborhood.
%
%   The morphological close operation is a dilation followed by an erosion,
%   using the same structuring element for both operations.
%
%   Class Support
%   -------------
%   IM must be a gpuArray of type uint8 or logical. It can have any
%   dimension. The output has the same class as the input.
%
%   Notes
%   -----
%   1.  The structuring element must be flat, and its neighborhood must be 
%       two-dimensional.
%   2.  Packed binary images are not supported on the GPU.
%
%   Example
%   -------
%   Use IMCLOSE on cirles.png image to join the circles together by filling
%   in the gaps between the circles and by smoothening their outer edges.
%   Use a disk structuring element to preserve the circular nature of the
%   object. Choose the disk element to have a radius of 10 pixels so that
%   the largest gap gets filled.
%
%       originalBW = imread('circles.png');
%       figure, imshow(originalBW);
%       se = strel('disk',10);
%       closeBW = imclose(gpuArray(originalBW),se);
%       figure, imshow(closeBW);
%
%   See also GPUARRAY/IMOPEN, GPUARRAY/IMDILATE, GPUARRAY/IMERODE, STREL,
%            GPUARRAY.

%   Copyright 2012-2013 The MathWorks, Inc.

narginchk(2,2);

% Dispatch to CPU.
if ~isa(varargin{1},'gpuArray')
    args = gatherIfNecessary(varargin{:});
    B = imclose(args{:});
    return;
end

% Get the required inputs.
A  = varargin{1};
se = varargin{2};

% Ensure the strel is not a strel array.
if isa(se,'strel') && length(se(:)) > 1
    error(message('images:imclose:nonscalarStrel'));
end

% Parse and validate inputs.
% (Call to parser with 'erode' prevents strel reflection).
[A,se,padfull,unpad,~] = morphopInputParser(A,se,'erode',mfilename); 

% Dilate and then erode.
B = morphopAlgo(A,reflect2dFlatStrel(se),padfull,unpad,'dilate');
B = morphopAlgo(B,se,padfull,unpad,'erode');
