%ICCFIND  ICC プロファイルを検索
%
%   [PROFILES, DESCRIPTIONS] = ICCFIND(DIRECTORY, PATTERN) は、Description 
%   フィールド内に与えられた PATTERN を使って、指定された DIRECTORY の ICC 
%   プロファイルのすべてを検索します。PROFILES はプロファイル構造体のセル
%   配列です。DESCRIPTIONS は、一致する Description フィールドのセル配列です。
%   ICCFIND は、大文字小文字を区別しないパターンマッチを行います。
%
%   [PROFILES, DESCRIPTIONS] = ICCFIND(DIRECTORY) は、与えられたディレクトリ
%   に対して、プロファイルとそれらの説明のすべてを返します。
%
%   注意:
%
%      性能を改善するために、ICCFIND はメモリ内の ICC プロファイルのコピーを
%      キャッシュします。プロファイルの追加や修正は、ICCFIND の結果を変更しない
%      可能性があります。キャッシュをクリアするには、"clear functions" コマンドを
%      発行してください。
%
%   例:
%
%      % (1) デフォルトの位置で ICC プロファイルのすべてを取得
%      profiles = iccfind(iccroot);
%
%      % (2) "RGB" を含むプロファイルの説明を検出
%      [profiles, descriptions] = iccfind(iccroot, 'rgb');
%
%   参考 ICCREAD, ICCROOT, ICCWRITE.


%   Copyright 1993-2008 The MathWorks, Inc.
