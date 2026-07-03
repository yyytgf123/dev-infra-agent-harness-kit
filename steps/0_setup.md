# step 0 — 스택·버전 확정 (Setup)

> 시작 전 스택·버전을 못 박는다. 안 되면 뒤 step이 추측으로 흐른다. 입력은 루트 `ORCHESTRATOR.md`의 3칸.

## 할 일
1. `ORCHESTRATOR.md`의 도구+버전 / 도메인 / repo_type / version_policy를 읽는다.
2. 비운 버전은 아래 규칙으로 **검색 후 선정** (내장 지식만 믿지 말 것 — 호환성은 바뀐다):
   - `strict`면 선정 금지 — 빈 항목은 사용자에게 질문.
   - `auto`면: ①언어 LTS 우선 ②프레임워크가 요구하는 최소 언어 버전 확인 후 그 위 LTS
     ③빌드툴은 프레임워크 권장 범위 ④IaC는 provider 호환 매트릭스의 안정 버전 ⑤k8s는 최신 -1~-2 마이너.
   - 검색 시 현재 연도를 넣어 stale 결과 제거. 알려진 breaking은 표 아래 경고.
3. 도구 → 검증/테스트 명령은 `kb/tooling-matrix.md`로 확정 (뒤 step의 test_cmd 근거).
4. `templates/reports/version-table.md.tmpl` 표로 출력, 승인받는다.

## 로드 (이 step만)
- kb: `tooling-matrix.md` · 템플릿: `reports/version-table.md.tmpl`

## 출력 / 게이트
- 출력: 확정 버전 표 + repo_type → step1. ◀승인 게이트: 버전 표 승인 전 step1 진행 금지.
