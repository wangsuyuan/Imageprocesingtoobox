%% Registering an Aerial Photo to an Orthophoto
% This example shows how to register an aerial photo to an orthophoto. Two
% images of the same scene can only be compared directly if they are in the same
% coordinate system. Image registration is the process of transforming one image
% into the coordinate system of another image.

% Copyright 2004-2013 The MathWorks, Inc. 

%% Step 1: Read Images
% The image |westconcordorthophoto.png| is an orthophoto that has already
% been registered to the ground. The image |westconcordaerial.png| is
% unregistered as it was taken from an airplane and is distorted relative
% to the orthophoto.

unregistered = imread('westconcordaerial.png');
figure, imshow(unregistered)
text(size(unregistered,2),size(unregistered,1)+15, ...
    'Image courtesy of mPower3/Emerge', ...
    'FontSize',7,'HorizontalAlignment','right');

%%
ortho = imread('westconcordorthophoto.png');
figure, imshow(ortho)
text(size(ortho,2),size(ortho,1)+15, ...
    'Image courtesy of Massachusetts Executive Office of Environmental Affairs', ...
    'FontSize',7,'HorizontalAlignment','right');
 
%% Step 2: Load and Add Control Points
% Four pairs of control points have already been picked.  Load these points
% from a MAT-file.  If you want to proceed with these points, go to Step 3:
% Infer Geometric Transformation.

load westconcordpoints

%%
% Optionally, edit or add to the pre-picked points using the Control Point
% Selection Tool (|cpselect|).  |cpselect| helps you pick pairs of
% corresponding control points. Control points are landmarks that you can find
% in both images, like a road intersection, or a natural feature.  The
% unregistered image is an RGB image but |cpselect| only takes grayscale
% images, so you will pass it one plane of the RGB image.
% 
%  cpselect(unregistered(:,:,1),'westconcordorthophoto.png',... 
%           movingPoints,fixedPoints) 

%%
% Save control points by choosing the *File* menu, then the *Save Points to
% Workspace* option. Save the points, overwriting variables |movingPoints| and
% |fixedPoints|.

%% Step 3: Infer Geometric Transformation
% Because we know that the unregistered image was taken from an airplane,
% and the topography is relatively flat, it is likely that most of the
% distortion is projective. |fitgeotrans| will find the parameters of the
% projective distortion that best fits the stray movingPoints and
% fixedPoints you picked. 

t_concord = fitgeotrans(movingPoints,fixedPoints,'projective');

%% Step 4: Transform Unregistered Image
% Even though the points were picked on one plane of the unregistered
% image, you can transform the entire RGB image. |imwarp| will apply the
% same transformation to each plane. Note that the specification of the
% 'OutputView' ensures the registered image will be aligned for elementwise
% comparison with the orthophoto.

Rfixed = imref2d(size(ortho));
registered = imwarp(unregistered,t_concord,'OutputView',Rfixed);
                      
%% Step 5: View Registered Image in Context of Orthophoto

figure, imshowpair(ortho,registered,'blend')

%%
% Compare visually how well the registered image overlays on the orthophoto.
% Try going back to *Step 2: Choose Control Points and using more than four
% pairs of points*. Are the results better? What if the points are clumped
% together?

%%
% If you want to experiment with larger images, follow the steps above to
% register |concordaerial.png| to |concordorthophoto.png|.


displayEndOfDemoMessage(mfilename)
