
DIR := `pwd | sed -e 's/test//g'`

centos7:
	-docker rm -f dotfiles-centos7
	
	docker build -t dotfiles-centos7 .
	docker run --name dotfiles-centos7 -itd -v ${DIR}:/root/dotfiles -v ${PWD}:/test dotfiles-centos7
	docker exec -it dotfiles-centos7 /root/dotfiles/install.sh
	docker exec -it dotfiles-centos7 zsh -c "exit"
	docker exec -it dotfiles-centos7 zsh -c "cd /test && goss validate --format documentation"

	docker rm -f dotfiles-centos7