patchfile=patch.bz2

default:
	@echo No default target.
	@echo Try "make help" for a list of possible targets.

patch:
	bk send - | bzip2 --best > $(patchfile)

apply:
	bzcat $(patchfile) | bk receive
	bk resolve -a

tidy:
	rm -f *~

clean:
	rm -f $(patchfile)

help:
	@cat make.help

.PHONY: default patch apply tidy clean help
