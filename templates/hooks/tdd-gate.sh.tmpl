#!/bin/bash
# 산출물: .claude/hooks/tdd-gate.sh (step5). PreToolUse(Edit|Write) — 대응 테스트 없는 구현 파일 작성 차단(exit 2).
# 정책 단일소스: 루트 CLAUDE.md '# CRITICAL — TDD'. 스택별 테스트 경로/확장자는 kb/tooling-matrix 기반으로 채울 것.
# 판정 2단계: ①동일 stem 테스트 파일 존재 ②없으면 어떤 테스트든 해당 클래스를 참조(계층 커버 허용 — 예:
#   TodoControllerTest가 TodoService를 커버). 존재만 보고 RED 실행 여부는 못 본다 — RED 증거는 reviewer 게이트가 확인.

command -v jq >/dev/null || exit 0   # jq 없으면 게이트 불가 → fail-open
INPUT=$(cat)
FP=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FP" ] && exit 0
ROOT="${CLAUDE_PROJECT_DIR:-.}"
BASE=$(basename "$FP"); STEM="${BASE%.*}"

# 1) 테스트 파일 자체면 통과 — basename 정규 매칭(경로에 test가 든 패키지명으로 우회 불가)
if printf '%s' "$BASE" | grep -qiE '(^test_|_test\.|Test\.|Tests\.|Spec\.|\.test\.|\.spec\.)'; then exit 0; fi
case "$FP" in */__tests__/*|*/src/test/*|*/tests/*) exit 0 ;; esac

# 2) 비구현 파일 통과 / 구현 확장자만 게이트 (스택에 맞춰 조정)
case "$BASE" in
  *.java|*.kt|*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rb) : ;;
  *) exit 0 ;;
esac

# 3-a) 동일 stem 테스트 파일 존재 → 통과
if find "$ROOT" -type f \( -iname "${STEM}Test.*" -o -iname "${STEM}Tests.*" -o -iname "${STEM}Spec.*" \
     -o -iname "test_${STEM}.*" -o -iname "${STEM}_test.*" -o -iname "${STEM}.test.*" -o -iname "${STEM}.spec.*" \) \
     2>/dev/null | grep -q .; then exit 0; fi
# 3-b) 어떤 테스트 파일이든 이 클래스/모듈을 참조하면 통과 (통합 테스트가 커버하는 계층)
TEST_DIRS=""
for d in "$ROOT/src/test" "$ROOT/tests" "$ROOT/test"; do [ -d "$d" ] && TEST_DIRS="$TEST_DIRS $d"; done
if [ -n "$TEST_DIRS" ] && grep -rl "$STEM" $TEST_DIRS 2>/dev/null | grep -q .; then exit 0; fi

echo "차단(TDD): '${BASE}'를 커버하는 테스트가 없습니다. 실패 테스트(예: ${STEM}Test)를 먼저 작성·실행(RED 확인)하세요 — CLAUDE.md '# CRITICAL — TDD'." >&2
exit 2
