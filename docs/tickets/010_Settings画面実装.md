# 010 Settings画面実装

## 概要
Settings画面（View + ViewModel）を実装し、アプリ設定の変更機能を提供する。

## 詳細要件
- UI言語切替
- 設定保存機能
- 保存・キャンセル操作

## 実装ポイント
- lib/features/settings/presentation/ に配置
- ローカルストレージ（SharedPreferences）使用
- 言語設定の永続化
- シンプルな設定UI

## TODO
- [ ] SettingsView実装（設定UI）
- [ ] SettingsViewModel実装（設定管理）
- [ ] 言語切替機能実装
- [ ] 設定保存処理実装
- [ ] ローカルストレージ統合
