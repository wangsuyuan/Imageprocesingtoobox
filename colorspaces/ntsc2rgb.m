function varargout = ntsc2rgb(varargin)
%NTSC2RGB Convert NTSC color values to RGB color space.
%   RGBMAP = NTSC2RGB(YIQMAP) converts the M-by-3 NTSC
%   (television) values in the colormap YIQMAP to RGB color
%   space. If YIQMAP is M-by-3 and contains the NTSC luminance
%   (Y) and chrominance (I and Q) color components as columns,
%   then RGBMAP is an M-by-3 matrix that contains the red, green,
%   and blue values equivalent to those colors.  Both RGBMAP and
%   YIQMAP contain intensities in the range 0.0 to 1.0. The
%   intensity 0.0 corresponds to the absence of the component,
%   while the intensity 1.0 corresponds to full saturation of the
%   component.
%
%   RGB = NTSC2RGB(YIQ) converts the NTSC image YIQ to the
%   equivalent truecolor image RGB.
%
%   Class Support
%   -------------
%   The input image or colormap must be of class double. The
%   output is of class double.
%
%   Example
%   -------
%   Convert RGB image to NTSC and back.
%
%       RGB = imread('board.tif');
%       NTSC = rgb2ntsc(RGB);
%       RGB2 = ntsc2rgb(NTSC);
%
%   See also RGB2NTSC, RGB2IND, IND2RGB, IND2GRAY.

%   Copyright 1992-2010 The MathWorks, Inc.

A = parse_inputs(varargin{:});

T = [1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703];

threeD = (ndims(A)==3); % Determine if input includes a 3-D array.

if threeD % A is YIQ, M-by-N-by-3
  m = size(A,1);
  n = size(A,2);
  A = reshape(A(:),m*n,3)*T';
  % Make sure the rgb values are between 0.0 and 1.0
  A = max(0,A);
  d = find(any(A'>1));
  A(d,:) = A(d,:) ./ (max(A(d,:), [], 2) * ones(1,3));
  A = reshape(A,m,n,3);
else % A is YIQMAP, M-by-3
  A = A*T';
  % Make sure the rgb values are between 0.0 and 1.0
  A = max(0,A);
  d = find(any(A'>1));
  A(d,:) = A(d,:) ./ (max(A(d,:), [], 2) * ones(1,3));
end

% Output
if nargout < 2,%              RGBMAP = NTSC2RGB(YIQMAP)
  varargout{1} = A;
else 
  error(message('images:ntsc2rgb:wrongNumberOfOutputArguments', nargout))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Function: parse_inputs
%

function A = parse_inputs(varargin)

narginchk(1,1);

% ntsc2rgb(YIQ) or ntsc2rgb(YIQMAP)
A = varargin{1};

%no logical
if islogical(A)
  error(message('images:ntsc2rgb:invalidType'))
end


% Check validity of the input parameters. A is converted to double because YIQ
% colorspace can contain negative values.

if ndims(A)==2 
  % Check colormap 
  if ( size(A,2)~=3 || size(A,1) < 1 ) 
    error(message('images:ntsc2rgb:invalidYIQMAP'))
  end
  if ~isa(A,'double')
    warning(message('images:ntsc2rgb:rangeYIQMAP'));
    A = im2double(A);
  end
elseif ndims(A)==3 && size(A,3)==3
  % Check YIQ

  A = im2double(A);
  
else
  error(message('images:ntsc2rgb:invalidSize'))
end
