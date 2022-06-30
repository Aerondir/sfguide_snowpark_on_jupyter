.PHONY: build run stop bash root

.ONESHELL:
current_dir=$(shell pwd)
hostname=$(shell hostname)
local_ip=$(shell ifconfig en0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

bash:
	docker exec -it snowparklab bash

root:
	docker exec -it -u root snowparklab bash

build:
	@echo "--- :docker: Build the Docker container"
	docker build -t snowparklab -t snowparklab:zulu8 docker

initx11:
	open -a XQuartz
	xhost + $(local_ip)

bu14:
	docker build -t ubuntu14:local docker -f docker/ubuntu14.Dockerfile

bu18:
	@echo "--- :docker: Build the Docker container"
	docker build -t snowparklab:u18 docker -f docker/local.Dockerfile

ru18: initx11
	docker run -it --rm --user root -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -e DISPLAY=$(local_ip):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$(current_dir)":/home/jovyan/snowparklab --name snowparklab --shm-size 2g --privileged snowparklab:u18

bo8:
	@echo "--- :docker: Build the Docker container"
	docker build -t snowparklab:oracle8 docker -f docker/ojdk8.Dockerfile

ba7:
	@echo "--- :docker: Build the Docker container"
	docker build -t snowparklab:azul7 docker -f docker/azul7.Dockerfile

ra7: initx11
	docker run -it --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -e DISPLAY=$(local_ip):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$(current_dir)":/home/jovyan/snowparklab --name snowparklab --shm-size 2g --privileged snowparklab:azul7

ro8: initx11
	docker run -it --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -e DISPLAY=$(local_ip):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$(current_dir)":/home/jovyan/snowparklab --name snowparklab --shm-size 2g --privileged snowparklab:oracle8

run: build
	@echo "--- :docker: Starting your Jupyter environment"
	docker run -it --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v "$(current_dir)":/home/jovyan/snowparklab --name snowparklab snowparklab

installx11:
	@echo "NB: don't forget to allow network connections in preferences.security"
	@echo "NB!!!: restart after fresh xquartz installation"
	brew install xquartz

runx: initx11
	@echo "--- :docker: Starting your Jupyter environment with x11"
	docker run -it --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -e DISPLAY=$(local_ip):0 -v /tmp/.X11-unix:/tmp/.X11-unix -v "$(current_dir)":/home/jovyan/snowparklab --name snowparklab --shm-size 2g --privileged snowparklab

stop:
	@echo "--- :docker: Stopping your Jupyter environment"
	docker stop snowparklab