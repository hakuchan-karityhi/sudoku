# 🧩 MVP詳細設計（World Sudoku）
**対象フェーズ:** MVP（プロトタイプ）  
**準拠文書:** docs/phase計画書.md / docs/suudoku_youken.md  
**作成日:** 2025-10-29  

---

## 1. 目的・スコープ（MVP）
MVPの目的は「9×9数独の基本体験」と「多文字スクリプト対応（3言語）」の価値検証。デイリーパズルは**MVPでは擬似デイリー（ローカルJSON）**で提供し、**βでFirestoreからの取得に移行**する。なお、デイリーパズルは端末側で生成せず、配布済みの固定データのみを使用する（公平性確保のため）。

- コア機能: 9×9盤面表示／入力／ルール判定／クリア判定
- 多言語: 日本語・英語・アラビア（RTL対応）
- データ: MVPはローカルJSON、後続でFirestore

---

## 2. アーキテクチャ構成
- クライアント: Flutter（Dart）
- **アーキテクチャパターン: Clean Architecture + MVVM（Model-View-ViewModel）**
- 状態管理: Riverpod（StateNotifier使用）
- 画面: Home → Play → Result → Settings
- データ層: LocalDataSource（JSON）→ RemoteDataSource（Firestore）への差し替え可能設計

### 2.1 Clean Architectureのレイヤー構成

**依存関係の方向**: Presentation → Domain ← Data

| レイヤー | 責務 | 依存関係 |
|----------|------|----------|
| **Presentation層** | UI表示・ユーザー操作の受け付け | Domain層に依存 |
| **Domain層** | ビジネスロジック・ゲームロジック | 依存なし（独立） |
| **Data層** | データ取得・保存 | Domain層のインターフェースに依存 |

### 2.2 各レイヤーの詳細

#### Presentation層（MVVM構成）
- **View**: HomeView, PlayView, ResultView, SettingsView（UI表示のみ）
- **ViewModel**: Riverpodの`StateNotifier`を使用して状態管理
  - ViewModelはDomain層のUseCaseやRepositoryを呼び出し
  - UI向けの状態（State）を管理

#### Domain層（ビジネスロジック）
- **Entities**: Cell, Board などのドメインモデル
- **UseCases**: ビジネスロジック（例：SudokuValidator, SudokuGame）
- **Repository Interface**: Data層のインターフェース定義

#### Data層（データ取得・保存）
- **Repository実装**: Domain層のRepository Interfaceを実装
- **Data Sources**: LocalDataSource, RemoteDataSource
- **DTO**: ネットワーク/ローカルのデータ形式

### 2.3 ディレクトリ構成（Clean Architecture + MVVM）

```
lib/
  main.dart
  features/
    home/
      presentation/
        view/
          home_view.dart
        view_model/
          home_view_model.dart
          home_state.dart
    play/
      presentation/
        view/
          play_view.dart
        view_model/
          play_view_model.dart
          play_state.dart
      domain/
        entities/
          (必要なドメインエンティティ)
        usecases/
          sudoku_validator.dart    # ルール判定ロジック
          sudoku_game.dart         # ゲーム状態管理
        repositories/
          puzzle_repository_interface.dart  # インターフェース
    result/
      presentation/
        view/
          result_view.dart
        view_model/
          result_view_model.dart
          result_state.dart
    settings/
      presentation/
        view/
          settings_view.dart
        view_model/
          settings_view_model.dart
          settings_state.dart
  core/
    domain/
      entities/
        cell.dart
        board.dart
        difficulty.dart
        script.dart
      repositories/
        puzzle_repository_interface.dart
    data/
      repositories/
        puzzle_repository_impl.dart
      data_sources/
        local_data_source.dart
        remote_data_source.dart
      models/
        puzzle_dto.dart            # Data層のDTO
    services/
      ranking_service.dart
      notification_service.dart
    widgets/
      (共通ウィジェット)
```

---

## 3. 画面仕様
### 3.1 Home
- 要素: 「デイリー開始」ボタン、「通常Play」ボタン、言語/スクリプト切替
- フロー:
  - デイリー開始: 本日のデイリーパズルを即開始（難易度と言語は直前の選択を踏襲）
    - MVP: `assets/puzzles/YYYY-MM-DD.json` から読み込み（無い日は「未配信」表示しランキング対象外。端末生成は行わない）
    - β: Firestore `puzzles/{YYYY-MM-DD}` から取得（自動登録と連携）。取得できない場合は前回取得の「前日分」を練習扱いで起動（ランキング送信不可）
  - 通常Play: 押下後に「難易度（初級/中級）」と「表示言語/スクリプト」を選択→Play開始
  - 言語/スクリプト切替: UI言語と盤面スクリプトを切替（RTLは自動適用）
- 遷移: Home → Play（デイリー／通常いずれも）

### 3.2 Play（メイン）
- 9×9グリッド、数字パッド、メモ切替、タイマー、ヒント（任意・MVPはハイライトのみ）
- 操作: マス選択→数字入力／数字選択→マス入力（両対応）
- ルール: 行/列/ブロックの重複チェック、クリア判定でResult遷移

### 3.3 Result
- クリアタイム、難易度、使用スクリプト表示

### 3.4 Settings
- 言語（UI）

---

## 4. データモデル

### 4.1 Domain層のEntity（ビジネスロジック用）

```
// core/domain/entities/cell.dart
class Cell {
  final int row;        // 0..8
  final int col;        // 0..8
  final int? value;     // 1..9 or null
  final bool fixed;     // 事前配置（固定）かどうか
  final Set<int> notes; // メモ（候補数字）

  Cell({
    required this.row,
    required this.col,
    this.value,
    this.fixed = false,
    Set<int>? notes,
  }) : notes = notes ?? <int>{};
}

// core/domain/entities/board.dart
class Board {
  final List<List<Cell>> cells; // 9x9
  final DateTime? date;         // デイリーパズルの日付
  final Difficulty difficulty;  // 難易度
  final Script script;          // スクリプト

  Board({
    required this.cells,
    this.date,
    required this.difficulty,
    required this.script,
  });
}

// core/domain/entities/difficulty.dart
enum Difficulty {
  easy,    // 初級
  medium,  // 中級
  hard,    // 上級
  expert,  // 超上級
}

// core/domain/entities/script.dart
enum Script {
  kanji,   // 漢字
  roman,   // ローマ字
  arabic,  // アラビア文字
}
```

### 4.2 Data層のDTO（データ取得用）

```
// core/data/models/puzzle_dto.dart
class PuzzleDto {
  final String date;        // "2025-05-01"
  final String difficulty;  // "easy", "medium", etc.
  final List<List<int>> grid; // 9x9 の配列（0=空マス、1-9=数字）
  final String script;      // "kanji", "roman", "arabic"

  PuzzleDto({
    required this.date,
    required this.difficulty,
    required this.grid,
    required this.script,
  });

  // JSONからの変換
  factory PuzzleDto.fromJson(Map<String, dynamic> json) {
    return PuzzleDto(
      date: json['date'] as String,
      difficulty: json['difficulty'] as String,
      grid: (json['grid'] as List).map((e) => List<int>.from(e)).toList(),
      script: json['script'] as String,
    );
  }

  // Domain層のEntityへ変換
  Board toEntity() {
    final cells = <List<Cell>>[];
    for (int row = 0; row < 9; row++) {
      final rowCells = <Cell>[];
      for (int col = 0; col < 9; col++) {
        final value = grid[row][col];
        rowCells.add(Cell(
          row: row,
          col: col,
          value: value == 0 ? null : value,
          fixed: value != 0, // MVPでは0以外は固定とする
        ));
      }
      cells.add(rowCells);
    }
    return Board(
      cells: cells,
      date: DateTime.parse(date),
      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == difficulty,
      ),
      script: Script.values.firstWhere(
        (e) => e.name == script,
      ),
    );
  }
}
```

### 4.3 データソース形式（MVP: ローカルJSON）

ローカルJSON（MVP）例：
```json
{
  "date": "2025-05-01",
  "difficulty": "easy",
  "grid": [
    [0,0,0, 2,6,0, 7,0,1],
    [6,8,0, 0,7,0, 0,9,0],
    [1,9,0, 0,0,4, 5,0,0],
    [8,2,0, 1,0,0, 0,4,0],
    [0,0,4, 6,0,2, 9,0,0],
    [0,5,0, 0,0,3, 0,2,8],
    [0,0,9, 3,0,0, 0,7,4],
    [0,4,0, 0,5,0, 0,3,6],
    [7,0,3, 0,1,8, 0,0,0]
  ],
  "script": "arabic"
}
```

### 4.4 Firestore移行時の想定（β版）

- コレクション: `puzzles`
- ドキュメントID: `YYYY-MM-DD`
- フィールド: `{ date: string, difficulty: string, grid: array[9][9], script: string }`
- Data層のDTOと同一形式

---

## 5. 多文字スクリプト仕様
### 5.1 マッピング（1..9）
| 数字 | 漢字 | ローマ字 | アラビア文字 |
|------|------|----------|--------------|
| 1 | 一 | A | ١ |
| 2 | 二 | B | ٢ |
| 3 | 三 | C | ٣ |
| 4 | 四 | D | ٤ |
| 5 | 五 | E | ٥ |
| 6 | 六 | F | ٦ |
| 7 | 七 | G | ٧ |
| 8 | 八 | H | ٨ |
| 9 | 九 | I | ٩ |

注意: 表示はスクリプト変換のみで内部値は1..9保持。RTLは`Directionality.rtl`を適用。

### 5.2 フォント
- Noto Sans JP / Noto Naskh Arabic / Noto Sans
- フォールバックチェーンを定義し文字化けを回避

---

## 6. Domain層のUseCase（ビジネスロジック）

### 6.1 SudokuValidator（ルール判定）

**場所**: `features/play/domain/usecases/sudoku_validator.dart` または `core/domain/usecases/sudoku_validator.dart`

**責務**: 数独のルール判定（行・列・ブロック内での重複チェック）

```dart
class SudokuValidator {
  /// 指定したマスに値を配置できるかチェック
  bool isValid(Board board, int row, int col, int value) {
    // 行チェック
    for (int x = 0; x < 9; x++) {
      if (x != col && board.cells[row][x].value == value) {
        return false;
      }
    }
    
    // 列チェック
    for (int y = 0; y < 9; y++) {
      if (y != row && board.cells[y][col].value == value) {
        return false;
      }
    }
    
    // ブロックチェック（3×3）
    final blockRow = (row ~/ 3) * 3;
    final blockCol = (col ~/ 3) * 3;
    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        final checkRow = blockRow + y;
        final checkCol = blockCol + x;
        if ((checkRow != row || checkCol != col) &&
            board.cells[checkRow][checkCol].value == value) {
          return false;
        }
      }
    }
    
    return true;
  }

  /// 盤面が完成（クリア）しているかチェック
  bool isCompleted(Board board) {
    // 全マスが埋まっているか
    for (final row in board.cells) {
      for (final cell in row) {
        if (cell.value == null) {
          return false;
        }
      }
    }
    
    // 全行・全列・全ブロックに1..9が各1回ずつ存在するか
    return _isValidCompleteBoard(board);
  }

  bool _isValidCompleteBoard(Board board) {
    // 行チェック
    for (int row = 0; row < 9; row++) {
      final numbers = <int>{};
      for (int col = 0; col < 9; col++) {
        final value = board.cells[row][col].value;
        if (value == null || numbers.contains(value)) {
          return false;
        }
        numbers.add(value);
      }
    }
    
    // 列チェック
    for (int col = 0; col < 9; col++) {
      final numbers = <int>{};
      for (int row = 0; row < 9; row++) {
        final value = board.cells[row][col].value;
        if (value == null || numbers.contains(value)) {
          return false;
        }
        numbers.add(value);
      }
    }
    
    // ブロックチェック
    for (int blockRow = 0; blockRow < 3; blockRow++) {
      for (int blockCol = 0; blockCol < 3; blockCol++) {
        final numbers = <int>{};
        for (int y = 0; y < 3; y++) {
          for (int x = 0; x < 3; x++) {
            final row = blockRow * 3 + y;
            final col = blockCol * 3 + x;
            final value = board.cells[row][col].value;
            if (value == null || numbers.contains(value)) {
              return false;
            }
            numbers.add(value);
          }
        }
      }
    }
    
    return true;
  }
}
```

### 6.2 使用例（ViewModelからの呼び出し）

```dart
// PlayViewModel内
final validator = SudokuValidator();

// 入力時の検証
void onNumberInput(Cell cell, int value) {
  if (validator.isValid(currentBoard, cell.row, cell.col, value)) {
    // 有効な入力：セルに値を設定
    updateCell(cell.row, cell.col, value);
  } else {
    // 無効な入力：ハイライト表示
    highlightError(cell.row, cell.col);
  }
  
  // クリア判定
  if (validator.isCompleted(currentBoard)) {
    // クリア処理
    onGameCompleted();
  }
}
```

---

### 6.3 Repositoryパターン

**Domain層（インターフェース）**: `core/domain/repositories/puzzle_repository_interface.dart`

```dart
abstract class PuzzleRepository {
  /// 指定日のデイリーパズルを取得
  Future<Board> getDaily(DateTime date);
  
  /// 難易度別のパズルを取得（通常Play用）
  Future<Board> getByDifficulty(Difficulty difficulty);
}
```

**Data層（実装）**: `core/data/repositories/puzzle_repository_impl.dart`

```dart
class PuzzleRepositoryImpl implements PuzzleRepository {
  final LocalDataSource _localDataSource; // MVP
  // final RemoteDataSource _remoteDataSource; // β以降

  PuzzleRepositoryImpl({
    required LocalDataSource localDataSource,
    // RemoteDataSource? remoteDataSource, // β以降
  }) : _localDataSource = localDataSource;

  @override
  Future<Board> getDaily(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final json = await _localDataSource.readAsset(
      'assets/puzzles/$dateStr.json',
    );
    final dto = PuzzleDto.fromJson(json);
    return dto.toEntity();
  }

  @override
  Future<Board> getByDifficulty(Difficulty difficulty) async {
    // 難易度別のパズル生成ロジック（MVPでは簡易実装）
    // またはテンプレートから取得
    // TODO: 実装
    throw UnimplementedError();
  }
}
```

**DataSource**: `core/data/data_sources/local_data_source.dart`

```dart
class LocalDataSource {
  Future<Map<String, dynamic>> readAsset(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
```

**ViewModelからの使用例**:

```dart
// HomeViewModel内
final repository = ref.read(puzzleRepositoryProvider);

Future<void> startDaily() async {
  state = state.copyWith(isLoading: true);
  try {
    final board = await repository.getDaily(DateTime.now());
    state = state.copyWith(board: board, isLoading: false);
    // PlayViewへ遷移
  } catch (e) {
    // エラーハンドリング
    state = state.copyWith(error: e.toString(), isLoading: false);
  }
}
```

---

## 7. 受入基準（MVP）
- 盤面表示: 9×9が初期表示2秒以内
- 入力: マス/数字いずれの操作でも1タップで反映
- ルール: 重複入力時は即時ハイライト
- クリア: 全マス確定でResultへ遷移しタイム表示
- 多文字: 日本語/英語/アラビアの切替で表示崩れがない（RTL含む）
- デイリー公平性: デイリーは固定配布データのみを使用（端末側生成を禁止）。未配信日は通常Playを案内

---

## 8. テレメトリ（任意導入）
- play_start, play_complete, play_abandon
- 端末・難易度・経過時間を付与

---

## 9. 移行計画（MVP→β・Clean Architecture観点）

### 9.1 レイヤー別の変更点

| レイヤー | MVP | β | 変更内容 |
|----------|-----|---|----------|
| **Presentation層** | 変更なし | 変更なし | View・ViewModelは変更不要（Repository抽象に依存） |
| **Domain層** | 変更なし | 変更なし | ビジネスロジックは独立しているため変更不要 |
| **Data層** | LocalDataSource | RemoteDataSource追加 | Repository実装でRemoteDataSourceを使用 |

### 9.2 具体的な変更内容

#### Data層の変更
- **DataSource**: `LocalDataSource`（MVP）→ `RemoteDataSource`（β）を追加
- **Repository実装**: `PuzzleRepositoryImpl`でRemoteDataSourceを使用
  ```dart
  // MVP
  PuzzleRepositoryImpl(localDataSource: LocalDataSource())
  
  // β
  PuzzleRepositoryImpl(
    localDataSource: LocalDataSource(), // フォールバック用
    remoteDataSource: RemoteDataSource(), // メイン
  )
  ```

#### 機能追加
- **データ（デイリー）**: Local（擬似デイリー, assets） → Firestore（`puzzles/YYYY-MM-DD`）
- **通知**: なし → FCM（09:00 JST）通知Service追加
- **ランキング**: なし → PlayFab（タイム送信）ランキングService追加
- **広告**: なし → AdMob（バナー）広告Service追加
- **公平性**: βではFirestore配布データのみランキング対象。署名/ハッシュ検証の導入を検討

### 9.3 Clean Architectureのメリット（移行時の観点）

1. **Presentation層・Domain層は変更不要**
   - Repositoryインターフェースが変わらないため、ViewModel・UseCaseは変更不要
   - テストもそのまま再利用可能

2. **Data層のみの変更で対応**
   - RemoteDataSourceの追加とRepository実装の変更のみ
   - LocalDataSourceはフォールバック用として残す

3. **段階的移行が容易**
   - まずRemoteDataSourceを追加し、エラー時にLocalDataSourceにフォールバック
   - 動作確認後にRemoteDataSourceをメインに切り替え

---

## 10. リスクと先行検証
- RTL表示崩れ：Play画面で先行検証
- フォント不足：Noto系の組合せ検証
- 描画性能：初回表示2秒以内の確認

---

## 11. 参考
- docs/phase計画書.md のMVP行
- docs/suudoku_youken.md のスコープ・機能要件


