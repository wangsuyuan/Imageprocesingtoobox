% Image Processing Toolbox --- デモとサンプルイメージ
%
%   iptdemos          - Image Processing Toolbox デモのインデックス
%
%   ipexaerial        - 航空写真から正射写真へレジスタリング
%   ipexangle         - 交点角度の測定
%   ipexbatch         - 並列なイメージファイルのバッチ処理
%   ipexblind         - ブラインドデコンボリューションフィルタを使ってイメージのブレを除去
%   ipexcell          - イメージの区分化を使ってセルの検出
%   ipexcheckerboard  - 変換したイメージのギャラリーを作成
%   ipexconformal     - 等角写像の調査
%   ipexcontrast      - コントラスト強調テクニック
%   ipexfabric        - L*a*b* 色空間を用いた色ベースの区分
%   ipexhistology     - K-Means クラスタリングを用いたカラーベースの区分
%   ipexlanstretch    - 複数のスペクトルのカラー合成イメージの強調
%   ipexlucy          - Lucy-Richardson フィルタを使ってイメージのブレを除去
%   ipexndvi          - マルチスペクトル画像内の植生を検出
%   ipexnormxcorr2    - 正規化した相互相関を使ってイメージのレジストレーション
%   ipexpendulum      - 動いている振り子の長さを見つける
%   ipexprops         - グレースケールイメージ内の領域の測定
%   ipexradius        - テープのロールの半径の測定
%   ipexreconstruct   - 投影データからイメージの復元
%   ipexregularized   - 正則化フィルタを用いたイメージのデブラリング
%   ipexrice          - 不均一な照明の補正
%   ipexrotate        - 歪んだ画像の回転とスケールを見つける
%   ipexroundness     - 丸いオブジェクトの認識
%   ipexshear         - イメージの付加と剪断を同時に行う
%   ipexsnow          - 雪片の粒度分布
%   ipextexturefilter - テクスチャフィルタを使ったテクスチャ分割
%   ipextraffic       - 交通量のビデオ内の車の検出
%   ipexwatershed     - マーカをコントロールしたwatershedセグメンテーション
%   ipexwiener        - Wiener フィルタを使ってイメージのブレを除去
%
% 拡張した例での補助 M-ファイル
%   ipexbatchDetectCells           - バッチ処理の例で使用
%   ipexbatchProcessFiles          - バッチ処理の例で使用
%   ipexConformalForward1          - 等角写像の例で使用
%   ipexConformalForward2          - 等角写像の例で使用
%   ipexConformalInverse           - 等角写像の例で使用
%   ipexConformalInverseClip       - 等角写像の例で使用
%   ipexConformalSetupInputAxes    - 等角写像の例で使用
%   ipexConformalSetupOutputAxes   - 等角写像の例で使用
%   ipexConformalShowLines         - 等角写像の例で使用
%   ipexConformalShowCircles       - 等角写像の例で使用
%   ipexConformalShowInput         - 等角写像の例で使用
%   ipexConformalShowOutput        - 等角写像の例で使用
%   ipexpropsSynthesizeImage       - 等角写像の例で使用
%
% サンプルのMAT-ファイル
%   imdemos.mat           - デモで使用するイメージ
%   pendulum.mat          - ipexpendulum で使用
%   regioncoordinates.mat - ipexfabric で使用
%   trees.mat             - 風景図のイメージ
%   westconcordpoints.mat - 航空写真によるレジストレーションの例で使用
%   mristack.mat          - IMPLAY のヘルプの例で使用
%   cellsequence.mat      - IMPLAY のヘルプの例で使用
%
% サンプルの FITS イメージ
%   solarspectra.fts
%
% サンプルの HDR イメージ
%   office.hdr
%
% サンプルの JPEG イメージ
%   football.jpg
%   greens.jpg
%
% サンプルの PNG イメージ
%   bag.png
%   blobs.png
%   circles.png
%   coins.png
%   concordorthophoto.png
%   concordaerial.png
%   fabric.png
%   gantrycrane.png
%   glass.png
%   hestain.png
%   liftingbody.png
%   onion.png
%   pears.png
%   peppers.png
%   pillsetc.png
%   rice.png
%   saturn.png
%   snowflakes.png
%   tape.png
%   testpat1.png
%   text.png
%   tissue.png
%   westconcordorthophoto.png
%   westconcordaerial.png
%
% サンプルTIFFイメージ
%   AT3_1m4_01.tif
%   AT3_1m4_02.tif
%   AT3_1m4_03.tif
%   AT3_1m4_04.tif
%   AT3_1m4_05.tif
%   AT3_1m4_06.tif
%   AT3_1m4_07.tif
%   AT3_1m4_08.tif
%   AT3_1m4_09.tif
%   AT3_1m4_10.tif
%   autumn.tif
%   board.tif
%   cameraman.tif
%   canoe.tif
%   cell.tif
%   circbw.tif
%   circuit.tif
%   eight.tif
%   forest.tif
%   kids.tif
%   logo.tif
%   mandi.tif
%   m83.tif
%   moon.tif
%   mri.tif
%   paper1.tif
%   pout.tif
%   shadow.tif
%   spine.tif
%   tire.tif
%   trees.tif
%
% サンプルのランドサットイメージ
%   littlecoriver.lan
%   mississippi.lan
%   montana.lan
%   paris.lan
%   rio.lan
%   tokyo.lan
%
% サンプルの AVI ファイル
%   rhinos.avi
%   traffic.avi
%
% 写真提供者
%   board:
%
%     Computer circuit board, courtesy of Alexander V. Panasyuk,
%     Ph.D., Harvard-Smithsonian Center for Astrophysics.
%
%   cameraman:
%
%     Copyright Massachusetts Institute of Technology.  Used with
%     permission.
%
%   cell:
%   AT3_1m4_01:
%   AT3_1m4_02:
%   AT3_1m4_03:
%   AT3_1m4_04:
%   AT3_1m4_05:
%   AT3_1m4_06:
%   AT3_1m4_07:
%   AT3_1m4_08:
%   AT3_1m4_09:
%   AT3_1m4_10:
%
%     Cancer cells from rat prostates, courtesy of Alan W. Partin, M.D,
%     Ph.D., Johns Hopkins University School of Medicine.
%
%   circuit:
%
%     Micrograph of 16-bit A/D converter circuit, courtesy of Steve
%     Decker and Shujaat Nadeem, MIT, 1993.
%
%   concordaerial and westconcordaerial:
%
%     Visible color aerial photographs courtesy of mPower3/Emerge.
%
%   concordorthophoto and westconcordorthophoto:
%
%     Orthoregistered photographs courtesy of Massachusetts Executive Office
%     of Environmental Affairs, MassGIS.
%
%   forest:
%
%     Photograph of Carmanah Ancient Forest, British Columbia, Canada,
%     courtesy of Susan Cohen.
%
%   gantrycrane:
%
%     Gantry crane used to build a bridge, courtesy of Jeff Mather.
%
%   hestain:
%
%     Image of tissue stained with hemotoxylin and eosin (H&E) at 40X
%     magnification, courtesy of Alan W. Partin, M.D., Ph.D., Johns Hopkins
%     University School of Medicine.
%
%   liftingbody:
%
%     Public domain image of M2-F1 lifting body in tow, courtesy of NASA,
%     1964-01-01, Dryden Flight Research Center #E-10962, GRIN database
%     #GPN-2000-000097.
%
%   mandi:
%
%     Bayer pattern-encoded image taken by a camera with a sensor
%     alignment of 'bggr', courtesy of Jeremy Barry.
%
%   m83:
%
%     M83 spiral galaxy astronomical image courtesy of Anglo-Australian
%     Observatory, photography by David Malin.
%
%   moon:
%
%     Copyright Michael Myers.  Used with permission.
%
%   pears:
%
%     Copyright Corel.  Used with permission.
%
%   tissue:
%
%     Cytokeratin CAM 5.2 stain of human prostate tissue, courtesy of
%     Alan W. Partin, M.D, Ph.D., Johns Hopkins University School
%     of Medicine.
%
%   trees:
%
%     Trees with a View, watercolor and ink on paper, copyright Susan
%     Cohen.  Used with permission.
%
%   LAN files:
%
%     Permission to use Landsat TM data sets provided by Space Imaging,
%     LLC, Denver, Colorado.
%
%   saturn:
%
%     Public domain image courtesy of NASA, Voyager 2 image, 1981-08-24,
%     NASA catalog #PIA01364
%
%   solarspectra:
%
%     Solar spectra image courtesy of Ann Walker, Boston University.
%
% 参考 COLORSPACES, IMAGES, IMAGESLIB, IMUITOOLS, IPTFORMATS, IPTUTILS.


%   Copyright 1993-2008 The MathWorks, Inc.  
