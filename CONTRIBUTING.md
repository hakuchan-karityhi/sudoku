# Contributing Guidelines

このリポジトリへの貢献に興味を持っていただきありがとうございます。以下のルールに従って、開発を円滑に進めましょう。

## ブランチ戦略

- main: 常にデプロイ可能な状態
- feature/*: 機能追加用ブランチ（例: feature/solver-ui）
- fix/*: バグ修正用ブランチ（例: fix/board-rendering)

## コミットメッセージ

- Conventional Commits を推奨します
  - feat: 新機能
  - fix: バグ修正
  - docs: ドキュメント
  - refactor: リファクタリング
  - chore/test/build/ci など適宜

## Pull Request

- PR テンプレートに沿って説明・スクリーンショット等を添付
- 小さく、レビューしやすい単位で作成
- CI が通ってからレビュー依頼

## Issue

- バグ報告は再現手順・期待値・実結果・環境情報を含めてください
- 機能要望は動機・受け入れ条件（AC）・スコープ外を含めると良いです

## コードスタイル

- `.editorconfig` に従う
- 不要なコメントやデッドコードは削除
- 変数名・関数名は意味のある名称を使用

## セキュリティ/プライバシー

- 機密情報（API Keys など）をコミットしない
- `.env` は必ず `.gitignore` 対象
