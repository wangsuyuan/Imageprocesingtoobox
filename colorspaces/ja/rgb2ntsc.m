%RGB2NTSC  RGB 値を NTSC 色空間に変換
%
%   YIQMAP = RGB2NTSC(RGBMAP) は、RGBMAP 内の M 行3列の RGB 値を NTSC 色空間
%   に変換します。YIQMAP は、各列に RGB カラーマップの色と等価な輝度 (Y)、
%   色差 (I,Q) を持つ M 行 3 列の行列です。
%
%   YIQ = RGB2NTSC(RGB) は、トゥルーカラーイメージ RGB を等価な NTSC 
%   イメージ YIQ に変換します。
%
%   クラスサポート
%   --------------
%   クラスサポート RGB は、uuint8, uint16, int16, double, single のいずれかです。
%   RGBMAP は double になります。出力は double です。
%
%   例
%   --
%      I = imread('board.tif');
%      J = rgb2ntsc(I);
%
%      map = jet(256);
%      newmap = rgb2ntsc(map);
%
%   参考 NTSC2RGB, RGB2IND, IND2RGB, IND2GRAY.


%   Copyright 1992-2008 The MathWorks, Inc.
