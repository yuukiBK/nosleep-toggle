# nosleep-toggle

Mac のメニューバーから「ふたを閉じてもスリープしない」をワンクリックで切り替えるスイッチです。

| アイコン | 状態 |
|---|---|
| 月 | ふたを閉じると眠る（普通） |
| カップ | ふたを閉じても眠らない |

## 入れ方

ターミナルに貼って Enter。Mac のパスワードを1回聞かれます。

```
curl -fsSL https://raw.githubusercontent.com/yuukiBK/nosleep-toggle/main/install.sh | bash
```

- Homebrew が必要です（なければ https://brew.sh を先に）
- 再起動後もアイコンを出すには: アイコン → SwiftBar → Preferences → Launch at login

## 外し方

```
curl -fsSL https://raw.githubusercontent.com/yuukiBK/nosleep-toggle/main/uninstall.sh | bash
```

## 注意

- カップのまま鞄に入れると熱くなり、電池も減り続けます。持ち運ぶ前に月に戻してください。
- パスワードなしで動くのは `pmset -a disablesleep 0/1` の2つだけです（`/etc/sudoers.d/pmset-nosleep`）。
