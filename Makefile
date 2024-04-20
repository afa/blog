all: lint test
lint: rubocop reek
test: rspec

Gemfile.lock:
	bundle install
rubocop: Gemfile.lock
	bundle exec rubocop
reek: Gemfile.lock
	bundle exec reek
rspec: Gemfile.lock
	bundle exec rspec
# run:
# 	thor gen25
# badfiles:
# 	find data/temp -size 0 |wc -l
migrate:
	bundle exec sequel -m db/migrate postgres:///blog_devel
databse:
	bundle exec sequel postgres:///blog_devel
server: Gemfile.lock
	bundle exec rackup
sh: Gemfile.lock
	bundle exec racksh
