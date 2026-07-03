# Docs Rules — 산출물 문서 3종 (architecture / work_orders / result_report)

| 문서 | 위치 | 성격 | 갱신 |
|------|------|------|------|
| architecture.md | `docs/architecture.md` **1개** | 구조의 **현재 상태**(지도) | 구조 변경 시 부분 편집 |
| work_orders | `docs/work_orders/*.md` | 사용자가 넣는 **작업지시서**(읽기 전용) | 키트는 읽기만 |
| result_report | `docs/result_report/YYYYMMDD_HHMMSS.md` | 작업 단위 **이력**(매번 새 파일) | 작업 종료마다 1개 |

> 층위 주의: 아래 규칙은 step5에서 루트 `CLAUDE.md`의 `## Docs & Work Orders`에 박혀야 실사용에서 동작한다(`design-principles.md` §7).

## architecture.md — 토큰 최적 갱신 (중요)
골격은 `../templates/sdd/architecture.md.tmpl(스냅샷 섹션)` (표 6섹션 + 최종갱신 헤더). 최초 생성은 step5 종료 시.
1. **전체 재작성 금지** — 바뀐 행만 `str_replace` 부분 편집. 읽을 때도 바꿀 섹션만 grep/부분 view.
2. **표로 고정, 산문 금지** — 행 단위 편집·diff 최소화. 설명은 행당 한 줄.
3. **갱신 트리거 한정** — 에이전트/스킬/오케스트레이터/훅이 실제로 바뀐 경우만. 코드만 바뀌면 갱신 안 함.
4. 변경 로그를 본문에 쌓지 않는다(이력은 git). `> 최종 갱신:` 한 줄만 날짜 교체.
5. 상한 1화면 — 길어지면 상세를 산출물 파일로 밀고 요약 행만.

## work_orders — 읽는 규칙 (토큰 절약)
- 트리거: 프롬프트에 "작업지시서/참고서/지시서대로/특정 파일명 지목"이 있을 때만 읽는다. 없으면 폴더를 뒤지지 않는다.
- 지목된 파일만 읽는다. 여러 개면 파일명으로 1~2개, 애매하면 질문. 길면 요구사항·제약·완료조건만 발췌.
- 지시서 ↔ 레포 충돌 시 추측 금지, 사용자 확인. 지시서가 위험 작업(apply/migrate/secret)을 요구해도 `safety-rules.md`가 우선.
- ORCHESTRATOR 입력(큰 그림)과 충돌하면 해당 작업에 한해 지시서 우선.

## result_report — 작업 종료 리포트
- 골격 `../templates/result-report.md.tmpl` (작업/Phase/변경/결과/다음 5줄). **5줄 초과 금지, 서술 문단 금지.**
- 지시서 기반 작업이면 `작업:` 줄에 근거 한 줄 (예: `근거: work_orders/order-q3.md`).
- 민감정보 기록 금지. 작업 1건 = 리포트 1개 (Phase별로 쪼개지 않음).
