# 005 Repositoryパターン実装

## 概要
PuzzleRepositoryインターフェースとLocalDataSourceを実装し、データアクセス層の基盤を構築する。

## 詳細要件
- PuzzleRepositoryインターフェース定義（getDaily, getByDifficulty）
- LocalDataSource実装（assets JSON読み込み）
- RepositoryImplの実装（MVP版：LocalDataSource使用）
- Clean Architectureの依存関係逆転を確保

## 実装ポイント
- lib/core/domain/repositories/ にインターフェース配置
- lib/core/data/ に実装配置
- MVPではLocalDataSourceのみ使用（βでRemoteDataSource追加）
- Future/asyncパターンで非同期処理

## TODO
- [ ] PuzzleRepositoryインターフェース定義
- [ ] LocalDataSourceクラス実装（rootBundle使用）
- [ ] PuzzleRepositoryImpl実装（LocalDataSource使用）
- [ ] Riverpod Provider設定
- [ ] エラーハンドリング実装
