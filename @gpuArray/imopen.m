function B = imopen(varargin)
%IMOPEN Morphologically open image.
%   IM2 = IMOPEN(IM,SE) performs morphological opening on the grayscale
%   or binary gpuArray image IM with the structuring element SE.  SE must 
%   be a single structuring element object, as opposed to an array of
%   objects.
%
%   IM2 = IMOPEN(IM,NHOOD) performs opening with the structuring element
%   STREL(NHOOD), if NHOOD is an array of 0s and 1s that specifies the
%   structuring element neighborhood or STREL(GATHER(NHOOD)) if NHOOD is a
%   gpuArray object with 0s and 1s that specify the structuring element
%   neighborhood.
%
%   The morphological open operation is an erosion followed by a dilation,
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
%   Remove snowflakes having a radius less than 5 pixels by opening it with
%   a disk-shaped structuring element having a 5 pixel radius.
%
%       original = imread('snowflakes.png');
%       se = strel('disk',5);
%       afterOpening = imopen(gpuArray(original),se);
%       figure, imshow(original), figure, imshow(afterOpening,[])
%
%   See also GPUARRAY/IMCLOSE, GPUARRAY/IMDILATE, GPUARRAY/IMERODE, STREL,
%            GPUARRAY.

%   Copyright 2012-2013 The MathWorks, Inc.

narginchk(2,2);

% Dispatch to CPU.
if ~isa(varargin{1},'gpuArray')
    args = gatherIfNecessary(varargin{:});
    B = imopen(args{:});
    return;
end

% Get the required inputs.
A  = varargin{1};
se = varargin{2};

% Ensure the strel is not a strel array.
if isa(se,'strel') && length(se(:)) > 1
    error(message('images:imopen:nonscalarStrel'));
end

% Parse and validate inputs.
[A,se,padfull,unpad,~] = morphopInputParser(A,se,'erode',mfilename);

% Erode and then dilate.
B = morphopAlgo(A,se,padfull,unpad,'erode');
B = morphopAlgo(B,reflect2dFlatStrel(se),padfull,unpad,'dilate');
