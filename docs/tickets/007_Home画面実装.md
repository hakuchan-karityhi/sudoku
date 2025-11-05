# 007 Home画面実装

## 概要
Home画面（View + ViewModel）を実装し、ゲーム開始選択とスクリプト切替機能を提供する。

## 詳細要件
- デイリー開始ボタン
- 通常Playボタン
- 言語/スクリプト切替機能
- デイリー/通常Playの状態管理
- Play画面への遷移

## 実装ポイント
- lib/features/home/presentation/ に配置
- Riverpod StateNotifier使用
- デイリーパズル取得処理
- 難易度/スクリプト選択UI（通常Play時）
- ローディング状態・エラー状態表示

## TODO
- [ ] HomeView実装（UI構築）
- [ ] HomeViewModel実装（状態管理）
- [ ] デイリー開始処理実装
- [ ] 通常Play処理実装
- [ ] スクリプト切替機能実装
- [ ] 遷移ロジック実装
