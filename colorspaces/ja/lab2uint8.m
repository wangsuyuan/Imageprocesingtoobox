%LAB2UINT8  L*a*b* 色値を uint8 に変換
%
%   LAB8 = LAB2UINT8(LAB) は、色値の M x 3、または、M x N x 3 の配列をクラス 
%   uint8 に変換します。LAB8 は、LAB と同じサイズになります。
%
%   L*a*b* 符号化変換
%   -----------------
%   Image Processing Toolbox は、1976 CIE L*a*b* の値を含む倍精度の L*a*b* 
%   配列の変換に従います。uint8 または uint16 である L*a*b* 配列は、符号なしの 
%   8-bit または 16-bit の整数として L*a*b* 値で表すために、ICC プロファイルの
%   仕様 (ICC.1:2001-4, www.color.org) の変換に従います。ICC 符号化変換は、
%   これらの表が挿入されます:
%
%       Value (L*)             uint8 value         uint16 value
%       ----------             -----------         ------------
%         0.0                    0                     0
%       100.0                  255                 65280
%       100.0 + (25500/65280)  none                65535
%
%       Value (a* or b*)       uint8 value         uint16 value
%       ----------------       -----------         ------------
%       -128.0                   0                     0
%          0.0                 128                 32768
%        127.0                 255                 65280
%        127.0 + (255/256)     none                65535
%
%   クラスサポート
%   --------------
%   LAB は、uint8, uint16, double の配列で、実数の非スパースでなければ
%   なりません。LAB8 は uint8 です。
%
%   例
%   --
%   full の強度の中間色 (白) を double から uint8 に変換します。
%
%       lab2uint8([100 0 0])
%
%   参考 APPLYCFORM, LAB2DOUBLE, LAB2UINT16, MAKECFORM, WHITEPOINT,
%        XYZ2DOUBLE, XYZ2UINT16.


%   Copyright 1993-2008 The MathWorks, Inc.
