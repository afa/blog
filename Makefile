all: lint test
lint: rubocop reek
test: rspec

Gemfile.lock: Gemfile
	bundle install
rubocop: Gemfile.lock
	bundle exec rubocop
reek: Gemfile.lock
	bundle exec reek
rspec: Gemfile.lock
	DATABASE_URL=postgres:///blog_test bundle exec rspec -r./boot
# run:
# 	thor gen25
# badfiles:
# 	find data/temp -size 0 |wc -l
migrate:
	bundle exec sequel -m db/migrate postgres:///blog_devel
	bundle exec sequel -m db/migrate postgres:///blog_test
databse:
	bundle exec sequel postgres:///blog_devel
server: Gemfile.lock
	bundle exec rackup
sh: Gemfile.lock
	bundle exec racksh
