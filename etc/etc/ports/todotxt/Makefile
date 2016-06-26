GITHUB_URL = https://github.com/ginatrapani/todo.txt-cli
BIN_PATH = $(shell echo $(CAD_BIN_PATH))
ETC_PATH = $(shell echo $(CAD_ETC_PATH))

get_repo: 
	-git clone $(GITHUB_URL)

install: get_repo
	cd todo.txt-cli/tests ; \
		make test
	cp todo.txt-cli/todo.sh $(BIN_PATH)/todo 

clean:
	-rm -rf to.txt-cli 

uninstall: 
	rm $(BIN_PATH)/todo 
