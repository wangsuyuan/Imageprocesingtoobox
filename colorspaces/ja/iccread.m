%ICCREAD  ICC カラープロファイルの読み込み
%
%   P = ICCREAD(FILENAME) は、FILENAME で指定されたファイルから 
%   International Color Consortium (ICC) のカラープロファイルデータを
%   読み込みます。ファイルは、組み込みの ICC プロファイルが含まれる 
%   ICC プロファイルのファイル、または TIFF ファイルのいずれかになります。
%   ICCREAD は、色空間変換を計算するための MAKECFORM と APPLYCFORM の
%   どちらが使用可能かを指定する構造体 P のプロファイル情報を返します。
%   P は、ICCWRITE で新規の ICC プロファイルに書き込むこともできます。
%   ICC 仕様書のバージョン 2 と バージョン 4 の両方をサポートします。
%
%   ICCREAD のリファレンスページには、構造体 P のフィールドに関する追加情報が
%   あります。完全な情報は、バージョン 2 については仕様書 ICC.1:2001-04 を、
%   バージョン 4 については ICC.1:2001-12 を、または、バージョン 4.2.0.0 
%   (www.color.org で利用可能な) については ICC.1:2004-10 を参照してください。
%
%   例
%   --
%   sRGB プロファイルを読み込みます。
%
%       P = iccread('sRGB.icm');
%
%   参考 ISICC, ICCWRITE, MAKECFORM, APPLYCFORM.


%   Copyright 2002-2009 The MathWorks, Inc.
