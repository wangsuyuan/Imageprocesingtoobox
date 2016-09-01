%XYZ2UINT16  XYZ 色値を uint16 に変換
%
%   XYZ16 = XYZ2UINT16(XYZ) は、M x 3 または M x N x 3 の XYZ 色値の配列を 
%   uint16 に変換します。XYZ16 は、XYZ と同じサイズになります。
%
%   XYZ 符号化変換
%   --------------
%   Image Processing Toolbox は、1931 CIE XYZ 値を含む倍精度の XYZ 配列の変換
%   に従います。uint16 の XYZ 配列は、符号なしの 16-bit の整数として XYZ 値で
%   表すために、ICC プロファイルの仕様 (ICC.1:2001-4, www.color.org) の変換に
%   従います。符号なし 8 ビット整数として XYZ 値の標準表現ではありません。
%   ICC 符号化変換は、この表を挿入します。
%
%       値 (X, Y, Z)           uint16 値
%       ------------------     ------------
%       0.0                        0
%       1.0                    32768
%       1.0 + (32767/32768)    65535
%
%   クラスサポート
%   --------------
%   XYZ は、uint16 の配列で、実数の非スパースでなければなりません。
%   XYZ16 は uint8 です。
%
%   例
%   --
%   XYZ 値を uint16 の符号化で変換します。
%
%       xyz2uint16([0.1 0.5 1.0])
%
%   参考 APPLYCFORM, LAB2UINT8, LAB2UINT16, LAB2DOUBLE, MAKECFORM,
%        WHITEPOINT, XYZ2DOUBLE.


%   Copyright 1993-2008 The MathWorks, Inc.
