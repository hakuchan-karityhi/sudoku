# 008 Play画面実装

## 概要
Play画面（View + ViewModel）を実装し、メインのゲームプレイ機能を提供する。

## 詳細要件
- 9x9グリッド表示
- 数字パッド（1-9）
- メモ機能切替
- タイマー表示
- マス選択・数字入力処理
- 重複ハイライト表示
- クリア判定・Result遷移

## 実装ポイント
- lib/features/play/presentation/ に配置
- グリッドWidget（9x9マス）
- 数字パッドWidget
- メモモード切替
- SudokuValidator統合
- リアルタイム入力検証

## TODO
- [ ] PlayView実装（メインUI）
- [ ] PlayViewModel実装（ゲーム状態管理）
- [ ] 9x9グリッドWidget実装
- [ ] 数字パッドWidget実装
- [ ] マス選択・入力処理実装
- [ ] メモ機能実装
- [ ] タイマー機能実装
- [ ] 重複ハイライト実装
- [ ] クリア判定・遷移実装
