# CoffeePad 

SwiftUIアプリ「CoffeePad」のリポジトリです。

## セットアップ方法

```bash
git clone https://github.com/yourname/CoffeePad.git
cd CoffeePad
```

### InjectionIIIのセットアップ

この記事の環境構築の1と4を行う
https://qiita.com/y-hirakaw/items/1fba72344912d1f3912c

その後`Build Settings`の`User-Defined`に`EMIT_FRONTEND_COMMAND_LINES`を追加し、値を`YES`にする

### SwiftLintのセットアップ（ローカルで必要）

1. HomebrewでSwiftLintをインストール：

   ```bash
   brew install swiftlint
   ```
   
2. 以下の2点を **Xcodeのローカル設定で行ってください**：
   - `Build Phases` に `Run Script` を追加して、以下を記述：
     ```bash
     export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
     if which swiftlint >/dev/null; then
       swiftlint --config "${SRCROOT}/.swiftlint.yml"
     else
       echo "warning: SwiftLint not installed"
     fi
     ```
   - `Build Settings > ENABLE_USER_SCRIPT_SANDBOXING` を `NO` に変更する

この設定により、ビルド時に自動でSwiftLintが実行され、スタイル違反がXcodeに表示されるようになります。
