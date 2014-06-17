
ifndef prefix
prefix=/usr/local
endif

PROGRAM_NAME=gauge

build:
	cd .. && export GOPATH=$(GOPATH):`pwd` && cd gauge-ruby && go build

install:
	install -m 755 -d $(prefix)/bin
	install -m 755 $(PROGRAM_NAME)-ruby $(prefix)/bin
	install -m 755 -d $(prefix)/lib/$(PROGRAM_NAME)/ruby/lib
	install -m 644 lib/* $(prefix)/lib/$(PROGRAM_NAME)/ruby/lib
	install -m 755 -d $(prefix)/share/$(PROGRAM_NAME)/languages
	install -m 644 ruby.json $(prefix)/share/$(PROGRAM_NAME)/languages
	install -m 755 -d $(prefix)/share/$(PROGRAM_NAME)/skel/ruby
	install -m 755 -d $(prefix)/share/$(PROGRAM_NAME)/skel/env
	install -m 644 skel/step_implementation.rb $(prefix)/share/$(PROGRAM_NAME)/skel/ruby
	install -m 644 skel/ruby.properties $(prefix)/share/$(PROGRAM_NAME)/skel/env
