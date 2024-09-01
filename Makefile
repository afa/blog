all: lint test
lint: rubocop reek
test: rspec

Gemfile.lock: Gemfile
	bundle install
bundle: Gemfile.lock
rubocop: Gemfile.lock
	bundle exec rubocop --force-exclusion $(LINT_PATH)
reek: Gemfile.lock
	bundle exec reek --force-exclusion $(LINT_PATH)
rspec: Gemfile.lock
	DATABASE_URL=postgres:///blog_test bundle exec rspec -r./boot $(TEST_PATH)
# run:
# 	thor gen25
# badfiles:
# 	find data/temp -size 0 |wc -l
migrate:
	bundle exec sequel -m db/migrate postgres:///blog_devel
	bundle exec sequel -m db/migrate postgres:///blog_test
pg:
	psql postgres:///blog_devel
pg-test:
	psql postgres:///blog_test
databse:
	bundle exec sequel postgres:///blog_devel
server: Gemfile.lock
	bundle exec rackup
sh: Gemfile.lock
	bundle exec racksh
