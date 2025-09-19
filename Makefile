serve:
	cd out && python -m SimpleHTTPServer

deploy:
	rsync --progress -rltz ./out/ www:/var/www/html/vhosts/tycho.pizza
