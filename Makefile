HAGGIS=~/packages/haggis/dist/build/haggis/haggis

serve: out
	cd out && python -m SimpleHTTPServer

out: $(HAGGIS) templates/*.html
	$(HAGGIS) --input . --output out --config foo

clean:
	@rm -rf out
