usr_local ?= /usr/local

bin_dir = $(usr_local)/bin
lib_dir = $(usr_local)/lib

.PHONY: build install uninstall clean

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/nibject" "$(bin_dir)"

uninstall:
	rm -rf "$(bin_dir)/nibject"
    
clean:
	rm -rf .build
