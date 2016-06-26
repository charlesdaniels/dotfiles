BIN_PATH = $(shell echo $(CAD_BIN_PATH))
ETC_PATH = $(shell echo $(CAD_ETC_PATH))
FISH_VERSION = 2.2.0
FISH_URL = http://fishshell.com/files/$(FISH_VERSION)/fish-$(FISH_VERSION).tar.gz
TEMP_DIR = "/tmp/fish_compile"
PREFIX_DIR=$(ETC_PATH)/fish_prefix

get_tarball:
	wget $(FISH_URL)
	tar xvzf fish-$(FISH_VERSION).tar.gz

install: get_tarball
	mkdir $(TEMP_DIR)
	cd fish-$(FISH_VERSION); \
	./configure --prefix=$(TEMP_DIR) --disable-shared; \
	make; \
	make install; 
	mkdir $(PREFIX_DIR)
	mv $(TEMP_DIR)/* $(ETC_PATH)/fish_prefix;
	rm -rf $(TEMP_DIR)
	ln -s $(PREFIX_DIR)/bin/fish $(BIN_PATH)/fish 

clean:
	-rm -rf fish-$(FISH_VERSION) 
	-rm fish-$(FISH_VERSION).tar.gz
	-rm fish-$(FISH_VERSION).tar.gz.*

uninstall: 
	-rm $(BIN_PATH)/fish 
	-rm -rf $(PREFIX_DIR)