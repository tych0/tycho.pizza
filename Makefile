HAGGIS=~/packages/haggis/dist/build/haggis/haggis

out: $(HAGGIS) templates/*.html
	$(HAGGIS) --input . --output out --config foo

clean:
	@rm -rf out
