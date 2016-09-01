%RGB2YCBCR  RGB 値を YCBCR 色空間に変換
%
%   YCBCRMAP = RGB2YCBCR(MAP) は、MAP の RGB 値を YCBCR 色空間に変換します。
%   MAP は M 行 3 列の配列でなければなりません。YCBCRMAP は、YCBCR の各列に
%   輝度 (Y) と色差 (Cb と Cr) 色値を含む M 行 3 列の行列です。各行は、
%   RGB カラーマップの対応する行と等価なカラーを表します。
%
%   YCBCR = RGB2YCBCR(RGB) は、トゥルーカラーイメージ RGB を YCBCR 色空間での
%   等価なイメージへ変換します。RGB は M x N x 3 の配列でなければなりません。
%
%   入力が int8 の場合、YCBCR は uint8 です。ここで、Y は範囲 [16 235] で、
%   Cb と Cr は範囲 [16 240] です。入力が double の場合、Y は範囲 
%   [16/255 235/255] で、Cb と Cr は範囲 [16/255 240/255] です。入力が 
%   uint16 の場合、Y は範囲 [4112 60395] で、Cb と Cr は範囲 [4112 61680] です。
%
%   クラスサポート
%   --------------
%   入力が RGB イメージの場合、uint8, uint16, double のいずれかになります。
%   入力がカラーマップの場合、double でなければなりません。出力は入力と同じ
%   クラスになります。
%
%   例
%   --
%   RGB イメージを YCbCr に変換します。
%
%      RGB = imread('board.tif');
%      YCBCR = rgb2ycbcr(RGB);
%
%   RGB 色空間を YCbCr に変換します。
%
%      map = jet(256);
%      newmap = rgb2ycbcr(map);
%
%   参考 NTSC2RGB, RGB2NTSC, YCBCR2RGB.


%   Copyright 1993-2008 The MathWorks, Inc.  
