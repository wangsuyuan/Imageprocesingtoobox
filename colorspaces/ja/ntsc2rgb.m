%NTSC2RGB  NTSC 色値を RGB 色空間に変換
%
%   RGBMAP = NTSC2RGB(YIQMAP) は、カラーマップ YIQMAP 内の M 行 3 列の NTSC 
%   (テレビ) 色値を RGB 色空間に変換します。YIQMAP は M 行 3 列で、列方向に 
%   NTSC の輝度 (Y) と色差 (I と Q) の色要素を含んでいる場合 RGBMAP はそれらの
%   色と等価の赤、緑、青の値を含む M 行 3 列の行列になります。RGBMAP と YIQMAP は
%   共に、0.0 から 1.0 の間に入る強度値を含んでいます。解像度 0.0 は成分が全く
%   ないことを意味し、解像度 1.0 はその成分で満たされていることを意味しています。
%
%   RGB = NTSC2RGB(YIQ) は、NTSC イメージ YIQ を等価なトゥルーカラーイメージ 
%   RGB に変換します。
%
%   クラスサポート
%   -------------
%   入力イメージ、またはカラーマップは、クラス double でなければなりません。
%   出力は、クラス double です。
%
%   例
%   -------
%   RGB イメージを NTSC に変換して復元します。
%
%       RGB = imread('board.tif');
%       NTSC = rgb2ntsc(RGB);
%       RGB2 = ntsc2rgb(NTSC);
%
%   参考 RGB2NTSC, RGB2IND, IND2RGB, IND2GRAY.


%   Copyright 1992-2008 The MathWorks, Inc.
