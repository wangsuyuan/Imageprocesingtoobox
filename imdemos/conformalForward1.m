function X = conformalForward1(U, ~)
% conformalForward1 Forward transformation with positive square root.
%
% Supports conformal transformation example, ConformalMappingImageExample.m
% ("Exploring a Conformal Mapping").

% Copyright 2005-2013 The MathWorks, Inc. 

W = complex(U(:,1),U(:,2));
Z = W + sqrt(W.^2 - 1);
X(:,2) = imag(Z);
X(:,1) = real(Z);
