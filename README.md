# Mark In

<div align="center">
<img src = "https://github.com/user-attachments/assets/ae8723f2-4c94-4e51-83ba-eeba08deafd4" width ="125" height = "125">

URL 링크를 저장하고 관리하는 macOS 앱 입니다.
</div>



## 📸 스크린 샷
![123](https://github.com/user-attachments/assets/64132e11-dcfc-4234-9439-3d00335720a6)

## 📝 주요 기능
- 소셜 로그인을 통해 사용자를 식별
- URL 링크 관리 (추가, 접속, 삭제)


## 🔨 기술 스택
- SwiftUI
- Swift Concurrency
- LinkPresentation
- Authenticate Service
- GoogleSignIn
- Firebase (Authenticate, Firestore, Storage, Function)

## 🧱 설계
- 클린 아키텍처를 적용해 관심사를 분리하고, 비즈니스 정책(Domain)과 세부 구현(View, Data)을 명확히 구분
- 재사용성을 고려해 모듈화 설계
- TCA의 Reducer, Store를 참고하여 단방향 아키텍처 설계 및 적용
- DIP를 적용하여 객체간 결합도를 낮추고, 테스트 용이성을 높임
