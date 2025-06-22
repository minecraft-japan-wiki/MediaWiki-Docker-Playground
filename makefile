# Makefile

sync:
	@echo "インポート開始..."
	@docker exec -it MediaWiki php maintenance/importDump.php /var/www/html/$(XML_FILE)
	@echo "インポート完了"

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
