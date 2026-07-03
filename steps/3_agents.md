# step 3 — 에이전트 생성 (템플릿 기반 즉석 구성)

> 카탈로그 복사가 아니라, 도구+도메인+discovery를 근거로 **필요한 에이전트를 직접 설계·생성**한다.
> 형식 품질은 `templates/AGENT.md.tmpl`의 작성 지침 주석이 강제한다.

## 할 일 (대상 프로젝트 `.claude/agents/`에 생성)
1. **목록 제안**: step0 도구 목록 + 도메인 설명 + step1 discovery를 근거로 필요한 에이전트 목록을
   역할·범위·근거(어떤 도구/요구 때문인지)와 함께 표로 제안한다.
   - **불변 규칙**: ① reviewer는 항상 포함 ② mixed 레포면 qa 필수(subagent_type=general-purpose —
     Explore는 검증 스크립트 실행 불가) ③ 도메인에 payment/auth/secret/pci/암호화 류가 있으면 security-reviewer 포함.
   - 미선언 레이어(예: infra 미기재)의 에이전트는 제안하지 않는다.
2. ◀**승인 게이트**: 사용자가 목록을 확정해야 생성 시작.
3. **생성**: 확정된 각 에이전트를 `templates/AGENT.md.tmpl` 골격+주석 지시대로 채운다.
   - 검증·테스트 명령은 `kb/tooling-matrix.md`로 실제 스택 치환. 패턴 근거는 **step1 discovery의 실제 레포 코드**
     (키트에 예문 없음 — 다른 스택 예문을 상상해 넣지 않는다).
   - `examples/sample-harness`는 검증 픽스처 — **참조/모방 금지.**
   - 템플릿의 `<!-- 작성 지침 -->` 주석은 채운 뒤 **산출물에서 제거**한다(생성용 지침, 런타임 불필요).
   - 안전은 루트 헌법 `# CRITICAL — Safety` 1줄 참조. 팀 모드 아니면 팀 통신 섹션 생략.

## 설계 판단 기준

**실행 모드** — 에이전트 1명이거나 결과만 모으면 **서브 에이전트**(병렬 run_in_background).
발견 공유·상충 토론·교차검증이 품질을 높이면 **팀**(SendMessage + TaskCreate).

**아키텍처 패턴** — 기본은 **생성-검증**(dev 구현 → reviewer 게이트). 병렬 다각 점검이면 팬아웃/팬인,
배포까지 순차면 파이프라인. (전문가풀/감독자/계층위임은 규모 커질 때만.)

**분리 4축** — 전문성 / 병렬성 / **컨텍스트(섞이면 오염 — 혼합 레포 결정적)** / 재사용성.
> 앱(Java)과 인프라(HCL/YAML)는 토큰 분포·검증 명령·실패 양상이 달라 한 에이전트가 겸하면
> few-shot 모방으로 엉뚱한 패턴이 샌다. 반드시 backend-dev/infra-dev 분리.

**표준 흐름 (혼합 레포, 생성-검증+파이프라인)**
```
backend-dev(app/) ∥ infra-dev(infra/) → qa(경계 교차비교, 모듈 완성 직후마다) → reviewer(게이트)
위험 작업은 plan/dry-run까지 → 사람이 확인 후 직접 apply
```

**QA 에이전트 기준 (혼합 레포 필수)**
- 본질은 존재 확인이 아니라 **경계면 교차 비교** — 양쪽을 동시에 읽고 shape을 맞춘다. **incremental**(모듈 완성 직후마다).
- 잘 새는 경계면: ①API응답↔DTO ②OpenAPI↔구현 ③마이그레이션↔엔티티 ④앱설정↔ConfigMap/Secret
  ⑤컨테이너포트↔Service ⑥tf output↔앱 env ⑦알림룰↔실제 메트릭명 (④~⑦=앱↔인프라 경계, 최다 유출 지점).
- 코드를 고치지 않는다 — 실행·관찰·보고만. 출력은 `_workspace/`에 경계별 정합/불일치 표.

## 로드 (이 step만)
- kb: `safety-rules.md`, `tooling-matrix.md` · 템플릿: `AGENT.md.tmpl`

## 게이트
- 혼합 레포 app/infra 침범 차단 필수. ◀최종 게이트: 생성된 에이전트 집합 확인 후 step4로.
