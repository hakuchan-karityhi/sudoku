# 003 Domain層エンティティ実装

## 概要
Domain層のビジネスロジック用エンティティ（Cell, Board, Difficulty, Script）を実装する。

## 詳細要件
- Cellクラス：マスの状態管理（row, col, value, fixed, notes）
- Boardクラス：盤面全体の管理（cells, date, difficulty, script）
- Difficulty enum：easy, medium, hard, expert
- Script enum：kanji, roman, arabic

## 実装ポイント
- lib/core/domain/entities/ 配下に配置
- Cellはイミュータブルに設計
- Boardは9x9のCellリストを保持
- 各enumは適切な拡張メソッドを追加

## TODO
- [ ] Cellクラス実装
- [ ] Boardクラス実装
- [ ] Difficulty enum実装
- [ ] Script enum実装
- [ ] エンティティのテストデータ作成
