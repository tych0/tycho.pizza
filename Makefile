serve:
	cd out && python -m SimpleHTTPServer

deploy:
	rsync --progress -rltz ./out/ tycho.pizza:/var/www/html/vhosts/tycho.pizza

# historical information:
# out: haggis.conf src templates/*.html
# 	haggis --input . --output out
