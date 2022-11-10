# ☘️ ServiceLevelProject

# SLP  

### 앱 소개/특징
## 개발
- 최소 타겟 : iOS 15
- iPhone, Portrait 모드 지원
- Code Base UI
- MVVM, UIKit, AutoLayout
- RxSwift, SnapKit, FirebaseAuth  

## 앱 소개
#### Onboarding
- 임시.

-------------

### 구현 기능
- 임시.

-------------

### 개발 공수
| 날짜 | View | 세부내용 | 소요시간 | 특이사항 | 기간 |
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
| 9 | Auth | 인증번호로 로그인 | 1h |  |  |
| 9 | Nickname | Layout | 30m |  |  |
| 9 | Nickname | 유효성 검사/UI 반응 구현 | 1h |  |  |
| 9 | Email | 유효성 검사/UI 반응 구현 | 1h |  |  |
| 10 | Birth | Layout |  |  |  |
| 10 | Birth | DatePicker 구현 |  |  |  |
| 10 | Gender | Layout | 1h |  |  |
| 10 | Gender | 성별 선택 UI 반응 구현 | 1h |  |  |
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
- (정규표현식)유효성 검사에 따른 Button 컬러 변경, 하이픈 추가, 토스트 얼럿 띄우는 기능 등 LoginView에 대한 기능은 얼추 끝낸 것 같다.
- 하지만 글자수 11자 제한 등 세세한 부분에서 보완할 부분이 아주 많아 보인다.
- 특히 TextField 에서 백스페이스로 숫자를 지울 때, 하이픈을 만나면 더이상 지워지지 않는 버그가 있어 빨리 고쳐야 할 것 같다.

#### 11/09
- 하이픈이 지워지지 않는 버그를 수정했다.
- phoneNumber.count 에 조건문으로 하이픈을 추가했었는데, 하이픈이 insert 되는 인덱스와 지우려고 하는 인덱스가 겹쳐서 발생한 것이었다.
- 조건인 count를 한개씩 올려줘서 세번째 숫자가 입력된 다음이 아닌, 네번째 숫자가 입력되기 직전에 하이픈을 넣으니 정상적으로 동작한다.
- 그 외 TextField 글자수 제한, 입력중일 때 밑줄 색상 변경, 토스트, 키보드 자동 업/다운 등 자잘한 기능을 추가했다.
- LoginViewModel에서 UserDeaults에 verificationID를 저장하고, AuthViewModel에서 인증번호와 함께 로그인 요청하는 로직을 구현했다.
- 로그인에 실패했을 경우 에러 종류에 따라 다른 토스트 메세지를 보여주어야 하는데, statusCode를 기본적으로 제공하지 않기 때문에 별도로 코드가 필요할 것 같다.
- 토스트 메세지를 계속 열거형으로 구성해왔는데, 이번 뷰에서는 두 에러 상황에 대한 토스트 메세지가 같기 때문에 연관값으로 설정하지 못하기 때문에 함수나 연산 프로퍼티를 활용할 예정이다.
- 유저디폴트를 활용해 유저가 기입한 내용들을 임시저장하고, viewDidLoad에서 다시 불러오도록 설정했다.
- AuthViewController 의 viewDidLoad 시점에 인증번호를 발송했다는 토스트를 띄워주는데, 토스트가 정상적인 위치에 보이지 않는 버그가 있다.

#### 11/10
- 팀원분의 조언으로 AuthViewController 토스트 문제를 해결했다.
- 사실 왜 이런 현상이 발생하는지는 잘 모르겠고, DispatchQueue.main.async 에 넣으니 정상적으로 보인다. 왜일까...
- GenderView의 버튼 UI를 Configuration으로 구성하니, 익숙하지 않아서 그런지 선택했을 때의 backgroundColor 변경이 어려웠다.
- 어찌저찌 구현은 했지만, 고작 선택시의 색상 변경에 코드량이 이정도가 맞나...? 싶은 의문이 든다.
