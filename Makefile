docker-build:
	docker build -t docker.miezhaus/flutter_arm64 ./docker/test
	docker push docker.miezhaus/flutter_arm64 