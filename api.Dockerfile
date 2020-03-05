FROM golang:1.13.6
COPY . /go/src/github.com/lutomas/microservice_docker
WORKDIR /go/src/github.com/lutomas/microservice_docker
RUN make install-docker-backend

FROM alpine:latest
COPY --from=0 /go/bin/ktu_microservice /bin/ktu_microservice
ENTRYPOINT ["/bin/ktu_microservice"]

EXPOSE 8080