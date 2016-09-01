% Image Processing Toolbox --- colorspaces
%
% カラーマップの取り扱い
%   brighten       - カラーマップの明るさを変更 (MATLAB Toolbox)
%   cmpermute      - カラーマップ内の色の再配列 (MATLAB Toolbox)
%   cmunique       - インデックス付きイメージのカラーマップ内の不必要な色を削除 (MATLAB Toolbox)
%   colormap       - カラールックアップテーブルの設定または取得 (MATLAB Toolbox)
%   imapprox       - 少ない色でインデックス付きイメージを近似 (MATLAB Toolbox)
%   rgbplot        - RGB カラーマップ成分のプロット (MATLAB Toolbox)
%
% 色空間変換.
%   applycform     - デバイスに依存しない色空間変換を適用
%   hsv2rgb        - HSV 値を RGB 色空間へ変換 (MATLAB Toolbox)
%   iccfind        - ICC プロファイルを検索
%   iccread        - ICC カラープロファイルの読み込み
%   iccroot        - システムの ICC プロファイルのリポジトリを検索
%   iccwrite       - ICC カラープロファイルの書き込み
%   isicc          - 完全なプロファイル構造の場合 true
%   lab2double     - L*a*b* 色値を double に変換
%   lab2uint16     - L*a*b* 色値を uint16 に変換
%   lab2uint8      - L*a*b* 色値を uint8 に変換
%   makecform      - デバイスに依存しない色空間変換を作成 (CFORM)
%   ntsc2rgb       - NTSC 値を RGB 色空間へ変換
%   rgb2hsv        - RGB 値を HSV 色空間へ変換 (MATLAB Toolbox).
%   rgb2ntsc       - RGB 値を NTSC 色空間へ変換
%   rgb2ycbcr      - RGB 値を YCbCr 色空間へ変換
%   whitepoint     - 標準光源の XYZ 色を返す
%   xyz2double     - XYZ 色値を double に変換
%   xyz2uint16     - XYZ 色値を uint16 に変換
%   ycbcr2rgb      - YCbCr 値を RGB 色空間へ変換
%
% ICC カラープロファイル
%   lab8.icm       - 8-bit Lab プロファイル
%   monitor.icm    - 標準モニタプロファイル
%                    Sequel Imaging, Inc. の許可を得て使用
%   sRGB.icm       - sRGB プロファイル
%                    Hewlett-Packard の許可を得て使用
%   swopcmyk.icm   - CMYK 入力プロファイル
%                    Eastman Kodak の許可を得て使用


%   Copyright 2008-2009 The MathWorks, Inc.  
