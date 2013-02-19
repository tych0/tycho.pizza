HAGGIS=~/packages/haggis/dist/build/haggis/haggis

serve: out
	cd out && python -m SimpleHTTPServer

deploy: out
	rsync --progress -rltz ./out/ tycho.ws:/home/tychoa/beta.tycho.ws/

out: $(HAGGIS) templates/*.html
	$(HAGGIS) --input . --output out

clean:
	@rm -rf out
