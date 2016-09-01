%XYZ2DOUBLE  XYZ 色値を倍精度に変換
%
%   XYZD = XYZ2DOUBLE(XYZ) は、M x 3 または M x N x 3 の XYZ 色値の配列を 
%   double に変換します。XYZD は、XYZ と同じサイズになります。
%
%   XYZ 符号化変換
%   --------------
%   Image Processing Toolbox は、1931 CIE XYZ 値を含む倍精度の XYZ 配列の
%   変換に従います。uint16 の XYZ 配列は、符号なしの 16-bit の整数として 
%   XYZ 値で表すために、ICC プロファイルの仕様 (ICC.1:2001-4, www.color.org) 
%   の変換に従います。符号なし 8 ビット整数として XYZ 値の標準表現では
%   ありません。ICC 符号化変換は、この表を挿入します。
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
%   XYZD は double です。
%
%   例
%   --
%   uint16 で符号化された XYZ 値を double に変換します。
%
%       xyz2double(uint16([100 32768 65535]))
%
%   参考 APPLYCFORM, LAB2DOUBLE, LAB2UINT8, LAB2UINT16, MAKECFORM,
%        WHITEPOINT, XYZ2UINT16.


%   Copyright 1993-2008 The MathWorks, Inc.
