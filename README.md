# Widget Project

## 環境要件
### 必須バージョン
- Node.js: v18.18.0
- npm: 9.8.1
- Ruby: 3.2.2
- CocoaPods: 1.16.2
- iOS: 13.4以上

### 主要な依存関係
```json
{
  "dependencies": {
    "react": "18.2.0",
    "react-native": "0.71.8",
    "react-native-safe-area-context": "4.7.4"
  },
  "devDependencies": {
    "@types/react-native": "0.72.8"
  }
}
```

## プロジェクトセットアップ

### 1. 環境構築
```bash
# Node.jsのインストール
nodenv install 18.18.0
nodenv global 18.18.0

# Rubyのインストール
rbenv install 3.2.2
rbenv global 3.2.2

# CocoaPodsのインストール
gem install cocoapods -v 1.16.2
```

### 2. プロジェクトの依存関係インストール
```bash
# プロジェクトのルートディレクトリで
npm install --legacy-peer-deps
```

### 3. iOS設定
```bash
cd ios/widgetoshinoko
pod install
```

### 4. プロジェクト構造
widget/
├── ios/
│ └── widgetoshinoko/
│ ├── Podfile # iOSの依存関係管理
│ └── widgetoshinoko.xcworkspace # Xcodeワークスペース
├── src/ # ソースコード
├── App.tsx # メインアプリケーション
├── package.json # プロジェクト設定
└── react-native.config.js # React Native設定

### 5. 重要な設定ファイル

#### react-native.config.js
```javascript
module.exports = {
  project: {
    ios: {
      sourceDir: "./ios/widgetoshinoko"
    }
  }
}
```

#### Podfile
```ruby
require_relative '../../node_modules/react-native/scripts/react_native_pods'
require_relative '../../node_modules/@react-native-community/cli-platform-ios/native_modules'

platform :ios, '13.4'
prepare_react_native_project!

target 'widgetoshinoko' do
  config = use_native_modules!
  use_react_native!(
    :path => config[:reactNativePath],
    :hermes_enabled => false
  )

  pod 'react-native-safe-area-context', :path => '../../node_modules/react-native-safe-area-context'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.4'
      end
    end
  end
end
```

## トラブルシューティング

### Podfileの依存関係解決
boostライブラリのインストール問題に対する解決策：
1. システムレベルでのboostインストール
2. Podfileでの適切なパス設定
3. pod installコマンドの実行

### ビルド時の注意点
- 必ず`.xcworkspace`ファイルを使用してXcodeでプロジェクトを開く
- ビルド設定でチームの設定が必要
- 適切なデプロイメントターゲットの設定（iOS 13.4以上）

## ウィジェット開発ガイド
（ウィジェット実装完了後に追記予定）

## 開発フロー
1. 機能実装
2. ビルドとデバイステスト
3. ウィジェット連携機能の実装
4. パフォーマンス最適化

