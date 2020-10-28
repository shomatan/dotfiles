
DIR := `pwd | sed -e 's/test//g'`
CENTOS_IMAGE_NAME := dotfiles-centos7
UBUNTU_IMAGE_NAME := dotfiles-ubuntu20

run-centos7:
	-docker rm -f $(CENTOS_IMAGE_NAME)
	
	docker build -t $(CENTOS_IMAGE_NAME) ./docker/centos7
	docker run --name $(CENTOS_IMAGE_NAME) -id -v ${DIR}:/root/dotfiles -v ${PWD}:/test $(CENTOS_IMAGE_NAME)
	docker exec -i $(CENTOS_IMAGE_NAME) /root/dotfiles/install.sh
	docker exec -i $(CENTOS_IMAGE_NAME) zsh -c "exit"
	docker exec -i $(CENTOS_IMAGE_NAME) zsh -c "cd /test && goss validate --format documentation"

	docker rm -f dotfiles-centos7

run-ubuntu20:
	-docker rm -f $(UBUNTU_IMAGE_NAME)
	
	docker build -t $(UBUNTU_IMAGE_NAME) ./docker/ubuntu20
	docker run --name $(UBUNTU_IMAGE_NAME) -id -v ${DIR}:/root/dotfiles -v ${PWD}:/test $(UBUNTU_IMAGE_NAME)
	docker exec -i $(UBUNTU_IMAGE_NAME) /root/dotfiles/install.sh
	docker exec -i $(UBUNTU_IMAGE_NAME) zsh -c "exit"
	docker exec -i $(UBUNTU_IMAGE_NAME) zsh -c "cd /test && goss validate --format documentation"

	docker rm -f dotfiles-centos7

rerun-centos7:
	docker exec -i $(CENTOS_IMAGE_NAME) /root/dotfiles/install.sh
	docker exec -i $(CENTOS_IMAGE_NAME) zsh -c "exit"
	docker exec -i $(CENTOS_IMAGE_NAME) zsh -c "cd /test && goss validate --format documentation"

rerun-ubuntu20:
	docker exec -i $(UBUNTU_IMAGE_NAME) /root/dotfiles/install.sh
	docker exec -i $(UBUNTU_IMAGE_NAME) zsh -c "exit"
	docker exec -i $(UBUNTU_IMAGE_NAME) zsh -c "cd /test && goss validate --format documentation"

exec-centos7:
	docker exec -it $(CENTOS_IMAGE_NAME) zsh

exec-ubuntu20:
	docker exec -it $(UBUNTU_IMAGE_NAME) zsh
