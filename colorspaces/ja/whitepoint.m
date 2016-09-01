%WHITEPOINT  標準光源の XYZ 色を返す
%
%   XYZ = WHITEPOINT(STR) は、Y = 1 になるようにスケーリングされた XYZ の
%   値の 3 要素の行ベクトルを返します。STR は、希望するホワイトポイントを
%   指定し、この表の文字列のいずれかになります。
%
%       STR          光源
%       ---          ----------
%       'a'          CIE 標準光源 A
%       'c'          CIE 標準光源 C
%       'd50'        CIE 標準光源 D50
%       'd55'        CIE 標準光源 D55
%       'd65'        CIE 標準光源 D65
%       'icc'        ICC 標準プロファイル接合空間光源;
%                        D50 の 16 ビット分数近似
%
%   XYZ = WHITEPOINT は、XYZ = WHITEPOINT('icc') と同じです。
%
%   例
%   --
%       xyz = whitepoint
%
%   参考 APPLYCFORM, LAB2DOUBLE, LAB2UINT8, LAB2UINT16, MAKECFORM,
%        XYZ2DOUBLE, XYZ2UINT16.


%   Copyright 1993-2008 The MathWorks, Inc.
