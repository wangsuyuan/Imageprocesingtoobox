%% Registering Multimodal MRI Images
% This example shows how you can use |imregister| to automatically
% align two magnetic resonance images (MRI) to a common coordinate
% system using intensity-based image registration.  Unlike some other
% techniques, it does not find features or use control points.
% Intensity-based registration is often well-suited for medical and
% remotely sensed imagery.

% Copyright 2011-2013 The MathWorks, Inc.

%% Step 1: Load Images
% This example uses two magnetic resonance (MRI) images of a knee.
% The fixed image is a spin echo image, while the moving image is a
% spin echo image with inversion recovery.  The two sagittal slices
% were acquired at the same time but are slightly out of alignment.

fixed = dicomread('knee1.dcm');
moving = dicomread('knee2.dcm');

%%
% The |imshowpair| function is a useful function for visualizing
% images during every part of the registration process.  Use it to see
% the two images individually in a montage fashion or display them
% stacked to show the amount of misregistration.

figure, imshowpair(moving, fixed, 'montage')
title('Unregistered')

%%
% In the overlapping image from |imshowpair|, gray areas correspond to
% areas that have similar intensities, while magenta and green areas
% show places where one image is brighter than the other.  In some
% image pairs, green and magenta areas don't always indicate
% misregistration, but in this example it's easy to use the color
% information to see where they do.

figure, imshowpair(moving, fixed)
title('Unregistered')


%% Step 2: Set up the Initial Registration
% The |imregconfig| function makes it easy to pick the correct
% optimizer and metric configuration to use with |imregister|. These
% two images have different intensity distributions, which suggests a
% multimodal configuration.

[optimizer,metric] = imregconfig('multimodal');

%%
% The distortion between the two images includes scaling, rotation,
% and (possibly) shear.  Use an affine transformation to register the
% images.
%
% It's very, very rare that |imregister| will align images perfectly
% with the default settings.  Nevertheless, using them is a useful way
% to decide which properties to tune first.

movingRegisteredDefault = imregister(moving, fixed, 'affine', optimizer, metric);

figure, imshowpair(movingRegisteredDefault, fixed)
title('A: Default registration')

%% Step 3: Improve the Registration
% The initial registration is not very good. There are still significant
% regions of poor alignment, particularly along the right edge.  Try to
% improve the registration by adjusting the optimizer and metric
% configuration properties.
%
% The optimizer and metric variables are objects whose properties
% control the registration.

disp(optimizer)
disp(metric)

%%
% The InitialRadius property of the optimizer controls the initial step
% size used in parameter space to refine the geometric transformation. When
% multi-modal registration problems do not converge with the default
% parameters, the InitialRadius is a good first parameter to adjust. Start
% by reducing the default value of InitialRadius by a scale factor of 3.

optimizer.InitialRadius = optimizer.InitialRadius/3.5;

movingRegisteredAdjustedInitialRadius = imregister(moving, fixed, 'affine', optimizer, metric);
figure, imshowpair(movingRegisteredAdjustedInitialRadius, fixed)
title('Adjusted InitialRadius')

%%
% Adjusting the InitialRadius had a positive impact. There is a noticeable
% improvement in the alignment of the images at the top and right edges.

%%
% The MaximumIterations property of the optimizer controls the maximum
% number of iterations that the optimizer will be allowed to take.
% Increasing the MaximumIterations allows the registration search to run
% longer and potentially find better registration results. Does the
% registration continue to improve if the InitialRadius from the last step
% is used with a large number of interations?

optimizer.MaximumIterations = 300;
movingRegisteredAdjustedInitialRadius300 = imregister(moving, fixed, 'affine', optimizer, metric);

figure, imshowpair(movingRegisteredAdjustedInitialRadius300, fixed)
title('B: Adjusted InitialRadius, MaximumIterations = 300, Adjusted InitialRadius.')

%%
% Further improvement in registration were achieved by reusing the
% InitialRadius optimizer setting from the previous registration and
% allowing the optimizer to take a large number of iterations.

%% Step 4: Use Initial Conditions to Improve Registration
% Optimization based registration works best when a good initial condition
% can be given for the registration that relates the moving and fixed
% images. A useful technique for getting improved registration results is
% to start with more simple transformation types like 'rigid', and then use
% the resulting transformation as an initial condition for more complicated
% transformation types like 'affine'.
%
% The function |imregtform| uses the same algorithm as imregister, but
% returns a geometric transformation object as output instead of a
% registered output image. Use |imregtform| to get an initial
% transformation estimate based on a 'similarity' model
% (translation,rotation, and scale).
%
% The previous registration results showed in improvement after modifying
% the MaximumIterations and InitialRadius properties of the optimizer.
% Keep these optimizer settings while using initial conditions while
% attempting to refine the registration further.

tformSimilarity = imregtform(moving,fixed,'similarity',optimizer,metric);

%%
% Because the registration is being solved in the default MATLAB coordinate
% system, also known as the intrinsic coordinate system, obtain the default
% spatial referencing object that defines the location and resolution of
% the fixed image.

Rfixed = imref2d(size(fixed));

%%
% Use |imwarp| to apply the geometric transformation output from
% |imregtform| to the moving image to align it with the fixed image. Use
% the 'OutputView' option in |imwarp| to specify the world limits and
% resolution of the output resampled image. Specifying Rfixed as the
% 'OutputView' forces the resampled moving image to have the same
% resolution and world limits as the fixed image.

movingRegisteredRigid = imwarp(moving,tformSimilarity,'OutputView',Rfixed);
figure, imshowpair(movingRegisteredRigid, fixed);
title('C: Registration based on similarity transformation model.');

%% 
% The "T" property of the output geometric transformation defines the
% transformation matrix that maps points in moving to corresponding
% points in fixed.

tformSimilarity.T

%%
% Use the 'InitialTransformation' Name/Value in imregister to refine this
% registration by using an 'affine' transformation model with the 'similarity'
% results used as an initial condition for the geometric transformation.
% This refined estimate for the registration includes the possibility of
% shear.

movingRegisteredAffineWithIC = imregister(moving,fixed,'affine',optimizer,metric,...
    'InitialTransformation',tformSimilarity);
figure, imshowpair(movingRegisteredAffineWithIC,fixed);
title('D: Registration from affine model based on similarity initial condition.');

%%
% Using the 'InitialTransformation' to refine the 'similarity' result of
% |imregtform| with a full affine model has also yielded a nice
% registration result.

%% Step 5: Deciding When Enough is Enough
% Comparing the results of running |imregister| with different
% configurations and initial conditions, it becomes apparent that there are
% a large number of input parameters that can be varied in imregister, each
% of which may lead to different registration results.

figure
imshowpair(movingRegisteredDefault, fixed)
title('A - Default settings.');

figure
imshowpair(movingRegisteredAdjustedInitialRadius, fixed)
title('B - Adjusted InitialRadius, 100 Iterations.');

figure
imshowpair(movingRegisteredAdjustedInitialRadius300, fixed)
title('C - Adjusted InitialRadius, 300 Iterations.');

figure
imshowpair(movingRegisteredAffineWithIC, fixed)
title('D - Registration from affine model based on similarity initial condition.');

%%
% It can be difficult to quantitatively compare registration results
% because there is no one quality metric that accurately describes the
% alignment of two images. Often, registration results must be judged
% qualitatively by visualizing the results. In The results above, the
% registration results in C) and D) are both very good and are difficult to
% tell apart visually.

%% Step 6: Alternate Visualizations
% Often as the quality of multimodal registrations improve it becomes more
% difficult to judge the quality of registration visually.  This is because
% the intensity differences can obscure areas of misalignment.  Sometimes
% switching to a different display mode for |imshowpair| exposes hidden
% details.  (This is not always the case.)

displayEndOfDemoMessage(mfilename)
