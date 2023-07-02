install:
	bundle install

test:
	bin/rspec

start:
	bin/puma -C config/puma.rb

rabbit:
	docker run --rm --name rabbitmq -p 5672:5672 -p 15672:15672 --hostname node1 -v rabbitmq:/var/lib/rabbitmq rabbitmq:3-management

rab:
	docker-compose up -d

.PHONY:	test
