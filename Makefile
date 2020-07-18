serve:
	cd out && python -m SimpleHTTPServer

deploy:
	rsync --progress -rltz ./out/ tycho.ws:/var/www/html/vhosts/tycho.ws

# historical information:
# out: haggis.conf src templates/*.html
# 	haggis --input . --output out
