%% Creating a Gallery of Transformed Images
% This example shows many properties of geometric transformations by applying
% different transformations to a checkerboard image.

% Copyright 1993-2013 The MathWorks, Inc.

%% Overview
% A two-dimensional geometric transformation is a mapping that associates each
% point in a Euclidean plane with another point in a Euclidean plane. In these
% examples, the geometric transformation is defined by a rule that tells how to
% map the point with Cartesian coordinates (x,y) to another point with Cartesian
% coordinates (u,v). A checkerboard pattern is helpful in visualizing a
% coordinate grid in the plane of the input image and the type of distortion
% introduced by each transformation.

%% Image 1: Create Checkerboard
% |checkerboard| produces an image that has rectangular tiles and four unique
% corners, which makes it easy to see how the checkerboard image gets
% distorted by geometric transformations.
%
% After you have run this example once, try changing the image |I| to a larger
% checkerboard, or to your favorite image.

I = checkerboard(10,2); 
imshow(I)
title('original')

%% Image 2: Apply Nonreflective Similarity to Checkerboard
% Nonreflective similarity transformations may include a rotation, a scaling, and a
% translation. Shapes and angles are preserved. Parallel lines remain
% parallel. Straight lines remain straight.

%%
% For a nonreflective similarity, 
%
% $$[\begin{array}{c c}u\ v\end{array}] = [\begin{array}{c c}x\ y\ 1\end{array}]\,T$$

%%
% |T| is a 3-by-3 matrix that depends on 4 parameters.

% Try varying these 4 parameters.
scale = 1.2;       % scale factor
angle = 40*pi/180; % rotation angle
tx = 0;            % x translation
ty = 0;            % y translation

sc = scale*cos(angle);
ss = scale*sin(angle);

T = [ sc -ss  0;
      ss  sc  0;
      tx  ty  1];

%% 
% Since nonreflective similarities are a subset of affine transformations,
% create an |affine2d| object using:

t_nonsim = affine2d(T);
I_nonreflective_similarity = imwarp(I,t_nonsim,'FillValues',.3);

figure, imshow(I_nonreflective_similarity);
title('nonreflective similarity')

%%
% About Translation: If you change either |tx| or |ty| to a non-zero value,
% you will notice that it has no effect on the output image. If you want to
% see the coordinates that correspond to your transformation, including the
% translation, try this:

[I_nonreflective_similarity,RI] = imwarp(I,t_nonsim,'FillValues',.3);

figure, imshow(I_nonreflective_similarity,RI)
axis on
title('nonreflective similarity')

%%
% Notice that passing the output spatial referencing object |RI| from
% imwarp reveals the translation. To specify what part of the output image
% you want to see, use the 'OutputView' name-value pair in the
% |imwarp| function.

%% Image 3: Apply Similarity to Checkerboard
% In a similarity transformation, similar triangles map to similar
% triangles. Nonreflective similarity transformations are a subset of similarity
% transformations.
%
% For a similarity, the equation is the same as for a nonreflective similarity:
%
% $$[\begin{array}{c c}u\ v\end{array}] = [\begin{array}{c c}x\ y\ 1\end{array}]\,T$$
%

%%
% |T| is a 3-by-3 matrix that depends on 4 parameters plus an optional reflection.

% Try varying these parameters.
scale = 1.5;        % scale factor
angle = 10*pi/180; % rotation angle
tx = 0;            % x translation
ty = 0;            % y translation
a = -1;            % -1 -> reflection, 1 -> no reflection

sc = scale*cos(angle);
ss = scale*sin(angle);

T = [   sc   -ss  0;
      a*ss  a*sc  0;
        tx    ty  1];

%% 
% Since similarities are a subset of affine transformations, create an
% |affine2d| object using:

t_sim = affine2d(T);

% As in the translation example above, retrieve the output spatial
% referencing object |RI| from the |imwarp| function, and pass |RI| to
% |imshow| to reveal the reflection.
[I_similarity,RI] = imwarp(I,t_sim,'FillValues',.3);

figure, imshow(I_similarity,RI)
axis on
title('similarity')

%% Image 4: Apply Affine Transformation to Checkerboard
% In an affine transformation, the x and y dimensions can be scaled or sheared
% independently and there may be a translation, a reflection, and/or a
% rotation. Parallel lines remain parallel. Straight lines remain
% straight. Similarities are a subset of affine transformations.
% 
% For an affine transformation, the equation is the same as for a similarity and
% nonreflective similarity:
%
% $$[\begin{array}{c c}u\ v\end{array}] = [\begin{array}{c c}x\ y\ 1\end{array}]\,T$$
%
% |T| is 3-by-3 matrix, where all six elements of the first and second
% columns can be different. The third column must be [0;0;1].

% Try varying the definition of T.
T = [1  0.3  0; 
     1    1  0;
     0    0  1];
t_aff = affine2d(T);
I_affine = imwarp(I,t_aff,'FillValues',.3);

figure, imshow(I_affine)
title('affine')

%% Image 5: Apply Projective Transformation to Checkerboard
% In a projective transformation, quadrilaterals map to quadrilaterals.
% Straight lines remain straight. Affine transformations are a subset of
% projective transformations.
%
% For a projective transformation: 
%
% $$[\,\begin{array}{c c}up\ vp\ wp\end{array}\,] = [\,\begin{array}{c c}x\ y\ w\end{array}\,]\,T$$
%
% $$u = \frac{up}{wp}$$ 
%
% $$v = \frac{vp}{wp}$$
%
% T is a 3-by-3 matrix, where all nine elements can be different.
%
% $$T = \left[\begin{array}{c c c}A\;D\;G\\B\;E\;H\\C\;F\;I\end{array}\right]$$
%
% The above matrix equation is equivalent to these two expressions:
%
% $$u = \frac{Ax + By + C}{Gx + Hy + I}$$
%
% $$v = \frac{Dx + Ey + F}{Gx + Hy + I}$$
%
% Try varying any of the nine elements of |T|.

T = [1  0  0.008; 
     1  1  0.01;
     0  0  1   ];
t_proj = projective2d(T);   
I_projective = imwarp(I,t_proj,'FillValues',.3);

figure, imshow(I_projective)
title('projective')

%% Image 6: Apply Polynomial Transformation to Checkerboard
% In a polynomial transformation, polynomials in x and y define the mapping.
%
% For a second-order polynomial transformation: 
%
% $$[\begin{array}{c c}u\ v\end{array}] = [\begin{array}{c c} 1\ x\ y\ x*y\ x^2\ y^2\end{array}]\,T$$
%
% Both u and v are second-order polynomials of x and y. Each second-order
% polynomial has six terms.

fixedPoints  = reshape(randn(12,1),6,2);
movingPoints = fixedPoints; 
t_poly = fitgeotrans(movingPoints,fixedPoints,'polynomial',2);
I_polynomial = imwarp(I,t_poly,'FillValues',.3);

figure, imshow(I_polynomial)
title('polynomial')

%% Image 7: Apply Piecewise Linear Transformation to Checkerboard
% In a piecewise linear transformation, affine transformations are applied
% separately to triangular regions of the image. In this example the
% triangular region at the upper-left of the image remains unchanged while
% the triangular region at the lower-right of the image is stretched.

movingPoints = [10 10; 10 30; 30 30; 30 10]; 
fixedPoints  = [10 10; 10 30; 40 35; 30 10]; 
t_piecewise_linear = fitgeotrans(movingPoints,fixedPoints,'pwl'); 
I_piecewise_linear = imwarp(I,t_piecewise_linear);

figure, imshow(I_piecewise_linear)
title('piecewise linear')

%% Image 8: Apply Sinusoidal Transformation to Checkerboard
% This example and the following two examples show how you can create an
% explicit mapping |tmap_b| to associate each point in a regular grid (xi,yi)
% with a different point (u,v). This mapping |tmap_b| is used by |tformarray| to
% transform the image.

% locally varying with sinusoid
[nrows,ncols] = size(I);
[xi,yi] = meshgrid(1:ncols,1:nrows);
a1 = 5; % Try varying the amplitude of the sinusoids.
a2 = 3;
imid = round(size(I,2)/2); % Find index of middle element
u = xi + a1*sin(pi*xi/imid);
v = yi - a2*sin(pi*yi/imid);
tmap_B = cat(3,u,v);
resamp = makeresampler('linear','fill');
I_sinusoid = tformarray(I,[],resamp,[2 1],[1 2],[],tmap_B,.3);

figure, imshow(I_sinusoid)
title('sinusoid')

%% Image 9: Apply Barrel Transformation to Checkerboard
% Barrel distortion perturbs an image radially outward from its center.
% Distortion is greater farther from the center, resulting in convex sides.

% radial barrel distortion
xt = xi(:) - imid;
yt = yi(:) - imid;
[theta,r] = cart2pol(xt,yt);
a = .001; % Try varying the amplitude of the cubic term.
s = r + a*r.^3;
[ut,vt] = pol2cart(theta,s);
u = reshape(ut,size(xi)) + imid;
v = reshape(vt,size(yi)) + imid;
tmap_B = cat(3,u,v);
I_barrel = tformarray(I,[],resamp,[2 1],[1 2],[],tmap_B,.3);

figure, imshow(I_barrel)
title('barrel')

%% Image 10: Apply Pin Cushion Transformation to Checkerboard
% Pin-cushion distortion is the inverse of barrel distortion because the cubic
% term has a negative amplitude. Distortion is still greater farther from the
% center but it results in concave sides.

% radial pin cushion distortion
xt = xi(:) - imid;
yt = yi(:) - imid;
[theta,r] = cart2pol(xt,yt);
a = -.0005; % Try varying the amplitude of the cubic term.
s = r + a*r.^3;
[ut,vt] = pol2cart(theta,s);
u = reshape(ut,size(xi)) + imid;
v = reshape(vt,size(yi)) + imid;
tmap_B = cat(3,u,v);
I_pin = tformarray(I,[],resamp,[2 1],[1 2],[],tmap_B,.3);

figure, imshow(I_pin)
title('pin cushion')

%% Summary: Display All of the Geometric Transformations of Checkerboard

figure
subplot(5,2,1),imshow(I),title('original')
subplot(5,2,2),imshow(I_nonreflective_similarity),title('nonreflective similarity')
subplot(5,2,3),imshow(I_similarity),title('similarity')
subplot(5,2,4),imshow(I_affine),title('affine')
subplot(5,2,5),imshow(I_projective),title('projective')
subplot(5,2,6),imshow(I_polynomial),title('polynomial')
subplot(5,2,7),imshow(I_piecewise_linear),title('piecewise linear')
subplot(5,2,8),imshow(I_sinusoid),title('sinusoid')
subplot(5,2,9),imshow(I_barrel),title('barrel')
subplot(5,2,10),imshow(I_pin),title('pin cushion')

%%
% Note that |subplot| changes the scale of the images being displayed.


displayEndOfDemoMessage(mfilename)
