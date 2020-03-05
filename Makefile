
.PHONY = run

LDFLAGS		+= -s -w
LDFLAGS_LINUX		+= -linkmode external -extldflags -static

run:
	@echo "++ RUN BACKEND SERVER"
	cd cmd/ktu_microservice && go run .

install-docker-backend:
	@echo "++ Building BACKEND binary for DOCKER"
	GOOS=linux CGO_ENABLED=1 go install -ldflags "$(LDFLAGS_LINUX) $(LDFLAGS)" github.com/lutomas/microservice_docker/cmd/ktu_microservice

install-backend:
	@echo "++ Building BACKEND binary"
	CGO_ENABLED=0 go install -ldflags "$(LDFLAGS)" github.com/lutomas/microservice_docker/cmd/ktu_microservice

backend_docker:
	docker build -t ktu/ktu_microservice_api:alpha -f api.Dockerfile .

docker-run: backend_docker
	#docker run -p 18080:8080 ktu/ktu_microservice_api:alpha
	docker run -p 18080:8080 -e "PORT=18080" ktu/ktu_microservice_api:alpha

docker-run-deamon: docker-stop-deamon backend_docker
	docker run -d --name ktu-mikro-deamon -p 28080:8080 -e "PORT=28080" -e="NAME=Arteja pavasaris" ktu/ktu_microservice_api:alpha

docker-stop-deamon:
	docker stop ktu-mikro-deamon
	docker rm ktu-mikro-deamon