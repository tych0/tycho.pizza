# You will probably just use HAGGIS=haggis, if ~/.cabal/bin is in your path;
# this is handy when you're hacking on haggis itself, though.
HAGGIS=~/packages/haggis/dist/build/haggis/haggis

serve: out
	cd out && python -m SimpleHTTPServer

deploy: out
	rsync --progress -rltz ./out/ tycho.ws:/home/tychoa/beta.tycho.ws/

out: $(HAGGIS) templates/*.html
	$(HAGGIS) --input . --output out

clean:
	@rm -rf out
