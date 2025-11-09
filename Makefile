.PHONY: help install test build run clean deploy k8s-deploy terraform-init terraform-plan terraform-apply

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Development
install: ## Install dependencies
	python -m venv .venv
	.venv/Scripts/pip install -r requirements.txt

test: ## Run tests with coverage
	.venv/Scripts/python -m pytest tests/ -v --cov=. --cov-report=html --cov-report=term-missing

run: ## Run the application locally
	.venv/Scripts/python main.py

# Docker
build: ## Build Docker image
	docker build -t blackjack-app:latest .

docker-run: ## Run application in Docker container
	docker run -p 8000:8000 blackjack-app:latest

docker-compose-up: ## Start application with docker-compose
	docker-compose up --build

docker-compose-down: ## Stop docker-compose services
	docker-compose down

# Kubernetes
k8s-deploy: ## Deploy to Kubernetes
	./scripts/deploy.sh

k8s-clean: ## Clean Kubernetes deployment
	kubectl delete namespace blackjack --ignore-not-found=true

# Terraform
terraform-init: ## Initialize Terraform
	cd terraform && terraform init

terraform-plan: ## Plan Terraform changes
	cd terraform && terraform plan

terraform-apply: ## Apply Terraform configuration
	cd terraform && terraform apply

terraform-destroy: ## Destroy Terraform resources
	cd terraform && terraform destroy

# Cleanup
clean: ## Clean up generated files
	rm -rf .pytest_cache/
	rm -rf htmlcov/
	rm -rf .coverage
	rm -rf __pycache__/
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete

# CI/CD
lint: ## Run linting
	.venv/Scripts/python -m bandit -r . -f json -o bandit-report.json || true
	.venv/Scripts/python -m safety check --json --output safety-report.json || true

# All-in-one commands
dev-setup: install ## Complete development setup
	@echo "Development environment ready!"

full-test: clean test lint ## Run complete test suite

deploy-local: build docker-run ## Build and run locally with Docker

deploy-k8s: build k8s-deploy ## Build and deploy to Kubernetes