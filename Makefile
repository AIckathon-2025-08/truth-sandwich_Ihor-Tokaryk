.PHONY: build run stop clean dev logs health

# Build the Docker image
build:
	docker build -t truth-sandwich .

# Run the application with docker-compose
run:
	docker-compose up -d

# Run in development mode
dev:
	docker-compose --profile dev up

# Stop the application
stop:
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# Check health
health:
	curl -f http://localhost:9292/ && echo "\n✅ Application is healthy"

# Clean up Docker resources
clean:
	docker-compose down --volumes --remove-orphans
	docker image rm truth-sandwich 2>/dev/null || true

# Build and run
deploy: build run

# Complete restart
restart: stop run

# Show status
status:
	docker-compose ps

# Reseed database with sample data
reseed:
	rake db:seed

# Reset and reseed database
reset-db:
	rake db:drop db:create db:migrate db:seed
