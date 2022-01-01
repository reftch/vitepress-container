
APP_NAME?=vitepress-app
DOCKER?=docker
TAG?=16-alpine
PORT?=3000
APP_DIR?=app

.PHONY: clean init app prod prod-run

clean:
	rm -rf .pnpm-store
	rm -rf ${APP_DIR}/node_modules
	rm -rf ${APP_DIR}/docs/.vitepress/dist
	rm -f ${APP_DIR}/pnpm-lock.yaml
	rm -f ${APP_DIR}/package-lock.json

clean-docker:
	${DOCKER} image prune -a -f

init:
	${DOCKER} build \
		-f Dockerfile app/ \
		-t ${APP_NAME}:${TAG} \
		--build-arg TAG=${TAG} \
		--no-cache
	${DOCKER} container run \
		--name ${APP_NAME}-dev \
		--rm \
		-t \
		-v "${CURDIR}":/app \
		-e APP_DIR=${APP_DIR} \
		${APP_NAME}:${TAG} \
		-c "cd /app/${APP_DIR} && pnpm install"

dev:
	${DOCKER} container run \
		--name ${APP_NAME} \
		--rm \
		-t \
		-p ${PORT}:3000 \
		-v "${CURDIR}":/app \
		${APP_NAME}:${TAG} \
		-c "cd /app/${APP_DIR} && pnpm $(filter-out $@,$(MAKECMDGOALS))"

dev-stop:
	${DOCKER} container stop ${APP_NAME}

vite-sh:                                                                                                                                                                                                                                                                            
	docker exec -it ${APP_NAME} /bin/sh

%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
