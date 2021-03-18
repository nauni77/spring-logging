# avoid up-2-date checks
.PHONY: build run exec exec-root

.EXPORT_ALL_VARIABLES:
DOCKER_TAG = 0.1
DOCKER_TAG_EXT = _4

echo:
	echo "DOCKER_TAG: ${DOCKER_TAG}"
	echo "DOCKER_TAG_EXT: ${DOCKER_TAG_EXT}"

clean:
	./gradlew clean
	docker builder prune -f

build:
	## first create the spring release
	./gradlew bootJar
	mkdir build/extractedJar
	(cd build/extractedJar; tar -zxf ../libs/spring-logging-test-dev.jar)
	
	## for real build but not for development
	#docker build . --no-cache -t gematik-server:dev
	## for development
	docker build . -t spring-logging-test:dev
	
	rm -rf build/extractedJar
	rm build/libs/spring-logging-test-dev.jar

cleanBuild: clean build

tagAndPush: build
	docker tag spring-logging-test:dev vsa-docker.intra.vsa.de/noventi/test/spring-logging-test:${DOCKER_TAG}${DOCKER_TAG_EXT}
	docker push vsa-docker.intra.vsa.de/noventi/test/spring-logging-test:${DOCKER_TAG}${DOCKER_TAG_EXT}

cleanTagAndPush: cleanBuild tagAndPush

deployPatchVersion:
	(cd deployment/overlays/cluster; kustomize edit set image docker.intra.vsa.de/noventi/test/spring-logging-test:UNSET_IMAGE_TAG=docker.intra.vsa.de/noventi/test/spring-logging-test:${DOCKER_TAG}${DOCKER_TAG_EXT})

deployUnpatchVersion:
	(cd deployment/overlays/cluster; kustomize edit set image docker.intra.vsa.de/noventi/test/spring-logging-test:UNSET_IMAGE_TAG=docker.intra.vsa.de/noventi/test/spring-logging-test:UNSET_IMAGE_TAG)

deployShowYamlOutput: deployPatchVersion
	kustomize build deployment/overlays/cluster

deployExecute:
	kustomize build deployment/overlays/cluster | kubectl apply -f -

deploy: deployPatchVersion deployExecute deployUnpatchVersion

doAll: build tagAndPush deploy

run:
	docker run --rm --name spring-logging-test -v ${PWD}/exchange:/exchange -p 8080:8080 spring-logging-test:dev

stop:
	docker stop spring-logging-test

exec:
	docker exec --user bls19 -ti spring-logging-test /bin/bash

exec-root:
	docker exec --user root -ti spring-logging-test /bin/bash

