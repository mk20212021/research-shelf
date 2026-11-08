#!/usr/bin/env bash
# research-shelf 每轮发布同步：用法 publish.sh <本轮交付件绝对路径> <版本标签>
# 同步为 behrens/index.html（当前轮）+ behrens/archive/ 副本，提交推送。
# Pages 构建为异步，推送成功即返回；发布失败须如实上报，不阻塞 HTML 直传。
set -euo pipefail
SRC="$1"
LABEL="${2:-$(basename "$SRC" .html)}"
REPO="$(cd "$(dirname "$0")" && pwd)"
[ -f "$SRC" ] || { echo "PUBLISH_FAIL: 源文件不存在 $SRC"; exit 1; }
cp "$SRC" "$REPO/behrens/index.html"
cp "$SRC" "$REPO/behrens/archive/$(basename "$SRC")"
cd "$REPO"
git add -A
if git commit -m "${LABEL} 发布同步" 2>/dev/null; then
  git push origin main
  echo "PUBLISHED https://mk20212021.github.io/research-shelf/behrens/ ($LABEL)"
else
  echo "NO_CHANGES: 内容与上轮一致，未产生新提交"
fi
