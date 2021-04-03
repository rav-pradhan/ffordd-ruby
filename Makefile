test:
	bundle exec rspec --format documentation

format:
	bundle exec rbprettier --write '**/*.rb'