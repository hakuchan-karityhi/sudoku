# 004 SudokuValidator UseCase実装

## 概要
数独のルール判定を行うSudokuValidator UseCaseを実装する。

## 詳細要件
- isValid()：指定マスへの値配置が可能かチェック（行・列・ブロック重複）
- isCompleted()：盤面が完成しているかチェック（全マス埋まり＋ルール遵守）
- 入力時のリアルタイム検証機能
- クリア判定機能

## 実装ポイント
- lib/features/play/domain/usecases/ に配置
- 行・列・3x3ブロックの重複チェックを実装
- 効率的なアルゴリズムで高速判定
- Domain層のBoardエンティティを使用

## TODO
- [ ] SudokuValidatorクラス作成
- [ ] isValidメソッド実装（行・列・ブロックチェック）
- [ ] isCompletedメソッド実装（完成チェック）
- [ ] ヘルパーメソッドの実装（ブロック座標計算など）
- [ ] 単体テスト作成
