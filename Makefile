patchfile=patch.bz2

default: all

all: main ahh

main ahh: %: %-default

main-%:
	make -C main $*

ahh-%:
	make -C ahh $*

tidy:
	rm -f *~

clean: tidy

cleanall: clean main-clean ahh-clean

help:
	@cat make.help

.PHONY: default all main ahh main-% ahh-% tidy clean cleanall help
