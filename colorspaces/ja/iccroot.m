%ICCROOT  システムの ICC プロファイルのリポジトリを検索
%
%   ROOTDIR = ICCROOT は、ICC プロファイルを含むシステムディレクトリを返します。
%   追加のプロファイルは、他のディレクトリに格納されますが、これは、カラー
%   マネージメントシステムで使用されるデフォルトの場所です。
%
%   注意: 現在、Windows と Mac OS X のプラットフォームのみをサポートしています。
%
%   例:
%
%      % ルートディレクトリ内のプロファイルのすべての情報を返します。
%      iccfind(iccroot)
%
%   参考 ICCFIND, ICCREAD, ICCWRITE.


%   Copyright 1993-2008 The MathWorks, Inc.
