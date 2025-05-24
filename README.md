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

### SwiftFormatのセットアップ（初期設定のまま使用）

1. Swift Package Manager（SPM）で下記のURLを追加：

   ```
   https://github.com/nicklockwood/SwiftFormat
   ```

3. `Build Phases` に Run Script を追加し、以下を記述：

   ```bash
   if [[ -e "${BUILD_ROOT}/../../SourcePackages/checkouts/SwiftFormat/CommandLineTool/swiftformat" ]]; then
     "${BUILD_ROOT}/../../SourcePackages/checkouts/SwiftFormat/CommandLineTool/swiftformat" "${SRCROOT}/CoffeePad"
   else
     echo "warning: SwiftFormat not found"
   fi
   ```

この設定により、ビルド時にSwiftFormatが初期設定で自動実行され、コードが整形されます。
また、Xcodeの `CoffeePad`フォルダを右クリック > SwiftFormatPlugin から手動整形も可能になります。
