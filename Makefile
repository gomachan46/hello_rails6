include help.mk

init:
	make build
	make _wakeup
	make db/drop
	make db/create
	make db/migrate

## docker build
build:
	docker-compose build

## bundle installやdb:migrate等諸々のアップデートを行って最新状態にしつつdocker立ち上げ
up:
	make app/install
	make db/migrate
	docker-compose up

## シンプルにdocker立ち上げ。早いが分かってる人向け
up/docker:
	docker-compose up

## docker落とす
down:
	docker-compose down

# docker-compose run空打ちしてDB等を立ち上げるワークアラウンド
_wakeup:
	docker-compose run --rm web date

## bundlerを用いてgem install
app/install:
	docker-compose run --rm web bundle install

server:
	rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b 0.0.0.0

.PHONY: db/*

## DB作成
db/create:
	docker-compose run --rm web bundle exec rails db:create

## DB削除
db/drop:
	docker-compose run --rm web bundle exec rails db:drop

## migration状況を最新にする
db/migrate:
	docker-compose run --rm web bundle exec rails db:migrate

.PHONY: test

## PARALLEL_TESTS_CONCURRENCY: 並列数, TEST_FILES: テスト対象
test:
	docker-compose run --rm web echo 'test'

## webコンテナのshを起動
ssh:
	docker-compose run --rm web ash

## webコンテナ上でrails consoleを起動
rails/console:
	docker-compose run --rm web bundle exec rails c
