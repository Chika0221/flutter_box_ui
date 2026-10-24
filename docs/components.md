# box_ui PCアプリ向けコンポーネント一覧

2026-10-23 更新

## 対象アプリ

box_ui は「モジュール拡張型自作キーボード（コードネーム: Atelier Board）」のコンパニオンアプリで使う UI コンポーネントライブラリや。仕様は Obsidian の「モジュール拡張型自作キーボード 仕様書」にある（アプリ部分は 7〜8 節）。

アプリの前提:

- Flutter desktop で、対象は Windows と Linux の2つ（Web 版やモバイルは作らん）
- 常駐アプリで、入口はトレイ。メインウィンドウはサイドバーで画面を切り替える
- 画面は ①ホーム ②プロファイル ③キーマップ ④コマンド ⑤OLED ⑥設定 の6つ。ほかにモジュール詳細・割り当てダイアログ・キーコード選択・診断がある

## 概要

コンパニオンアプリを box_ui で組むには、43個のコンポーネントが要る。そのうち P0 の20個がそろえば、①ホーム・③キーマップ・割り当て表まで作れる。

P0 の20種は実装済み。P1 の Switch と P2 の Slider も既存実装がある。配置先は `lib/src/components/<name>/<name>.dart` で、公開するときは `lib/box_ui.dart` に export を足す。

優先度の意味:

- **P0**: これが無いとアプリの主要画面が作れん。最初に実装する
- **P1**: どこかの画面で使う。P0 の次に実装する
- **P2**: 未決事項しだいで要る。必要になったら実装する

## 基本・入力系

ユーザーが値を入れたり操作したりする部品や。PCでは全部、ホバーとフォーカスと無効の状態が要る。

| 優先度 | コンポーネント | 役割 | 使う画面 | PCで要るもの |
| --- | --- | --- | --- | --- |
| P0 | Button | 主要アクション | 全画面（再試行・適用・インポートなど） | ホバー・押下・無効・フォーカスリング、primary / secondary / ghost の種類（実装済み） |
| P0 | IconButton | 小さい操作 | ③レイヤーの複製・リセット、④編集・削除 | Tooltip との組み合わせ、正方形のヒット領域 |
| P0 | TextField | 1行の文字入力 | ②プロファイル名、④コマンド | プレースホルダー、エラー表示、Tab での移動、Enter で確定 |
| P0 | Checkbox | オンオフ | ⑤表示項目の選択、⑥設定 | ラベルクリックで切り替え、Space キー |
| P0 | Select (Dropdown) | 選択肢から1つ選ぶ | 割り当てダイアログ（種類・対象アプリ） | オーバーレイ表示、矢印キーと Esc の操作 |
| P1 | TextArea | 複数行の文字入力 | ④スクリプト編集 | 等幅フォント、スクロール |
| P1 | Switch (Toggle) | 設定のオンオフ | ⑥自動起動 | 切り替えアニメーション |
| P1 | Radio | 複数から1つ選ぶ | 割り当てダイアログの種類（アプリ音量 / コマンド / なし） | 矢印キーでグループ内を移動 |
| P1 | SegmentedControl | 少数の選択肢の切り替え | Radio の代わり、キーコード選択のカテゴリ | 矢印キーで移動 |
| P1 | SearchField | 検索入力 | キーコード選択、④コマンド一覧 | クリアボタン、Ctrl+F でフォーカス |
| P1 | Combobox | 入力しながら絞り込んで選ぶ | 割り当てダイアログの対象アプリ（実行中の音声セッション） | 候補のハイライト、一覧の更新 |
| P2 | Slider | 数値をドラッグで調整 | 音量の上限・下限を決めるなら要る | マウスホイールと矢印キーの対応 |
| P2 | NumberField | 数値入力 | OLED の更新間隔などを決めるなら要る | 上下ボタン、矢印キーで増減 |

## レイアウト・ナビゲーション系

メインウィンドウは「サイドバー＋メイン領域」の形や。そのため Box と Sidebar と ScrollView を先に作っとく。

| 優先度 | コンポーネント | 役割 | 使う画面 | PCで要るもの |
| --- | --- | --- | --- | --- |
| P0 | Box | 枠・背景・余白を持つ土台で、他の部品のベースになる | 全画面 | theme の fillColor / borderColor を使う（実装済み） |
| P0 | Divider | 区切り線 | 全画面 | 縦と横の両方 |
| P0 | ScrollView | スクロール領域 | 一覧系の画面全部 | 常に見えるスクロールバー、ホイール操作 |
| P0 | Sidebar (NavigationRail) | 画面の切り替え | メインウィンドウ（6項目） | 折りたたみ、選択中の表示、ホバー |
| P0 | Tabs | 同じ画面内の切り替え | ③レイヤーの切り替え | 数字キーや Ctrl+Tab での切り替え |
| P1 | Toolbar | アイコン操作を横に並べる | ③キーマップの上部、②プロファイル一覧 | 幅が足りんときは「…」にまとめる |
| P2 | StatusBar | ウィンドウ下部の状態表示 | 接続状態や現在レイヤーを常に出すなら要る | 左右に分けた配置 |
| P2 | SplitPane | ペインを分割して幅を変える | キーコード選択をダイアログでなく横に出すなら要る | 境界のドラッグ、カーソル変更、最小幅 |
| P2 | Accordion | 開閉できるセクション | キーコード選択のカテゴリ、⑥設定 | 開閉アニメーション |
| P2 | Breadcrumb | 階層の現在地 | ホーム → モジュール詳細 → キーマップのような移動 | 途中の階層をクリックで移動 |  

## 表示・フィードバック系

情報を見せたり、操作の結果を返したりする部品や。このアプリでは割り当て表（Table）と接続状態の表示が中心になる。

| 優先度 | コンポーネント | 役割 | 使う画面 | PCで要るもの |
| --- | --- | --- | --- | --- |
| P0 | Text (Label) | テーマに沿った文字表示 | 全画面 | 見出し・本文・キャプション・等幅のサイズ定義 |
| P0 | Icon | アイコン表示 | 全画面 | サイズと色を theme から取る |
| P0 | Dialog (Modal) | 確認や入力を求める | 割り当てダイアログ、キーコード選択、削除の確認 | Esc で閉じる、Enter で確定、フォーカスを中に閉じ込める |
| P0 | ListView (ListItem) | 項目の一覧 | ②プロファイル一覧、④コマンド一覧、診断 | ホバー、選択、矢印キー |
| P0 | Table (DataGrid) | 表形式のデータ | プロファイル編集（モジュール × 操作子の割り当て表） | 行のホバーとクリック、列幅の調整、ヘッダー固定 |
| P0 | StatusIndicator | OK / NG / 未接続を色と記号で出す | 起動時の接続チェック、診断、①ホーム | 色だけに頼らずアイコンも出す |
| P1 | Spinner | 待ち中の表示 | 接続チェック、キーマップの読み込み | サイズの種類 |
| P1 | ProgressBar | 進捗の表示 | キーマップの書き込み、インポート | 確定値と不定の両方 |
| P1 | Tooltip | ホバー時の補足説明 | ③キーの詳細、IconButton の説明 | 表示までの遅延（約500ms） |
| P1 | Toast (Notification) | アプリ内の一時的な通知 | 書き込み完了、エラー | 画面右下に出して自動で消す、クリックで画面移動 |
| P1 | Badge | 件数や状態の小さい表示 | ベイの「未割り当て」、Sidebar の項目 | アイコンに重ねる配置 |
| P1 | EmptyState | 中身が無いときの案内 | 初めて挿した組（割り当てなし）、コマンド0件 | 次にやる操作のボタンを置く |
| P2 | ContextMenu | 右クリックメニュー | ③キーの右クリック（コピー・リセット）を入れるなら要る | 右クリックで開く、区切り線、ショートカットの表示 |

## アプリ専用

コンパニオンアプリのために box_ui に足す部品や。描画だけを持って、vial.json の読み込みや HID 通信などのデータの取得はアプリ側に置く。

| 優先度 | コンポーネント | 役割 | 使う画面 | 要るもの |
| --- | --- | --- | --- | --- |
| P0 | KeyCap | キー1個の表示 | ③キーマップ | 2段のラベル（キーコード名・説明）、選択・ホバー・未適用・読み取り専用の状態 |
| P0 | KeyboardLayout | キー配列図を描く | ③キーマップ | 位置・幅・回転のついたキーのリストを受け取って KeyCap を並べる、ウィンドウ幅に合わせた拡大縮小 |
| P0 | KeycodePicker | キーコードを選ぶ | キーコード選択 | カテゴリ（基本キー / モディファイア / レイヤー / MODL・MODR / モジュール用カスタム）、名前で検索、矢印キーと Enter |
| P0 | BayMap | 本体の図と4ベイの装着状態 | ①ホーム | 手前L/R・外側L/R の4か所、空き / 装着中（モジュール名）の表示、ベイのクリック |
| P1 | LiveValueMeter | 入力値のライブ表示 | モジュール詳細（フェーダー位置・ノブの回転など） | 縦・横・回転の表示、値の滑らかな追従 |
| P1 | DiagnosticItem | 診断の1項目 | 起動時の診断画面、⑥診断 | 項目名・結果（StatusIndicator）・対処の案内・再試行ボタン（udev ルール、pactl info など） |
| P2 | OledPreview | OLED 表示のプレビュー | ⑤OLED（独立画面にするかは未決） | OLED の解像度に合わせたドット表示 |

## このアプリでは作らんもの

- **TitleBar**: OS 標準のタイトルバーで足りる
- **MenuBar**: 操作はサイドバーとトレイメニューで足りる
- **トレイアイコン・トレイメニュー・OS の通知**: Flutter の Widget やなくて OS の機能やから box_ui の範囲外。アプリ側で tray_manager などを使う
- **DatePicker**: 日付を入れる画面が無い
- **ColorPicker**: キーボードに LED が無い
- **Avatar**: 利用者は自分だけ
- **TreeView**: 階層を持つデータが無い

## PCアプリ特有の考慮点と実装順

全部のコンポーネントに共通で要るのは、ホバー・フォーカス・キーボード操作の3つや。これはコンポーネントごとに書かず、先に共通の仕組みとして作っとくと楽になる。

### 共通で用意しときたいもの

- **インタラクション状態**: hover / pressed / focused / disabled をまとめて扱う仕組み。今の Button は `onHover` を自前で持っとるから、ここを共通化すると他の部品でも使い回せる
- **フォーカス**: Tab / Shift+Tab での移動と、フォーカスリングの見た目。Flutter の `FocusableActionDetector` が使える
- **キーボード操作**: Enter / Space / Esc / 矢印キーの割り当て。`Shortcuts` と `Actions` で組む
- **マウスカーソル**: ボタンは click、境界は resize、無効時は forbidden など。`MouseRegion.cursor` で指定する
- **オーバーレイ**: Select・Combobox・Tooltip・Dialog・Toast で使う。`OverlayPortal` を共通の土台にするとええ
- **密度とサイズ**: PCはマウス操作やからモバイルより詰めてええ。目安は高さ 28〜32px、余白 4px 刻み
- **テーマのトークン**: 今の `BoxCustomTheme` に、文字サイズ・余白・角丸・ホバー色・状態色（OK / 警告 / エラー）も足していく

### 実装順の提案

1. 共通の仕組み（インタラクション状態・フォーカス・カーソル）と theme のトークン追加
2. Box・Text・Icon・Divider・StatusIndicator（土台になる表示部品）
3. Button の残りの状態・IconButton・TextField・Checkbox（基本の入力）
4. ScrollView・Sidebar・Tabs・ListView（メインウィンドウの骨組み）
5. KeyCap → KeyboardLayout と BayMap（③キーマップと①ホームの中心）
6. オーバーレイの土台 → Select・Dialog → KeycodePicker
7. Table（割り当て表）
8. P1 を必要な順に（DiagnosticItem・Spinner・Toast・Combobox あたりから）

## 未決事項

- [x] KeyboardLayout のデータは BKeyGeometry で受け取る（vial.json の解釈はアプリ側）
- [ ] キーマップの書き込みタイミング（即時か「適用」ボタンか。仕様書の未決13）。「適用」ボタン方式なら KeyCap の未適用状態が要る
- [ ] OLED 画面を独立させるか（仕様書の未決12）。独立させへんなら OledPreview はモジュール詳細に入る
- [ ] material_ui を依存に入れとるけど、どこまで使うか（Widgets だけで組むか）
- [ ] デザインファイル（DESIGN.md や .pen）をいつ用意するか

## P0 実装の利用方法

`package:box_ui/box_ui.dart` から公開 API を利用できる。既存の命名に合わせて `BButton`、`BTextField`、`BSelect<T>`、`BBox`、`BTable` などの `B` 接頭辞を使う。Sidebar は従来の `SideBar` を維持した。

- 色は `BoxThemeData` の accent / background / fillColor / borderColor / foreground / onAccent を使う。角丸は 8px、基本の余白は 4px 単位。見出し 20px、本文 14px、キャプション 12px、等幅文字をテーマに追加した。`BIcon` は `iconSize` を標準サイズにし、明示した `BIconSize` を優先する。
- `BButton` は primary / secondary / ghost に対応。操作コールバックが null なら無効。`BCheckBox.onClick` は従来名を維持し、任意の `label` も同じクリック領域に含める。
- 入力、Select、Dialog、Tooltip は Flutter の Material 標準機構を利用する。アプリのルートに `MaterialApp` を用意し、その配下で `BoxTheme` を適用する。追加パッケージへの依存はない。標準コントロールには内部で BoxTheme の配色を適用する。
- `BTextField` は controller / focusNode / placeholder / errorText / onSubmitted を受け取る。`BSelect<T>` は `BSelectOption<T>` のリストと、現在値・変更コールバックを受け取る。
- `BDialog.show(context, dialog: ...)` は標準のモーダルルートを使い、Tab のフォーカスを閉じ込め、Esc で閉じる。`onConfirm` は Enter の処理に使う。テキスト入力内の Enter は `onSubmitted` に同じ確定処理を渡す。内部のボタンにフォーカスした Enter はそのボタンを実行する。
- `BScrollView` は自身で ScrollController を管理し、常時表示のスクロールバーを付ける。外部 controller も指定でき、その場合の dispose は呼び出し側が担当する。
- `SideBar` は items / selectedIndex / onSelected で制御し、折りたたみは内部で管理する。従来の header / body も利用できる。
- `BTabs` は選択状態を親で管理する。フォーカスがタブ内にある間、左右キー、Ctrl+Tab / Ctrl+Shift+Tab、1〜9 キーで切り替える。`BListView` は上下キーでフォーカスを移動し、Enter / Space で選択する。
- `BTable`、`BListView`、`BKeycodePicker` は親から有限の高さを与える。`BTable` は縦方向のヘッダー固定、横スクロール、ヘッダー右端のドラッグによる列幅変更に対応。行データは Widget の配列で、通信や割り当てモデルは持たない。
- `BKeyGeometry` の x / y / width / height はキー単位、rotation はキー中心を軸にしたラジアン。負の座標と回転後の外接領域も含めて `BKeyboardLayout` が表示サイズを計算する。ファームウェアの配列定義の解釈は呼び出し側が担当する。
- `BKeyCap` は selected / pending / readOnly を受け取り、pending は色と記号の両方で表示する。`BKeycodePicker` は `BKeycode` のカテゴリを選び、コード・名前を検索し、上下キーと Enter で選択できる。カテゴリとキーコードの一覧はアプリ側から渡す。
- `BBayMap` は `Map<BBay, String>` を受け取り、未指定のベイは空きとして表示する。

P0 の実装とテストは `codex/p0-<コンポーネント名>` ごとのブランチに分けている。共通基盤は `codex/p0-foundation`。依存する実装と公開 API を各段階で利用できるよう、ブランチは順に積んでいる。

### 補色による強調

全コンポーネントに任意の `emphasis` 引数を追加した。

```dart
BButton(
  label: '適用',
  emphasis: BEmphasis.strong,
  onClick: apply,
)

BEmphasisScope(
  emphasis: BEmphasis.strong,
  child: Column(
    children: [
      BText('注目してほしい操作'),
      BButton(label: '実行', onClick: execute),
      BButton(
        label: '戻る',
        emphasis: BEmphasis.normal,
        onClick: back,
      ),
    ],
  ),
)
```

- `BEmphasis.normal` は従来の accent 配色、`BEmphasis.strong` は complementary 配色。`emphasis` が未指定（null）なら直近の `BEmphasisScope` を継承し、スコープもなければ normal になる。明示した normal は外側の strong を解除する。
- Button の primary / secondary / ghost や、選択・無効状態とは独立して指定できる。strong では主要色だけでなく、その色から派生する面色・枠色・フォーカスリングと、塗りの上の白黒文字も合わせて切り替わる。BText は補色の文字表示、BIcon は補色の標準色、ScrollView は補色のスクロールバーになる。
- BIcon の foregroundColor / foragoundColor / backgroundColor など、明示した色は強調指定より優先する。任意の Widget を受け取る場所では、独自に指定した色まで上書きしない。
- エラー・警告・成功の状態色は、strong にしても変わらない。StatusIndicator の状態色や KeyCap の pending 表示は意味を維持する。
- スコープは子コンポーネントへ継承され、Dialog の別ルートへも引き継ぐ。strong を重ねても補色が元の accent に戻ることはない。テーマの差し替えにも追従する。
- `BoxTheme.of(context)` は常に元のテーマを返す。独自コンポーネントで強調を反映したい場合は `BoxTheme.emphasizedOf(context)` を使う。強調用の派生値は `BoxThemeData.emphasized` からも取得できる。
