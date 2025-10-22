#!/bin/sh

set -eu

TYPES="feature fix docs refactor chore test build ci"

echo "ブランチ種別を選択してください:"
select TYPE in $TYPES; do
  if [ -n "${TYPE:-}" ]; then break; fi
  echo "無効な選択です。"
done

ISSUE=""
while [ -z "$ISSUE" ]; do
  printf "Issue番号（必須・数字のみ）: "
  read ISSUE
  echo "$ISSUE" | grep -Eq '^[0-9]+$' || { echo "数字のみで入力してください"; ISSUE=""; }
done

printf "説明（ケバブケース: 例 board-generator）: "
read DESC

# 正規化: 小文字化 + 非英数字はハイフンへ + 連続ハイフン圧縮 + 先頭末尾ハイフン除去
NORM=$(echo "$DESC" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/-+/-/g; s/^-|-$//g')
if [ -z "$NORM" ]; then
  echo "説明が空です。" >&2
  exit 1
fi

BRANCH="${TYPE}/${ISSUE}-${NORM}"

echo "作成するブランチ: $BRANCH"

git fetch --all --prune >/dev/null 2>&1 || true

git checkout -b "$BRANCH"

echo "ブランチを作成しました: $BRANCH"
