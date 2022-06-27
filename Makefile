.PHONY: build run

.ONESHELL:
current_dir=$(shell pwd)
hostname=$(shell hostname)

# Build docker image locally
db:
	@echo "--- :docker: Build the Docker container"
	docker build -t certtest .

build:
	@echo "--- :docker: Build the Docker container"
	docker build -t snowparklab docker

run: build
	@echo "--- :docker: Starting your Jupyter environment"
	docker run -it --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v "$(current_dir)":/home/jovyan/snowparklab --name snowparklab snowparklab

initx11:
	@echo "NB: don't forget to allow network connections in preferences.security"
	@echo "NB!!!: restart after fresh xquartz installation"
	brew install xquartz

runx:
	@echo "--- :docker: Starting your Jupyter environment with x11"
	open -a XQuartz
	xhost + $(hostname)
	docker run -it --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -e DISPLAY=$(hostname):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$(current_dir)":/home/jovyan/snowparklab --name snowparklab --shm-size 2g --privileged snowparklab

stop:
	@echo "--- :docker: Stopping your Jupyter environment"
	docker stop snowparklab