APP_ENV := development
DB_NAME := challenge_be_safebox_api_rails_$(APP_ENV)
DB_USER := postgres
TEST_PATH := spec

db-connect:
	@docker compose exec db psql -U $(DB_USER) -d $(DB_NAME)

db-create:
	@docker compose exec app rails db:create

db-migrate:
	@docker compose exec app rails db:migrate RAILS_ENV=$(APP_ENV)

db-generate-migration:
	@docker compose exec app rails g migration $(NAME)

start:
	@docker compose up --build -d $(SERVICES)

stop:
	@docker compose stop

restart:
	make stop
	make start

destroy:
	@docker compose down

install:
	@docker compose exec app bundle install

console:
	@docker compose exec app rails console

test:
	@docker compose exec app rspec ${TEST_PATH}

lint:
	@docker compose exec app rubocop

logs:
	@docker compose logs $(SERVICE) -f

# Do not run from integrated terminal in VSCodium
# control + p, control + q for ending the debugging session
debug:
	@docker attach $$(docker compose ps -q app)
