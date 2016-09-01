function b = imfilter(varargin)
%IMFILTER N-D filtering of multidimensional images.
%   B = IMFILTER(A,H) filters the multidimensional array A with the
%   filter H.  A can be logical or it can be a nonsparse numeric
%   array of any class and dimension.  The result, B, has the same
%   size and class as A.  When A is a gpuArray object, H must be a
%   vector or 2-D matrix.
%
%   Each element of the output, B, is computed using either single-
%   or double-precision floating point, depending on the data type
%   of A.  When A contains double-precision or UINT32 values, the
%   computations are performed using double-precision values.  All
%   other data types use single-precision.  If A is an integer or
%   logical array, then output elements that exceed the range of
%   the given type are truncated, and fractional values are rounded.
%
%   B = IMFILTER(A,H,OPTION1,OPTION2,...) performs multidimensional
%   filtering according to the specified options.  Option arguments can
%   have the following values:
%
%   - Boundary options
%
%       X            Input array values outside the bounds of the array
%                    are implicitly assumed to have the value X.  When no
%                    boundary option is specified, IMFILTER uses X = 0.
%
%       'symmetric'  Input array values outside the bounds of the array
%                    are computed by mirror-reflecting the array across
%                    the array border.
%
%       'replicate'  Input array values outside the bounds of the array
%                    are assumed to equal the nearest array border
%                    value.
%
%       'circular'   Input array values outside the bounds of the array
%                    are computed by implicitly assuming the input array
%                    is periodic.
%
%   - Output size options
%     (Output size options for IMFILTER are analogous to the SHAPE option
%     in the functions CONV2 and FILTER2.)
%
%       'same'       The output array is the same size as the input
%                    array.  This is the default behavior when no output
%                    size options are specified.
%
%       'full'       The output array is the full filtered result, and so
%                    is larger than the input array.
%
%   - Correlation and convolution
%
%       'corr'       IMFILTER performs multidimensional filtering using
%                    correlation, which is the same way that FILTER2
%                    performs filtering.  When no correlation or
%                    convolution option is specified, IMFILTER uses
%                    correlation.
%
%       'conv'       IMFILTER performs multidimensional filtering using
%                    convolution.
%
%   Example 
%   -------------
%       originalRGB = gpuArray(imread('peppers.png'));
%       h = fspecial('motion',50,45);
%       filteredRGB = imfilter(originalRGB,h);
%       figure, imshow(originalRGB)
%       figure, imshow(filteredRGB)
%       boundaryReplicateRGB = imfilter(originalRGB,h,'replicate');
%       figure, imshow(boundaryReplicateRGB)
%
%   See also FSPECIAL, GPUARRAY/CONV2, GPUARRAY/CONVN, GPUARRAY/FILTER2,
%            GPUARRAY.

%   Copyright 1993-2013 The MathWorks, Inc.

[a, h, boundary, sameSize] = parse_inputs(varargin{:});

[finalSize, pad] = computeSizes(a, h, sameSize);

%Empty Inputs
% 'Same' output then size(b) = size(a)
% 'Full' output then size(b) = size(h)+size(a)-1 
if isempty(a)
  
  b = handleEmptyImage(a, sameSize, finalSize);
  return
  
elseif isempty(h)
    
  b = handleEmptyFilter(a, sameSize, finalSize);
  return
  
end

boundaryStr = boundary;
padVal      = 0;
if(~ischar(boundary))
    boundaryStr = 'constant';
    padVal      = boundary;
end

%Special case 
if(ismatrix(a) && isequal(size(h),[3 3]) && sameSize...
       && isreal(a) && isreal(h) && ~strcmp(boundaryStr,'circular'))
   h      = gpuArray(double(h));
   padVal = cast(gather(padVal), classUnderlying(a));
   b      = imfiltergpumex(a, h, boundaryStr, padVal);
   return;
end


% Zero-pad input based on dimensions of filter kernel.
a = padarray_algo(a,pad,boundaryStr,padVal,'both');

[separableFlag, u, s, v] = isSeparable(a, h);

if (separableFlag)
  
  % Separable - Extract the components of the separable filter
  hcol = u(:,1) * sqrt(s(1));
  hrow = v(:,1)' * sqrt(s(1));
  
  b = filterPartOrWhole(a, finalSize, hrow, hcol, pad+1, sameSize);
  
else % non-separable filter case
  
  b = filterPartOrWhole(a, finalSize, h, [], pad+1, sameSize);
    
end


%--------------------------------------------------------------
function [a, h, boundary, sameSize] = parse_inputs(a, h, varargin)

narginchk(2,5);

if ~isa(a, 'gpuArray')
    error(message('images:imfilter:gpuImageType'))
end

if (~ismatrix(h))
    error(message('images:imfilter:gpuFilterKernelDims'))
end

%Assign defaults
boundary = 0;  %Scalar value of zero
output = 'same';
do_fcn = 'corr';

allStrings = {'replicate', 'symmetric', 'circular', 'conv', 'corr', ...
              'full','same'};

for k = 1:length(varargin)
  if ischar(varargin{k})
    string = validatestring(varargin{k}, allStrings,...
                          mfilename, 'OPTION',k+2);
    switch string
     case {'replicate', 'symmetric', 'circular'}
      boundary = string;
     case {'full','same'}
      output = string;
     case {'conv','corr'}
      do_fcn = string;
    end
  else
    validateattributes(varargin{k},{'numeric'},{'nonsparse'},mfilename,'OPTION',k+2);
    boundary = varargin{k};
  end %else
end

sameSize = strcmp(output,'same');

convMode = strcmp(do_fcn,'conv');

% 
if isa(h, 'gpuArray')
    if ~convMode
        h = rot90(h,2);
    end
else
    if convMode
        h = gpuArray(h);
    else
        % For convMode, filter must be rotated. Do this on the CPU for small sizes, as
        % it is likely to be slow.
        if numel(h) < 100000
            h = gpuArray(rot90(h,2));
        else
            h = rot90(gpuArray(h),2);
        end
    end        
end


%--------------------------------------------------------------
function [separable, u, s, v] = isSeparable(a, h)

% check for filter separability only if the kernel has enough
% elements to make it worthwhile, both the image and the filter
% kernel are two-dimensional and the kernel is not a row or column
% vector, nor does it contain any NaNs of Infs.

if strcmp(classUnderlying(a),'double')
    sep_threshold = 150;
else
    sep_threshold = 900;
end

subs.type = '()';
subs.subs = {':'};

if ((numel(h) >= sep_threshold) && ...
    (ismatrix(a)) && ...
    (ismatrix(h)) && ...
    all(size(h) ~= 1) && ...
    all(isfinite(subsref(h,subs))))

  [u, s, v] = svd(gather(h));
  s = diag(s);
  tol = length(h) * s(1) * eps;
  rank = sum(s > tol);
  
  if (rank == 1)
    separable = true;
  else
    separable = false;
  end
  
else
    
  separable = false;
  u = [];
  s = [];
  v = [];
    
end


%--------------------------------------------------------------
function b = handleEmptyImage(a, sameSize, im_size)

if (sameSize)

  b = a;
    
else
    
  if all(im_size >= 0)
      
    b = zeros(im_size, class(a));
      
  else
      
    error(message('images:imfilter:negativeDimensionBadSizeB'))
      
  end
    
end


%--------------------------------------------------------------
function b = handleEmptyFilter(a, sameSize, im_size)

if (sameSize)
  
    b = zeros(size(a), class(a));
  
else
  
  if all(im_size>=0)
    
    b = zeros(im_size, class(a));
    
  else
    
    error(message('images:imfilter:negativeDimensionBadSizeB'))
    
  end
  
end


%--------------------------------------------------------------
function [finalSize, pad] = computeSizes(a, h, sameSize)

rank_a = ndims(a);
rank_h = ndims(h);

% Pad dimensions with ones if filter and image rank are different
size_h = [size(h) ones(1,rank_a-rank_h)];
size_a = [size(a) ones(1,rank_h-rank_a)];

if (sameSize)
  %Same output
  finalSize = size_a;

  %Calculate the number of pad pixels
  filter_center = floor((size_h + 1)/2);
  pad = size_h - filter_center;
else
  %Full output
  finalSize = size_a+size_h-1;
  pad = size_h - 1;
end


%--------------------------------------------------------------
function a = filterPartOrWhole(a, outSize, h1, h2, outputStartIdx, sameSize)

% intermediate results should be stored in doubles in order to
% maintain sufficient precision
origClass = classUnderlying(a);

switch (origClass)
  case {'double', 'uint32'}
    
    sameClass = strcmp(origClass, 'double');
    
    if (~sameClass)
      a = double(a);
    end
    
  otherwise
  
    sameClass = strcmp(origClass, 'single');
    
    if (~sameClass)
      a = single(a);
    end
    
end

% Perform the filter.
if (sameSize)
    sizeFlag = 'same';
else
    sizeFlag = 'full';
end

if (isempty(h2))
    % Nonseparable.
    a = convn(a, h1, sizeFlag);
else
    % Separable - isSeparable() already checks for 2-D image and kernel.
    a = conv2(h1, h2, a, sizeFlag);
end

% Retrieve the part of the image that's required.
sRHS.type = '()';
sRHS.subs = {outputStartIdx(1):(outputStartIdx(1) + outSize(1) - 1), ...
             outputStartIdx(2):(outputStartIdx(2) + outSize(2) - 1), ...
             ':'};

a = subsref(a, sRHS);

% Cast the data as appropriate.
if (~sameClass)
    a = castData(a, origClass);
end
   

%--------------------------------------------------------------
function result = castData(result, origClass)

if (strcmp(origClass, 'logical'))
    result = result >= 0.5;
else
    result = cast(result, origClass);
end
