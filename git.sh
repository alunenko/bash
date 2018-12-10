#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

endSpace() {
	echo "\n\n"
}

continueSpace () {
	read n
}

installGit () {
	echo "\n ${YELLOW}Start install git.${NC}"
	sudo apt-get -y install git
	echo "\n ${YELLOW}End install git.${NC}"
}

defaultAliases () {
	echo "\n${YELLOW}Set default aliases.${NC}"
	
	git config --global alias.co checkout
	echo "${YELLOW}co${NC} = checkout"
	
	git config --global alias.br branch
	echo "${YELLOW}br${NC} = branch"
	
	git config --global alias.ci commit
	echo "${YELLOW}ci${NC} = commit"

	git config --global alias.st status
	echo "${YELLOW}st${NC} = status"

	git config --global alias.sl 'stash list'
	echo "${YELLOW}sl${NC} = stash list"

	git config --global alias.sa0 'stash apply stash@{0}'
	echo "${YELLOW}sa0${NC} = stash apply stash@{0}"

	git config --global alias.cmpom "!sh -c 'git checkout master; git pull origin master'"
	echo "${YELLOW}cmpom${NC} = git checkout master; git pull origin master"

	git config --global alias.crdpord "!sh -c 'git checkout release-devops; git pull origin release-devops'"
	echo "${YELLOW}crdpord${NC} = git checkout release-devops; git pull origin release-devops"

	git config --global alias.crepore "!sh -c 'git checkout release-echo; git pull origin release-echo'"
	echo "${YELLOW}crepore{NC} = git checkout release-echo; git pull origin release-echo"
	endSpace
}

setAuthor () {
	echo "\n${YELLOW}Write your name.${NC}"
	read gitName
	git config --global user.name $gitName

	echo "\n${YELLOW}Write your email.${NC}"
	read gitEmail
	git config --global user.email $gitEmail
	endSpace
}

generateSsh () {
	echo "\n${YELLOW}Generate ssh-key.${NC}"
	echo "${YELLOW}Files plased into ${RED}/home/$USER/.ssh ${YELLOW}folder.${NC}"
	currentPlace=$(pwd)
	cd /home/$USER/.ssh || {
		mkdir /home/$USER/.ssh
	}
	echo "${YELLOW}Type your e-mail.${NC}"
	read email
	
	echo "\n${YELLOW}Type filename.${NC}"
	read filename

	ssh-keygen -t rsa -b 4096 -C "$email" -f "$filename"
	
	#sudo apt install xclip
	cat "$filename.pub" | xclip -sel clip
	echo "\n${YELLOW}Public kay was copy to clipboard. Add this key to ${RED}http://github.com${NC}"
	
	cd "$currentPlace"
	endSpace
}

testSsh () {
	echo "\n${YELLOW}Test ssh-key for ${RED}http://github.com${NC}"
	ssh -T git@github.com
	echo "${YELLOW}End check ssh-key for github.com${NC}"
	endSpace
}

addKeyAgent() {
	echo "\n${YELLOW}Type the filename you need to add.${NC}"
	read filename
	eval "$(ssh-agent -s)"
	ssh-add /home/$USER/.ssh/$filename
	endSpace
}

deleteKey() {
	echo "\n${YELLOW}Type the keyname which need to delete.${NC}"
	read filename
	rm /home/$USER/.ssh/$filename
	rm /home/$USER/.ssh/"$filename.pub"
	echo "${YELLOW}Key $filename was deleted.${NC}"
	endSpace
}

# start script/app below
title="Git"
prompt="Git menu:"
options="
1:	all
2:	set default aliases
3:	set author
4:	generate ssh-key for github.com
5:	test ssh-key for github.com
6:	add key to git agent (eval)
7:	delete key
8:	install git
"

clear
echo "$title"
echo "$prompt"
echo "$options"

read n

case $n in
	1)
	   installGit
	   setAuthor
	   generateSsh
	   continueSpace
	   addKeyAgent
	   sleep 3s
	   testSsh
	   defaultAliases
	   ;;
	2)
	   defaultAliases
	   ;;
	3)
	   setAuthor
	   ;;
	4)
	   generateSsh
	   ;;
	5)
	   testSsh
	   ;;
	6)
	   addKeyAgent
	   ;;
	7)
	   deleteKey
	   ;;
	8)
	   installGit
	   ;;
	*) echo "${RED}Invalid option -$n-.
			 \n${GREEN}Exit.${NC}"
	   ;;
esac
