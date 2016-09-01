%ipexbatchProcessFiles  イメージファイルの処理
%
%   SEQUENCE = ipexbatchProcessFiles(FILENAMES,FCN) は、FILENAMES 内にリスト
%   されるすべてのファイルでループ処理を行い、それぞれが関数 FCN を呼び出し、
%   SEQUENCE に結果を結合します。FCN は、シグネチャ B = FCN(A) を持つ関数に
%   対する関数ハンドルです。
%
%   バッチ処理デモ ipexbatch をサポートします。


%   Copyright 2007-2008 The MathWorks, Inc.
