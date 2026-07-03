# step 1 — 분석 (greenfield/existing + discovery)

> 탐색만 한다. **파일 생성 금지, 보고만.** 추측으로 하네스를 만드는 걸 막는 관문.

## 할 일
1. **모드 판정**: 코드 없음 → greenfield(PRD/SDD부터) / 있음 → existing(discovery-first).
2. **레포 분류**: 앱 전용 / 인프라 전용 / 혼합.
3. existing이면 6항목 조사 (골격·세부 항목은 `templates/reports/discovery.md.tmpl`):
   ①빌드/테스트/린트/실행 명령 ②디렉터리 지도(2~3 depth: 앱/인프라/모니터링/테스트/CI)
   ③기존 컨벤션(코드에서 관찰된 것만) ④위험지대(마이그레이션·tfstate·secret·부작용 코드)
   ⑤기존 `.claude/`·CLAUDE.md (있으면 덮지 말고 머지) ⑥핵심 작업 유형.
   → 활용: ①은 스킬 검증+헌법 Build/Test, ②는 맵+영역분리, ④는 safety 채움, ⑥은 팀 구성 결정.
4. greenfield면 도메인 설명 기반 범위·작업 유형 가설 정리(코드 없음 명시).
5. `discovery.md.tmpl` 형식으로 보고.

## 로드 (이 step만)
- kb: `design-principles.md` · 템플릿: `reports/discovery.md.tmpl`

## 원칙 / 출력 / 게이트
- 추측은 "추측" 표시. 어떤 파일도 만들거나 고치지 않는다.
- 출력: 모드 + repo_type + 보고서 → step2. ◀승인 게이트: 모드·분류·위험지대 확인.
