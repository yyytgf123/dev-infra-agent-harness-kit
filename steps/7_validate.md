# step 7 — 검증 (Validation)

> 만든 하네스가 실제로 작동·효과 있는지 측정한다. 만들고 끝내면 그냥 문서다.
> 리포트 골격: `templates/reports/validation.md.tmpl`.

## 검증 항목 (서술이 아니라 실행 — 각 항목은 명령이 기준)
1. **구조 (기계 검증)** — 아래가 전부 통과해야 함:
   - `test -f CLAUDE.md` (대문자 — 소문자는 Linux에서 미로드)
   - `test -f .claude/commands/harness.md -a -f .claude/commands/review.md` (슬래시 커맨드 위치)
   - `find .claude/skills -maxdepth 1 -name "*.md" | grep -q . && echo FAIL` — 플랫 스킬 파일 검출(반드시 `<name>/SKILL.md` 디렉토리)
   - `ls .claude/skills/*/SKILL.md` 존재, agents frontmatter에 비표준 필드(scope/subagent_type) 없음: `grep -l "^scope:" .claude/agents/*.md && echo FAIL`
   - `.claude/rules/` 잔재 없음. 에이전트가 참조하는 스킬이 실제 존재(`.claude/skills/<name>/` 대조).
2. **훅 (기계 검증)** — `bash -n` + `test -x` + settings.json 등록 대조:
   - **문서-훅 일치**: CLAUDE.md·architecture.md가 "훅이 강제한다"고 주장하는 항목마다 settings.json에
     해당 매처가 실제 등록돼 있는지 대조 — 문서에만 있는 유령 훅은 FAIL(문서를 고치거나 훅을 만들 것).
   - 단위: safety.sh에 위험명령 JSON 주입→exit 2 / 민감파일 read JSON→exit 2 / tdd-gate에 테스트 없는 구현→exit 2.
3. **엔진 (기계 검증)** — 전제조건 게이트 확인:
   - git 없는 임시 디렉토리에서 execute.sh→exit 4 / phases=[] →exit 4 / approved=false→exit 3.
   - env_checks에 불일치 값 주입→exit 4 (환경 검증 동작).
4. **트리거** — 스킬별 should-trigger 8~10개 + near-miss 8~10개(경계 쿼리). 스킬 간 충돌 확인.
5. **범위 침범 (혼합 레포 필수)** — backend-dev에 terraform 지시→거부/위임? infra-dev에 apply→plan까지만?
6. **토큰 게이트** — `tools/token-report.sh --gate <proj>`. CLAUDE.md ≤60줄·SKILL ≤500줄·반복규칙 1소스+1줄참조.
   baseline 대비 delta로만 판단(`docs/metrics/`).

## 스펙 대비 최종 검증 (SDD 마감)
- 가동 완료 시(그리고 /review 주기마다) **`docs/prd.md` 수용 기준을 체크리스트로 대조** — 각 기준이
  통과 테스트/산출물 증거와 매핑되는지 확인. 미충족은 미완료로 보고(완료 선언 금지).
- `## MVP 제외` 항목이 구현돼 있으면 범위 초과로 보고.

## 부가가치 측정 (도입 판단 — 토큰만 줄고 품질 깨지면 무의미)
- with-skill vs without-skill 같은 프롬프트 비교: 정량(테스트 생성? OpenAPI 갱신? plan 무오류?) + 정성(컨벤션·범위·가독성) 표.
- 외부 벤치마크 신뢰 금지 — 대표 작업 3~5개(앱2+인프라1~2)로 2~4주 내부 파일럿.
  지표: 테스트 포함률 · 컨벤션 위반 수 · 범위 침범 횟수 · 재작업 횟수.

## 반복 루프
문제 → **일반화해 수정**(특정 예시만 맞는 좁은 수정 금지) → 재테스트. 트리거 문제→step4 / 침범·규칙 무시→step3·5 / 엔진→step6.
◀승인 게이트: "가동 준비" 확인 후 산출물 가동(`/harness` → `execute.sh` → `/review`). 이후 지속 개선은 `kb/evolution.md`.
