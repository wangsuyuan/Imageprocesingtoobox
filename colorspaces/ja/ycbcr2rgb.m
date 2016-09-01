%YCBCR2RGB  YCbCr 値を RGB 色空間へ変換
%
%   RGBMAP = YCBCR2RGB(YCBCRMAP) は、カラーマップ YCBCRMAP 内の YCbCr 値を 
%   RGB 色空間へ変換します。YCBCRMAP が M x 3 であり、YCbCr 輝度 (Y) と
%   色差 (Cb と Cr) 値を列として含む場合、RGBMAP は、それらの色に等価な
%   赤、緑、青の値を含む M x 3 の行列です。
%
%   RGB = YCBCR2RGB(YCBCR) は、YCBCR イメージを等価なトゥルーカラーイメージ 
%   RGB に変換します。
%
%   クラスサポート
%   --------------
%   入力が YCbCr イメージの場合、uint8、uint16 または double のいずれかにな
%   り、出力イメージは、入力イメージと同じクラスになります。
%   入力がカラーマップの場合、入力と出力のカラーマップは共に double です。
%
%   例
%   --
%   イメージを RGB 空間から YCbCr 空間に変換し、元に戻します。
%
%       rgb = imread('board.tif');
%       ycbcr = rgb2ycbcr(rgb);
%       rgb2 = ycbcr2rgb(ycbcr);
%
%   参考 NTSC2RGB, RGB2NTSC, RGB2YCBCR.


%   Copyright 1993-2008 The MathWorks, Inc.  
