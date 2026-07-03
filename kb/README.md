# kb — 횡단 지식베이스

여러 step·운영 단계가 공유하는 지식만 둔다. **단일 step 전용 지침은 해당 `steps/N_*.md`에 내장돼 있다**
(구 version-policy→step0, discovery→step1, agent 설계 3종→step3, skill/orchestrator 가이드→step4, testing/metrics→step7).

## step 로드 맵 (결정적 로딩 — 각 step은 아래 것만)

| step | kb | 템플릿 |
|------|------|--------|
| 0 setup | tooling-matrix | reports/version-table |
| 1 analyze | design-principles | reports/discovery |
| 2 sdd | design-principles | sdd/{prd,architecture,adr} |
| 3 agents | safety-rules, tooling-matrix | AGENT.md.tmpl(작성지침 내장) |
| 4 skills | safety-rules, tooling-matrix | SKILL.md.tmpl(작성지침 내장) |
| 5 constitution | safety-rules, design-principles, docs-rules | CLAUDE.md, settings.json, hooks/* |
| 6 engine | — (규약은 engine 템플릿 주석에) | engine/* (커맨드는 .claude/commands/로 산출) |
| 7 validate | — (검증 지침은 step7에 내장) | reports/validation |
| 운영(상시) | evolution, docs-rules | instincts, result-report |

## 파일 (6개)
`design-principles.md`(횡단 원칙·단일소스) · `safety-rules.md`(안전 권위 소스) · `tooling-matrix.md`(도구→명령)
`docs-rules.md`(architecture/work_orders/result_report 규칙) · `evolution.md`(학습 루프) · 이 README(로드맵).
