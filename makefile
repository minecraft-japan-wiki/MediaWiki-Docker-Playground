# ダウンロードURLやファイル名
DUMP_URL=https://minecraftjapan.miraheze.org/wiki/特別:DataDump?action=download&dump=$(XML_GZ_FILE)
XML_GZ_FILE=$(XML_FILE).gz
XML_FILE=minecraftjapanwiki_xml_xxxxxxxxxxxxxxxxxxxxx.xml
CONTAINER=MediaWiki

sync:
	@echo "Wikipedia XMLダンプをダウンロード中..."
	@curl -L $(DUMP_URL) -o ./$(XML_GZ_FILE)

	@echo "コンテナにXMLダンプをコピー中..."
	@docker cp $(XML_GZ_FILE) $(CONTAINER):/var/www/html/

	@echo "解凍してXMLファイルに変換中..."
	@docker exec -i $(CONTAINER) sh -c "gzip -dc /var/www/html/$(XML_GZ_FILE) > /var/www/html/$(XML_FILE)"

	@echo "MediaWikiにインポート中..."
	@docker exec -i $(CONTAINER) php maintenance/importDump.php /var/www/html/$(XML_FILE)

	@echo "インポート完了！"

up:
	@echo ">>> Dockerコンテナを起動します..."
	docker-compose up -d

down:
	@echo ">>> Dockerコンテナを停止します..."
	docker-compose down

reset-db:
	@echo ">>> データベースをリセットして再起動します..."
	docker-compose down -v
	docker-compose up -d
