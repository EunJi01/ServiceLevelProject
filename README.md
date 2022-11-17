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

### 보완해야 할 점!
- UINavigationBar 백버튼 이미지/타이틀
- 현재 런치스크린이 뜰 때만 네트워크 상태 체크를 하지만, API 통신하는 모든 곳에서 네트워크 체크하도록 개선하기

-------------

### 개발 공수
| 날짜 | View | 세부내용 | 소요시간 | 특이사항 | 기간 |
| --- | --- | --- | --- | --- | --- |
| **1주차** |  |  |  |  | **~2022.11.13** |
| 7 | 모듈화 | Extension, Protocol, enum... | 2h |  |  |
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
| 10 | Birth | Layout | 2h |  |  |
| 10 | Gender | Layout | 1h |  |  |
| 10 | Gender | 성별 선택 UI 반응 구현 | 1h |  |  |
| 11 | 모듈화 | UserDefaultsKey 개선 | 30m |  |  |
| 11 | 모듈화 | 네트워트 관련 코드 분리 | 30m |  |  |
| 11 | SceneDelegate | rootView 조건 구현 | 30m |  |  |
| 11 | Auth | 인증번호 재전송 구현 | 1h |  |  |
| 12 | Birth | DatePicker 구현 | 4h | 기존 입력값 불러오는 코드 삽질 |  |
| 13 | 회원가입 | 회원가입 API 통신 | 6h | 삽질 끝판왕 |  |
| 13 | Login/Auth | 중복 클릭 방지 | 1h |  |  |
| 13 | Signup | 부적절한 닉네임 분기처리 | 1h |  |  |
| 13 | Launch | 네트워크 체크/rootView 분기처리 | 2h |  |  |
|  |  |  |  |  |  |
| **2주차** |  |  |  |  | **~2022.11.20** |
| 14 | Mypage | Layout | 1h |  |  |
| 14 | Launch/회원가입 | idToken 갱신 코드 추가 | 1h |  |  |
| 15 | Home | Layout | 1h |  |  |
| 15 | ManageMypage | Layout | 5h |  |  |
| 16 | ManageMypage | 데이터 뷰에 보여주기 | 1h |  |  |
| 17 | Home | MapView 권한/위치 | 2h |  |  |
| 17 | Home | CustomAnnotation | 1h |  |  |
| 17 | 모듈화 | APIManager 간소화 | 30m |  |  |
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
- BirthView 에서는 스텍뷰를 활용해 텍스트필드와 레이블의 레이아웃을 잡아줬는데, 코드로 스텍뷰를 사용하는게 처음이라 시간이 오래 걸렸다.

#### 11/11
- @propertyWrapper를 통해 UserDefaults의 Key를 더 편하게 관리하고 사용할 수 있도록 개선했다.
- 재전송 버튼을 구현하기 전에, ViewModel에 그냥 넣어두었던 네트워크 통신 관련된 코드를 분리했다.
- SceneDelegate에서 총 세 개의 조건문 (회원가입 여부 -> (false일 경우)전화번호 인증 여부 -> (false일 경우)온보딩 여부) 을 통해 rootViewController를 정하도록 구현했다.

#### 11/12
- 데이트피커에서 날짜가 변경될 때마다 ViewModel에서 년, 월, 일로 각각 포맷해서 텍스트필드에 반영되도록 구현했다.
- 사용자가 생일을 입력하고 앱을 종료했을 경우, 다시 실행했을 때 입력했던 생일을 불러오는 기능을 구현하는 부분에서 삽질을 조금 했다.
- 원래는 데이트피커에서 날짜가 변경될 때 변경된 날짜에 대해 유효성을 검증했지만, 앱을 다시 켰을 경우에 불러온 생일은 데이트피커를 통한 Date 의 변경이 아니기 때문에 인식을 하지 못하는 문제가 있었다.
- 이를 해결하기 위해 처음에는 데이트피커가 바뀔 때마다 유저디폴트에 저장하도록 수정해봤지만, 이렇게 하면 asSignal(onErrorJustReturn:) 을 통해 초기값으로 Date() 를 넘기고 있기 때문에, 아무것도 입력하지 않아도 오늘 날짜가 생일로 저장된다...
- 따라서 값 저장은 생일이 유효할 때만 (17세 이상) 저장하도록 변경하고, 앱을 켰을 때 유저디폴트에 저장된 생일을 표시하도록 변경했다.
- 아직은 RxSwift 가 미숙하기 때문에 이런 방법으로 해결했지만 초기값을 넘기지 않고 값을 전달하는 방법도 공부해야겠다.

#### 11/13
- 회원가입/로그인 통신에 verificationID와 firebaseToken 두개가 필요하다고 생각해서, 정말 이틀동안 8시간은 삽질한 것 같다...
- 알고보니 Auth.auth().currentUser에서 따로 idToken을 가져와야 한다는 것을 팀원분께서 알려주셔서 겨우 통신에 성공했다.
- UINavigationController를 extension 해서 특정 뷰까지 돌아가는 함수를 만들고, 사용자가 부적절한 닉네임으로 회원가입을 요청했을 경우 얼럿을 띄운 후 확인 버튼을 누르면 NicknameView 까지 돌아가도록 구현했다.
- Rx의 throttle를 활용해 인증번호 메세지 전송/재전송 및 회원가입 요청 버튼은 4초마다 이벤트를 방출하도록 개선했다.
- excessiveRequestTap 라는 input을 하나 더 만들어 인증번호 전송/재전송 버튼의 이벤트를 받되 skip을 통해 초반 5개의 이벤트는 무시하고, 6개째부터는 과도한 시도가 있었다는 토스트를 띄우도록 개선했다.
- 런치스크린과 동일한 화면의 ViewController를 만들어서, 해당 ViewController에서 네트워크 연결 상태를 확인하고, 로그인 요청 후 결과에 따라 화면을 전환하도록 개선했다.

#### 11/14
- 금요일에 있는 Weekly Conference 발표 자료를 다듬느라 코딩을 많이 하지는 못했다.
- TableViewCell 파일을 두 개 만들어, 섹션마다 Cell이 다르도록 MypageView의 레이아웃을 구성했다.
- Firebase User IDToken의 유효시간이 한시간밖에 안 된다는 것을 이제 알아서, 앱 실행시 한번 갱신하고, GenderView에서 회원가입 시 에러가 발생할 경우 자동으로 갱신하도록 플로우를 변경했다.
- 정보관리 화면은... 셀마다 너무 다른 구성이라 어떻게 UI를 만들어야 할지 감이 잘 안잡힌다.
- 스크롤뷰와 스텍뷰로 구성해야 할까...? 그렇다면 UILabel도 하나하나 객체를 생성해야 하는 걸까? 팀원분들은 어떻게 했는지 내일 여쭤봐야겠다.

#### 11/15
- Home쪽 레이아웃을 간단하게 잡았으며, 버튼쪽 cornerRadius는 maskedCorners를 활용해 부분적으로 둥글게 말아주었다.
- 정보관리뷰의 레이아웃이 마음처럼 잡히지 않는다. 너무너무 화난다.

#### 11/16
- 아파서 토하고 몸져누웠음ㅠㅠㅠ

#### 11/17
- MapView 권한 설정/ 분기처리 / 현재 위치 받아오기 / 현재위치 혹은 영등포캠퍼스 어노테이션 구현
- CustomAnnotationView 라는 이름의 MKAnnotationView 와 CustomAnnotation를 만들어 새싹 이미지를 핀으로 사용할 수 있도록 준비했다.
- MapView 쪽 진입하니 도저히 rx로 구현하기가 어려워서, 우선은 MVC 패턴으로 구현했다...
