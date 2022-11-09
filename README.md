# ☘️ ServiceLevelProject

# SLP  

### 앱 소개/특징
## 개발
- 최소 타겟 : iOS 15
- iPhone, Portrait 모드 지원
- Code Base UI
- MVVM, UIKit, AutoLayout
- RxSwift, SnapKit, Firebase  

## 앱 소개
#### Onboarding
- 임시.

-------------

### 구현 기능
- 임시.

-------------

### 개발 공수
| 주차 | 내용 | 세부내용 | 소요시간 | 특이사항 | 날짜 |
| --- | --- | --- | --- | --- | --- |
| **1주차** |  |  |  |  | **~2022.11.13** |
| 7 | 초기 셋팅 | Extension, Protocol, enum... | 2h |  |  |
| 7 | Onboarding | PageViewController 구성 | 4h |  |  |
| 8 | Login | Layout | 2h |  |  |
| 8 | Login | TextField 하이픈 추가 | 2h |  |  |
| 8 | Login | 전화번호 유효성 검사 | 3h |  |  |
| 8 | Login | Firebase Auth | 3h |  |  |
| 9 | Login | 하이픈 버그 수정 | 1h |  |  |
| 9 | Login | TextField 하이라이트 | 1h |  |  |
| 9 | Login | TextField 글자수 제한 | 1h |  |  |
| 9 | Auth | Layout | 1h |  |  |
|  |  |  |  |  |  |
| **2주차** |  |  |  |  | **~2022.11.20** |
|  |  |  |  |  |  |
|  |  |  |  |  |  |
| **3주차** |  |  |  |  | **~2022.11.27** |
|  |  |  |  |  |  |
|  |  |  |  |  |  |
| **4주차** |  |  |  |  | **~2022.12.04** |
|  |  |  |  |  |  |
|  |  |  |  |  |  |
| **5주차** |  |  |  |  | **~2022.12.06** |
|  |  |  |  |  |  |
|  |  |  |  |  |  |
-------------
#### 11/07
- 아직 미숙하지만 MVVM 패턴과 RxSwift의 Input/Output 을 활용해 앱을 구현하는 것을 목표로 잡았다.
- OnboardingPageViewController로 온보딩을 구성했으며, 페이지는 같은 VC의 인스턴스를 세개 생성해 label, image 등의 속성을 각각 변경하는 방식으로 구현했다.
- UIButton, UILabel 등 view의 재사용이 용이하도록, CustomView 라는 프로토콜을 생성하고 extension으로 view를 리턴하는 함수를 만들었다.
- Image나 Color 등을 더 편하게 설정하고, 관리하기 용이하도록 열거형과 Extension을 활용했으나 최선의 방법인지는 조금 더 생각해봐야 할 것 같다.

#### 11/08
- PublishRelay에는 .value 로 접근하지 못하지만, 초기값이 있는 BehaviorRelay에서는 접근이 가능하다는 사실을 이제야 알았다...!
- 유효성 검사에 따른 Button 컬러 변경, 하이픈 추가, 토스트 얼럿 띄우는 기능 등 LoginView에 대한 기능은 얼추 끝낸 것 같다.
- 하지만 글자수 11자 제한 등 세세한 부분에서 보완할 부분이 아주 많아 보인다.
- 특히 TextField 에서 백스페이스로 숫자를 지울 때, 하이픈을 만나면 더이상 지워지지 않는 버그가 있어 빨리 고쳐야 할 것 같다.

#### 11/09
- 하이픈이 지워지지 않는 버그를 수정했다.
- phoneNumber.count 에 조건문으로 하이픈을 추가했었는데, 하이픈이 insert 되는 인덱스와 지우려고 하는 인덱스가 겹쳐서 발생한 것이었다.
- 조건인 count를 한개씩 올려줘서 세번째 숫자가 입력된 다음이 아닌, 네번째 숫자가 입력되기 직전에 하이픈을 넣으니 정상적으로 동작한다.
- 그 외 TextField 글자수 제한, 입력중일 때 밑줄 색상 변경, 토스트, 키보드 자동 업/다운 등 자잘한 기능을 추가했다.
