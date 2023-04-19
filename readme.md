# Spring PetClinic Sample Application built with Spring Data JDBC on K8S

이 프로젝트는 Spring PetClinic Sample Application built with Spring Data JDBC를 base로 구성한 프로젝트입니다.

## 요구사항 적용
- maven으로 진행되는 Build를 gradle로 전환
- k8s에서 구동이 가능하도록 manifest(yaml)를 작성
- 어플리케이션의 log는 host의 /logs 디렉토리에 적재
- health 체크 api 코드 하여 pod상태 체크(10s마다 체크, 3회 연속 실패시 교체)
- 종료 시 30초 이내에 프로세스가 종료되지 않으면 SIGKILL로 강제 종료
- ingress(nginx-ingress-controller) -> service -> pod 로 app구성
    - 배포시 Endpoint에 대한 중단 없이 scale in/out 가능하도록 구성
    - strategy 설정을 통해 롤링 업데이트 적용
- 어플리케이션 프로세스는 root 계정이 아닌 uid:1000으로 실행
- DB 환경 PV, PVC 구성 데이터 유지
- 어플리케이션과 DB는 cluster domain으로 통신
- docker 이미지를 만들고 k8s에서 application 이미지로 사용

## 환경 구성
- gradle 설치
- gradlew 설치
- kustomize 설치

## Run
```bash
sh ./build.sh
sh ./deploy.sh
```
- app 버전 관리: deployment.yaml, gredle.build
- app:{version}

## 소스 빌드 (maven)
### maven 빌드 & 구동
```bash
# 이전 버전 빌드 정리
./mvnw clean
# 소스 빌드
./mvnw package
# local 구동
java -jar target/*.jar
```
### 컨테이너 이미지 생성 & 업로드(Docker hub를 사용하는 경우)
```bash
# 이미지 생성
docker build -t {이미지명}:{버전} .
# 업로드할 이미지 태깅
docker tag {이미지 ID} {docker hub 계정}/{이미지명}:{버전}
# docker hub 접속(ID/PW 입력)
docker login
# 이미지 업로드
docker push {docker hub 계정}/{이미지명}:{버전}
```

## 소스 빌드 (gradle)
### gradle 빌드 & 구동 & 컨테이너이미지업로드
```bash
# CSS 이미지 복사(maven build:wro4j로 작성된 CSS파일 복사)
./gradlew mavenCSS
# 소스 빌드
./gradlew clean build
# local 구동
java -jar build/libs/*.jar
# 컨테이너 이미지를 docker hub로 업로드
./gradlew buildDocker
```

## k8s manifest(kustomize)
```bash
.
└── manifest
    ├── base
    │   ├── db
    │   │   ├── kustomization.yaml
    │   │   ├── deployment.yaml
    │   │   ├── service.yaml
    │   │   └── pv-pvc.yaml
    │   │ 
    │   └── springboot
    │       ├── kustomization.yaml
    │       ├── deployment.yaml
    │       ├── service.yaml
    │       └── ingress.yaml
    │ 
    └── overlays
        └── prod
            └── kustomization.yaml
```
### Deploy k8s
```bash
kustomize build manifest/overlays/prod | kubectl -n default apply -f -
```

### Delete k8s
```bash
kustomize build /manifest/overlays/prod | kubectl -n default delete -f -
```

# issue 정리
- Gradle 빌드시 wro4j를 통한 CSS가 소스에 반영되지 못함
    - maven build를 통해 만들어진 CSS로 사이트 오픈 진행
    - wro4j -> webpack 전환 필요

# 참고
- "Gradle Build Tool Install" https://gradle.org/install/
- "Gradle Wrapper" https://docs.gradle.org/current/userguide/gradle_wrapper.html
- "Kustomize Install" https://kubectl.docs.kubernetes.io/installation/kustomize/