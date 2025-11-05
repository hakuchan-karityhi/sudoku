# 002 Clean Architecture + MVVM 基盤構築

## 概要
Clean Architecture + MVVMパターンの基盤ディレクトリ構造と基本クラスを構築する。

## 詳細要件
- lib/ 配下にcore/, features/ ディレクトリを作成
- Presentation層（View, ViewModel）の基底クラス作成
- Domain層の基本構造
- Data層の基本構造
- Riverpod Providerの基本設定

## 実装ポイント
- 依存関係の方向：Presentation → Domain ← Data
- features/ 配下にhome/, play/, result/, settings/ を作成
- core/ 配下にdomain/, data/ を作成
- 共通ウィジェット用のwidgets/ ディレクトリ作成

## TODO
- [ ] lib/core/ ディレクトリ構造作成
- [ ] lib/features/ ディレクトリ構造作成
- [ ] Presentation層基底クラス作成（BaseView, BaseViewModel）
- [ ] Domain層基本構造（entities/, usecases/, repositories/）
- [ ] Data層基本構造（repositories/, data_sources/, models/）
- [ ] Riverpod Provider基本設定
