%ISICC  完全なプロファイル構造の場合 true
%
%   ISICC(PF) は、構造体 PF が ICCREAD で返され、ICCWRITE と MAKECFORM で
%   使用する ICC プロファイルを表すために必要なフィールドを含む場合に 
%   TRUE を返します。ICC 仕様で必要なタグも含んでなければなりません。
%
%   特に、PF は "Header" フィールド、"Version" フィールド、"DeviceClass" 
%   フィールドと順に含まなければなりません。これらのフィールドは、www.color.org 
%   で利用可能な Version 2 (ICC.1:2001-04)、または Version 4 (ICC.1:2001-12) の
%   いずれかの ICC プロファイル仕様に従って、必要なタグのセットを決定するために
%   使われます。必要なタグのセットは、いずれかのバージョンの Section 6.3 で
%   与えられます。
%
%   例
%   --------
%   プロファイルを読み込んで有効性をテストします。
%
%       P = iccread('sRGB.icm');
%       TF = isicc(P)    % 有効なプロファイル
%
%   MATLAB の構造体を作成し、有効性をテストします。
%
%       S.name = 'Any Student';
%       S.score = 83;
%       S.grade = 'B+';
%       TF = isicc(S)    % 無効なプロファイル
%
%   参考 ICCREAD, ICCWRITE, MAKECFORM, APPLYCFORM.


%   Copyright 2004-2008 The MathWorks, Inc.
