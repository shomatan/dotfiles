
DIR := `pwd | sed -e 's/test//g'`

centos7:
	docker build -t dotfiles-centos7 .
	docker run --rm -it -v ${DIR}:/root/dotfiles dotfiles-centos7 sh /root/dotfiles/install.sh