#!/bin/bash
# 산출물: .claude/hooks/safety.sh (step5). PreToolUse 차단형 Hook — 위험하면 exit 2(차단), 아니면 exit 0.
# 입력: stdin JSON (Claude Code 규약: .tool_name / .tool_input.command). 차단=exit 2, exit 1은 비차단(통과).
# 차단은 이 훅, 관찰은 observe.sh, 테스트게이트는 tdd-gate.sh(각각 별개). 안전 정책 단일소스는 루트 CLAUDE.md.

# jq 없으면 인자 파싱 불가 → 차단 불가. 작업은 막지 않되(fail-open) 경고.
command -v jq >/dev/null || { echo "safety.sh: jq 필요(brew install jq) — 미설치 시 위험명령 차단 불가" >&2; exit 0; }

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')
FP=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
SENSITIVE='\.env$|tfstate|-prod\.|\.pem$|kubeconfig|credentials'

# 0) 시크릿 "읽기" 차단 — 정책(CLAUDE.md '시크릿 읽기·출력 금지')의 강제.
#    Read 도구(file_path) + Bash의 cat/less/head/tail/grep 대상 모두.
if [ -n "$FP" ] && printf '%s' "$FP" | grep -qE "$SENSITIVE"; then
  echo "차단: 민감 파일 읽기($FP) — CLAUDE.md '# CRITICAL — Safety'." >&2; exit 2
fi
case "$CMD" in
  *cat\ *|*less\ *|*head\ *|*tail\ *|*grep\ *)
    if printf '%s' "$CMD" | grep -qE "$SENSITIVE"; then
      echo "차단: 민감 파일 읽기 명령 — CLAUDE.md '# CRITICAL — Safety'." >&2; exit 2
    fi ;;
esac

# 1) 파괴적·prod 영향 명령 차단 (스택에 맞춰 추가). 매칭되면 stderr 출력 후 exit 2.
case "$CMD" in
  *"terraform apply"*|*"terraform destroy"*|*"pulumi up"*|*"pulumi destroy"* \
  |*"kubectl apply"*|*"kubectl delete"*|*"helm upgrade"*|*"helm install"* \
  |*"flyway migrate"*|*"liquibase update"*|*"alembic upgrade"* \
  |*"git push --force"*|*"git push -f"*|*"git reset --hard"*|*"rm -rf"*)
    echo "차단: '$CMD'은 사람 승인 필요(파괴적/prod 영향). plan/dry-run까지만(--force-with-lease 포함 강제 push는 사람이 직접) — CLAUDE.md '# CRITICAL — Safety'." >&2
    exit 2 ;;
esac

# 2) git commit 게이트: 시크릿 스테이징 차단 + TDD 커밋 분리(RED/GREEN)
case "$CMD" in
  *"git commit"*)
    STAGED=$(git diff --cached --name-only 2>/dev/null)
    # 2-1) 민감 파일 스테이징 차단
    if printf '%s' "$STAGED" | grep -qE '\.env$|tfstate|-prod\.|\.pem$|kubeconfig'; then
      echo "차단: 민감 파일이 스테이징됨. 제거 후 커밋." >&2; exit 2
    fi
    # 2-2) TDD 커밋 분리: 구현 파일과 "기존 테스트 파일의 수정(M)"이 한 커밋에 섞이면 차단.
    #      (몰래 테스트를 고쳐 GREEN 만드는 것을 diff로 발각 — 정책: CLAUDE.md '# CRITICAL — TDD')
    #      새 테스트 추가(A)는 RED 커밋이므로 허용. 테스트 수정이 의도면 테스트만 별도 커밋할 것.
    IMPL=$(printf '%s' "$STAGED" | grep -E '\.(java|kt|ts|tsx|js|jsx|py|go|rb)$' | grep -viE 'test|spec|__tests__' | head -1)
    MOD_TEST=$(git diff --cached --name-status 2>/dev/null | awk '$1=="M"{print $2}' | grep -iE 'test|spec|__tests__' | head -1)
    if [ -n "$IMPL" ] && [ -n "$MOD_TEST" ]; then
      echo "차단(TDD 커밋 분리): 구현($IMPL)과 기존 테스트 수정($MOD_TEST)이 한 커밋에 섞임. 테스트 변경은 별도 커밋으로 — CLAUDE.md '# CRITICAL — TDD'." >&2
      exit 2
    fi ;;
esac

exit 0
