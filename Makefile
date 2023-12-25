MAKEFLAGS += -j2

APP_NAME = astro-with-nginx
GIT_TAG = ${shell git tag | tail -1}


default: dev-frontend
build: build-frontend
deps: deps-frontend
start: default

rtx:
	rtx install



### install dependecies
deps-frontend:
	bun install

# deps-backend:
# 	cargo check


### dev server
dev-frontend:
	bun --bun run start

# dev-backend:
# 	cargo loco start
#
# start-docker-compose:
# 	docker compose up -d
#
# stop-docker-compose:
# 	docker compose down

### build for prod
build-frontend:
	bun --bun run build

# build-backend:
# 	cargo build --release
#
build-docker-image:
	docker build --tag ${APP_NAME}:${GIT_TAG} .
#
run-docker:
	docker run --rm -p 4000:80 --env-file .env.local --name ${APP_NAME}-${GIT_TAG} ${APP_NAME}:${GIT_TAG}
