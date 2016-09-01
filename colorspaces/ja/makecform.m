%MAKECFORM  デバイスに依存しない色空間変換構造体の作成
%
%   C = MAKECFORM(TYPE) は、TYPE で指定される色空間変換で定義される色変換
%   構造体 C を作成します。変換を実行するために、APPLYCFORM 関数に引数として
%   色変換構造体を渡します。TYPE は、これらの文字列のいずれかです。
%
%       'lab2lch'   'lch2lab'   'upvpl2xyz'   'xyz2upvpl'
%       'uvl2xyz'   'xyz2uvl'   'xyl2xyz'     'xyz2xyl'
%       'xyz2lab'   'lab2xyz'   'srgb2xyz'    'xyz2srgb'
%       'srgb2lab'  'lab2srgb'  'srgb2cmyk'   'cmyk2srgb'
%
%   (下記の色空間表は、これらの略語を定義します)
%
%   xyz2lab, lab2xyz, srgb2lab の変換に対して、ホワイトポイントとして知られる
%   参照光源の値を自由に指定することができます。
%   シンタックス C = MAKECFORM(TYPE,'WhitePoint',WP) を使用してください。
%   ここで、WP は、Y = 1 となるようスケーリングされた XYZ 値の 1×3 のベクトルです。
%   デフォルトは、CIE 光源の D50 で、ここで、International Color Consortium の
%   仕様でもある ICC.1:2001-04 と ICC.1:2001-12 で定義されたデフォルトの光源です。
%   WP ベクトルを作成するために、WHITEPOINT 関数を使用できます。
%
%   srgb2cmyk と cmyk2srgb 変換は、sRGB IEC61966-2.1 と "Standard Web Offset 
%   Printing" (SWOP) CMYK 間のデータを変換します。この変換タイプの場合、
%   オプションとして描画意図を指定することができます。
%   シンタックス C = MAKECFORM('srgb2cmyk', 'RenderingIntent', INTENT) または 
%   C = MAKECFORM('cmyk2srgb', 'RenderingIntent', INTENT) を使用してください。
%   ここで、INTENT は、これらのいずれかを指定する文字列です。
%
%       'AbsoluteColorimetric'  'Perceptual'
%       'RelativeColorimetric'  'Saturation'
%
%   'Perceptual' は、デフォルトの描画意図です。描画意図の詳細は、MAKECFORM 
%   リファレンスページを参照してください。
%
%   C = MAKECFORM('icc', SRC_PROFILE, DEST_PROFILE) は、2 つの ICC プロファイラ
%   をベースに色変換を作成します。SRC_PROFILE と DEST_PROFILE は、ICCREAD で
%   返される ICC プロファイル構造体です。
%
%   C = MAKECFORM('icc', SRC_PROFILE, DEST_PROFILE,
%   'SourceRenderingIntent', SRC_INTENT, 'DestRenderingIntent',
%   DEST_INTENT) は、2 つの ICC カラープロファイラをベースに色変換を作成します。
%   SRC_INTENT と DEST_INTENT は、ソースと用途プロファイルの対応する描画意図を
%   指定します。(描画意図の文字列のリストについては、上記の表を参照してください)
%   'Perceptual' は、ソースと用途プロファイルの両方に対するデフォルトの描画意図です。
%
%   CFORM = MAKECFORM('clut', PROFILE, LUTTYPE) は、ICC カラープロファイルに
%   含まれるカラールックアップテーブル (CLUT) に基づいて色変換を作成します。
%   PROFILE は、ICCREAD で返される ICC プロファイル構造体です。LUTTYPE は、
%   PROFILE 構造体内のどの CLUT を使用するかを指定します。これらの文字列の
%   いずれかになります:
%
%       'AToB0'    'AToB1'    'AToB2'    'AToB3'    'BToA0'
%       'BToA1'    'BToA2'    'BToA3'    'Gamut'    'Preview0'
%       'Preview1' 'Preview2'
%
%   デフォルトは、'AToB0' です。
%
%   CFORM = MAKECFORM('mattrc', MATTRC, 'Direction', DIR) は、RGB-to-XYZ 行列
%   と RGB Tone Reproduction Curves を含む構造体 MATTRC に基づき色変換を作成
%   します。MATTRC は、通常、ICC カラープロファイルに含まれるタグに基づき、
%   ICCREAD から返される ICC プロファイル構造体の 'MatTRC' フィールドです。
%   DIR は 'forward' または 'inverse' のいずれかで、MatTRC が順方向 
%   (RGB から XYZ) 、または、逆方向 (XYZ から RGB) に適用されるかを指定します。
%
%   CFORM = MAKECFORM('mattrc', PROFILE, 'Direction', DIR) は、与えられた 
%   ICC プロファイル構造体 PROFILE の 'MatTRC' フィールドに基づき色変換を作成
%   します。DIR は 'forward' または 'inverse' のいずれかで、MatTRC が順方向 
%   (RGB から XYZ) 、または、逆方向 (XYZ から RGB) に適用されるかを指定します。
%
%   CFORM = MAKECFORM('mattrc', PROFILE, 'Direction', DIR, 
%   'RenderingIntent', INTENT) と同様ですが、指定する描画意図のオプションを
%   追加します。INTENT は、以下の文字列のいずれかを指定しなければなりません。
%
%       'RelativeColorimetric' [デフォルト]
%       'AbsoluteColorimetric'
%
%   'AbsoluteColorimetric' が指定された場合、色調はプロファイルの Media 
%   White Point ではなく、完全拡散を参照します。
%
%   CFORM = MAKECFORM('graytrc', PROFILE, 'Direction', DIR) は、ICC カラー
%   プロファイル構造体 PROFILE の 'GrayTRC' フィールドとして含まれる単一
%   チャンネルの調子再現曲線 (Tone Reproduction Curve) に基づきモノクロ変換を
%   作成します。DIR は 'forward' または 'inverse' のいずれかで、変換が順方向 
%   (デバイスから PCS)、または、逆方向 (PCS からデバイス) に適用されることを
%   指定します。("Device" は、モノクロデバイスと通信するグレースケール信号を
%   参照します。"PCS" は、ICC プロファイルの接合空間で、PROFILE.Header 内の 
%   'ConnectionSpace' フィールドに依存し、XYZ か Lab のいずれかになります。)
%
%   CFORM = MAKECFORM('graytrc', PROFILE, 'Direction', DIR, 
%   'RenderingIntent', INTENT) と同様ですが、指定する描画意図のオプションを
%   追加します。INTENT は、以下の文字列のいずれかを指定しなければなりません。
%
%       'RelativeColorimetric' [デフォルト]
%       'AbsoluteColorimetric'
%
%   'AbsoluteColorimetric' が指定された場合、色調はプロファイルの Media 
%   White Point ではなく、完全拡散を参照します。


%   Copyright 2002-2008 The MathWorks, Inc.
