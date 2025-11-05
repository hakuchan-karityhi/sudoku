# 009 Result画面実装

## 概要
Result画面（View + ViewModel）を実装し、クリア結果の表示と次のアクションを提供する。

## 詳細要件
- クリアタイム表示
- 難易度表示
- 使用スクリプト表示
- 完了ボタン（Homeに戻る）
- 結果データの管理

## 実装ポイント
- lib/features/result/presentation/ に配置
- シンプルな結果表示UI
- タイム・難易度・スクリプトの受け渡し
- Home画面への遷移処理

## TODO
- [ ] ResultView実装（結果表示UI）
- [ ] ResultViewModel実装（結果状態管理）
- [ ] 結果データ受け渡し処理
- [ ] 完了ボタン・遷移実装
