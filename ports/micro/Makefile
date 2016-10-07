URL="https://github.com/zyedidia/micro"
TIMESTAMP=$(shell iso8601date)
APPTAG=$(TIMESTAMP)-micro-port
TEMP_DIR=$(shell temputils $(APPTAG) get)
install:
	temputils $(APPTAG) create
	cd $(TEMP_DIR) && git clone $(URL)
	cd $(TEMP_DIR) && cd micro && make install
	temputils $(APPTAG) destroy
uninstall:
	rm $(GOPATH)/bin/micro

