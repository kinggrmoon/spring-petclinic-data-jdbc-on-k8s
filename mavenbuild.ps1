# clean 명령을 실행합니다.
.\mvnw clean

# package 명령을 실행합니다.
.\mvnw package

# Docker 이미지 빌드
docker build -t app:1.0.0 .

# Docker 이미지 태깅
docker tag app:1.0.0 kinggrmoon/test01

# Docker Hub 로그인
docker login

# Docker 이미지 업로드
docker push kinggrmoon/test01:latest