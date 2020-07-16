FROM python:3.8-alpine

RUN apk --no-cache add jq=1.6-r1 curl=7.69.1-r0 gcc=9.3.0-r2 musl-dev=1.1.24-r9 bash=5.0.17-r0
RUN pip install black==19.10b0 flake8==3.8.3
COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
