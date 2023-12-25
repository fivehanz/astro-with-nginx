

ARG BUN_VERSION=1.0.20
ARG NGINX_VERSION=1.25
ARG PORT=8080

ARG NGINX_RUNNER_IMAGE=nginx:${NGINX_VERSION}-bookworm


### frontend build stage
FROM oven/bun:${BUN_VERSION} as bun-builder

# build frontend app
WORKDIR /app
COPY . .

RUN apt update && apt install make -y
RUN make deps
RUN make build-frontend



### nginx server runner
FROM ${NGINX_RUNNER_IMAGE} as runner

ENV PORT ${PORT}
EXPOSE $PORT

# copy nginx config files to nginx container
# COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
# COPY ./nginx/app.conf /etc/nginx/conf.d/app.conf

# replace PORT with $PORT in the config file
# RUN sed -i "s/PORT/$PORT/g" /etc/nginx/conf.d/app.conf

WORKDIR /app

# copy from builder
COPY --from=bun-builder /app/dist /app/
RUN chown -R nginx:nginx /app/




# CMD [ "nginx" ]
