# configuration...
scp=scp
ssh=ssh -ax
xslt=xsltproc --stringparam file $2 $1 $2 > $3
include config.mk

# internal variables...
css_sources=$(wildcard *.css)
css_targets=$(foreach x,$(css_sources),www/$(x))
html_sources=$(shell grep -il \<html $(wildcard html/*.html))
xhtml_files=$(patsubst html/%.html,xhtml/%.xhtml,$(html_sources))
html_targets=$(patsubst xhtml/%.xhtml,www/%.html,$(xhtml_files))
image_sources=$(wildcard html/*.jpg)
image_targets=$(patsubst html/%,www/%,$(image_sources))
targets=$(css_targets) $(html_targets) $(image_targets)

#targets...
all: $(targets)

test: $(targets)
	open www/$(index)

www/%.css: %.css csspp.pl
	@mkdir -p www
	perl csspp.pl $< > $@

xhtml/%.xhtml: html/%.html tidy.config
	@mkdir -p xhtml
	tidy -config tidy.config $< > $@ || true

www/%.html: xhtml/%.xhtml template.xsl navbar.html
	@mkdir -p www
	$(call xslt,template.xsl,$<,$@)

www/%.jpg: html/%.jpg
	cp -f $< $@

tarball: $(tarball)

$(tarball): $(targets)
	tar cvf - $(targets) | bzip2 --best > $@

.last_upload: $(tarball)
	$(scp) $< $(upload_host):
	@date > $@

upload: .last_upload

publish: upload
	@$(ssh) $(upload_host) '\
	echo Untarring web site files... && \
	rm -rf www && \
	tar jxvf $(tarball) && \
	chmod -R u=rwX,go=rX www && \
	ln -s $(index) www/index.html && \
	echo Moving web site files to $(publish_dir)... && \
	rm -rf old && \
	mkdir -p $(publish_dir) && \
	mv $(publish_dir) old && \
	mv www $(publish_dir) && \
	echo Web site published.'

publish-test:
	$(MAKE) -e publish publish_dir=$(publish_dir)/test

tidy:
	rm -f *~

clean: tidy
	rm -rf www xhtml $(tarball) .last_upload

help:
	@cat make.help

.PHONY: all test tarball upload publish patch apply tidy clean

.PRECIOUS: xhtml/*.xhtml $(tarball) .last_upload
