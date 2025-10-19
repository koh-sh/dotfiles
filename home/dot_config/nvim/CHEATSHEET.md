# Neovim プラグイン チートシート

> リーダーキー: `<Space>`

## ファイル探索（Telescope）

| キー | 説明 |
|------|------|
| `<Space>ff` | ファイル検索 |
| `<Space>fg` | 全文検索（grep） |
| `<Space>fb` | 開いているバッファ一覧 |
| `<Space>fh` | ヘルプタグ検索 |
| `<Space>fs` | LSPシンボル検索 |
| `<Space>fd` | 診断一覧 |

**Telescope内の操作:**
- `<C-j>` / `<C-k>`: 次/前の候補
- `<Enter>`: 選択して開く
- `<Esc>`: キャンセル

## ファイルエクスプローラー（Neo-tree）

| キー | 説明 |
|------|------|
| `<Space>e` | Neo-treeのトグル |

**Neo-tree内の操作:**
- `<Enter>`: ファイルを開く
- `a`: 新規ファイル/フォルダ作成
- `d`: 削除
- `r`: リネーム
- `y`: コピー
- `x`: カット
- `p`: ペースト
- `R`: リフレッシュ
- `?`: ヘルプ表示

## LSP機能（コード補完・解析）

| キー | 説明 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gr` | 参照一覧 |
| `gi` | 実装へジャンプ |
| `K` | ホバー情報（関数説明など） |
| `<C-k>` | シグネチャヘルプ（引数情報） |
| `<Space>rn` | リネーム |
| `<Space>ca` | コードアクション |
| `<Space>f` | フォーマット |

**LSPコマンド:**
- `:LspInfo` - LSPの状態確認
- `:LspRestart` - LSPサーバー再起動

## コード補完（nvim-cmp）

| キー | 説明 |
|------|------|
| `<Tab>` | 次の候補 |
| `<S-Tab>` | 前の候補 |
| `<C-Space>` | 補完メニュー表示 |
| `<Enter>` | 候補を確定 |
| `<C-e>` | 補完をキャンセル |
| `<C-b>` / `<C-f>` | ドキュメントスクロール |

## エラー・診断（Trouble）

| キー | 説明 |
|------|------|
| `<Space>xx` | 診断一覧（Trouble） |
| `<Space>xd` | 現在のバッファの診断 |
| `<Space>xl` | ロケーションリスト |
| `<Space>xq` | Quickfixリスト |

## フォーマット（conform.nvim）

| キー | 説明 |
|------|------|
| `<Space>fm` | 手動フォーマット |
| 保存時 | 自動フォーマット（デフォルト有効） |

**コマンド:**
- `:ConformInfo` - フォーマッター情報表示

## Markdown（markdown-preview）

| キー | 説明 |
|------|------|
| `<Space>mp` | Markdownプレビュートグル |

**コマンド:**
- `:MarkdownPreview` - プレビュー開始
- `:MarkdownPreviewStop` - プレビュー停止

## ウィンドウ操作（カスタムキーマップ）

### ウィンドウ分割
| キー | 説明 |
|------|------|
| `<Space>sv` | 縦分割 |
| `<Space>sh` | 横分割 |
| `<Space>se` | ウィンドウサイズを均等に |
| `<Space>sx` | 現在のウィンドウを閉じる |

### ウィンドウ間移動
| キー | 説明 |
|------|------|
| `<C-h>` | 左のウィンドウへ |
| `<C-j>` | 下のウィンドウへ |
| `<C-k>` | 上のウィンドウへ |
| `<C-l>` | 右のウィンドウへ |

## ターミナル

| キー | 説明 |
|------|------|
| `<Space>t` | ターミナルを開く |
| `<Esc>` (ターミナル内) | ノーマルモードに戻る |

## 検索ハイライト解除

| キー | 説明 |
|------|------|
| `<Space><Space>` | 検索ハイライト解除 |

## Claude Code AI

| キー | 説明 |
|------|------|
| `<Space>ac` | Claude Codeトグル |
| `<Space>af` | Claude Codeにフォーカス |
| `<Space>ar` | セッション再開 |
| `<Space>aC` | 会話継続 |
| `<Space>am` | モデル選択 |
| `<Space>ab` | 現在のバッファを追加 |
| `<Space>as` | 選択範囲をClaudeに送信（ビジュアルモード） |
| `<Space>as` | Neo-tree内でファイル追加 |
| `<Space>aa` | Diff承認 |
| `<Space>ad` | Diff拒否 |

## プラグイン管理

### Lazy.nvim
| コマンド | 説明 |
|----------|------|
| `:Lazy` | プラグインマネージャーを開く |
| `:Lazy sync` | プラグインの同期（インストール/更新） |
| `:Lazy clean` | 未使用プラグインの削除 |
| `:Lazy update` | プラグインの更新 |

### Mason（LSPサーバー管理）
| コマンド | 説明 |
|----------|------|
| `:Mason` | Masonを開く |
| `:MasonInstall <name>` | LSPサーバーをインストール |
| `:MasonUninstall <name>` | LSPサーバーをアンインストール |

## トラブルシューティング

### LSPが動かない
1. `:Mason`でLSPサーバーがインストールされているか確認
2. `:LspInfo`でLSPの状態を確認
3. 該当言語のファイルを開き直す

### プラグインがインストールされない
1. `:Lazy sync`を実行
2. エラーメッセージを確認
3. Neovimを再起動

### 補完が出ない
1. LSPが起動しているか`:LspInfo`で確認
2. インサートモードで`<C-Space>`を押してみる
3. 該当言語のLSPサーバーがインストールされているか確認

## 対応言語とLSPサーバー

| 言語 | LSPサーバー | 自動インストール |
|------|------------|----------------|
| Go | gopls | ✓ |
| Python | pyright | ✓ |
| Ruby | ruby_lsp | ✓ |
| Terraform | terraformls | ✓ |
| Ansible | ansiblels | ✓ |
| YAML | yamlls | ✓ |

## フォーマッター（別途インストールが必要）

```bash
# Go
go install golang.org/x/tools/cmd/goimports@latest

# Python
pip install black isort

# Ruby
gem install rubocop

# JavaScript/TypeScript/YAML/JSON/Markdown
npm install -g prettier
```

---

**設定ファイル:** `~/.config/nvim/init.lua`
