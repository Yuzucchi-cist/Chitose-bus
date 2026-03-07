# 千歳科技大 シャトルバス時刻表アプリ

千歳科学技術大学のシャトルバス時刻表を表示する Flutter アプリと、その GAS バックエンドのリポジトリです。

## システム構成

```
[大学Webサイト]
      ↓ PDF自動取得
[GAS バックエンド] ── JSON API ──→ [Flutter アプリ]
  gas/Code.gs                        flutter_app/
```

- **GAS バックエンド** (`gas/`): 大学Webサイトから時刻表PDFを自動取得・解析し、JSON形式で返す Google Apps Script
- **Flutter フロントエンド** (`flutter_app/`): GAS APIを呼び出して時刻表を表示する iOS/Android アプリ

## ディレクトリ構成

```
.
├── gas/                  # Google Apps Script バックエンド
│   ├── Code.gs           # メインスクリプト
│   └── appsscript.json   # GAS プロジェクト設定
├── flutter_app/          # Flutter フロントエンド
│   ├── lib/              # アプリ本体
│   ├── test/             # テスト（unit / widget / golden）
│   ├── integration_test/ # 統合テスト
│   ├── TESTING.md        # テスト実行ガイド
│   └── pubspec.yaml
└── .github/
    └── workflows/
        ├── test.yml      # Flutter テスト自動実行（push / PR）
        └── ios-build.yml # iOS IPA ビルド
```

## セットアップ

### GAS バックエンド

1. [Google Apps Script](https://script.google.com/) で新規プロジェクトを作成
2. `gas/Code.gs` の内容を貼り付け
3. 「サービス」→ **Drive API** を有効化（高度な Google サービス）
4. **ウェブアプリとしてデプロイ**（アクセス: 全員）
5. デプロイ後に発行されるエンドポイント URL を控える

#### GitHub Variables の設定

iOS ビルド時に `--dart-define` でエンドポイント URL を渡すため、リポジトリの Variables に登録します。

`Settings → Secrets and variables → Actions → Variables` に以下を追加:

| 変数名 | 値 |
|--------|-----|
| `DART_DEFINE_CONTENTS` | `{"GAS_ENDPOINT_URL": "<デプロイURL>"}` |

### Flutter アプリ

#### 前提条件

- Flutter SDK（stable チャンネル）
- Dart SDK（Flutter に同梱）

#### セットアップ手順

```bash
cd flutter_app

# 依存パッケージをインストール
flutter pub get

# コード生成（freezed / json_serializable）
dart run build_runner build --delete-conflicting-outputs
```

#### `.dart_defines` の設定（ローカル開発用）

ローカルでビルド・実行する場合は、リポジトリルートに `.dart_defines` を作成します（`.gitignore` 済み）:

```json
{
  "GAS_ENDPOINT_URL": "<GAS デプロイURL>"
}
```

#### 実行

```bash
flutter run --dart-define-from-file=../.dart_defines
```

## ビルド・テスト

### テスト

```bash
cd flutter_app
flutter test
```

詳細なテスト手順（Golden更新・統合テスト・fake_async など）は [`flutter_app/TESTING.md`](flutter_app/TESTING.md) を参照してください。

### iOS IPA ビルド

GitHub Actions の **iOS Build** ワークフロー（`workflow_dispatch`）から実行します。

- `build_id`: ビルド識別子（任意の文字列）
- `configuration`: `Debug`（デフォルト）または `Release`
- `use_signing`: コード署名を有効にする場合は `true`

署名なしビルドで生成された `.ipa` は AltStore / Sideloadly でサイドロードできます。

## バージョン

**v0.1.0** （[リリースノート](https://github.com/Yuzucchi-cist/Chitose-bus/releases/tag/v0.1.0)）
