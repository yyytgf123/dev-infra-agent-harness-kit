# Evolution — 자체 학습 루프 (관찰 → 축적 → 승격 → 정리)

외부 시스템 없이 도는 지속 개선 루프. 산출물의 `/review` 커맨드(.claude/commands/review.md) + 관찰 Hook(`observe.sh`)이 운영한다.
수동 Bug Log는 사람이 알아챈 것만 남지만 **Hook은 도구 사용마다 100% 결정적으로 캡처**한다.

## 4박자 루프
1. **관찰** — PreToolUse/PostToolUse 훅이 도구 사용을 raw로 append. 점수 없음, 차단 없음(항상 exit 0), LLM 호출 없음.
   구현·캡처 필드·redact 규칙은 전부 `templates/hooks/observe.sh.tmpl` 주석에. 등록은 `templates/settings.json.tmpl`.
2. **축적** — 반복 패턴을 instinct로 승격. 저장 `.claude/instincts/<project-hash>/` (git remote 해시로 프로젝트 격리 — A레포 패턴이 B로 새지 않게).
   한 줄 포맷·도메인 태그는 `templates/instincts.md.tmpl`.
3. **승격 (주 1회)** — 같은 도메인 instinct 3개+ 가 0.7↑면 묶어 승격. 행동규칙→`CLAUDE.md` Bug Log / 워크플로→스킬 / 역할→에이전트 / 결정적 강제 필요→훅(가장 강함).
   **승격은 항상 사람 승인 게이트** — `/review`가 후보 제안, 사람이 확인·커밋.
4. **정리 (주 1회)** — 0.3↓ 또는 60일 미관찰 제거. 모순 instinct는 삭제 말고 점수로 우열 표시(증거 보존).

## 신뢰도 점수 (0.3~0.9)
0.3 잠정(제안만) · 0.5 보통(관련 시 적용) · 0.7 승격 후보 · 0.9 훅 강제 대상.
상승: 재관찰/사용자 미수정. 하락: 사용자 수정/미관찰/반증. seen 카운트는 자동, **최종 승격 판단은 사람**.

## 주간 리듬 (금요일 5~10분)
```
1. 점수 갱신 → 2. 0.7↑ 묶음 1개 승격(사람 승인) → 3. 0.3↓·만료 prune
4. tools/token-report.sh --runtime <proj> — 승격은 규칙을 늘리는 압력이므로
   CLAUDE.md가 비대해지면 디테일을 docs/·스킬 references/로 내려 상시 비용 회귀 방지
```

## 글로벌 승격 (신중히)
여러 프로젝트에서 high-confidence로 반복되는 보편 패턴만 글로벌로. 특정 레포 컨벤션을 올리면 타 프로젝트 오염.
