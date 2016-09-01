function ax = conformalSetupOutputAxes(ax)
% conformalSetupOutputAxes Set up axes in the output/'z' plane.
%
% Supports conformal transformation example, ConformalMappingImageExample.m
% ("Exploring a Conformal Mapping").

% Copyright 2005-2013 The MathWorks, Inc. 

set(ax, 'DataAspectRatio',[1 1 1],...
		'XLimMode','manual',...
        'YLimMode','manual',...
		'PlotBoxAspectRatioMode', 'manual');
set(ax,'XLim',[-2.5 2.5]);
set(ax,'YLim',[-2.5 2.5]);
set(ax,'Xlabel',text('String','Re(z)'));
set(ax,'Ylabel',text('String','Im(z)'));
set(ax,'Title',text('String','Output Plane'));
