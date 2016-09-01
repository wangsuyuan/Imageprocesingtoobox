function U = conformalInverse(X, ~)
% conformalInverse Inverse conformal transformation.
%
% Supports conformal transformation example, ConformalMappingImageExample.m
% ("Exploring a Conformal Mapping").

% Copyright 2005-2013 The MathWorks, Inc. 

Z = complex(X(:,1),X(:,2));
W = (Z + 1./Z)/2;
U(:,2) = imag(W);
U(:,1) = real(W);
