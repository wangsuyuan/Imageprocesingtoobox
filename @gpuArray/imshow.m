function h = imshow(varargin)
%IMSHOW Display image in Handle Graphics figure.
%   IMSHOW(G, ...) displays the image contained in the gpuArray
%   object G.  This function supports all of the parameter-value
%   pairs that IMSHOW accepts for non-GPU images.
%
%   See also IMSHOW, GPUARRAY.

%   Copyright 2012-2013 The MathWorks, Inc.

args = gatherIfNecessary(varargin{:});
hh = imshow(args{:});

if (nargout > 0)
  % Only return handle if caller requested it.
  h = hh;
end
