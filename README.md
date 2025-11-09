# Blackjack DevOps Project

A Blackjack game built with FastAPI, demonstrating DevOps practices including containerization, orchestration, CI/CD, and infrastructure as code.

## Project Overview

This project implements a web-based Blackjack game with a complete DevOps pipeline:
- Docker containerization
- Kubernetes deployment configurations
- CI/CD with GitHub Actions
- Infrastructure as Code using Terraform
- Automated testing
- Cloud deployment ready (Azure)

## Features

### Game Features
- Place bets and play Blackjack
- Dealer AI that follows standard rules
- Ace value handling (1 or 11)
- Simple web interface

### DevOps Implementation
- **Docker**: Containerized application with multi-stage builds
- **Kubernetes**: Deployment manifests with autoscaling
- **CI/CD**: GitHub Actions for automated testing and deployment
- **IaC**: Terraform configurations for Azure infrastructure
- **Testing**: Unit tests with pytest and coverage reporting

## 📁 Project Structure

```
├── main.py                 # FastAPI application
├── requirements.txt        # Python dependencies
├── Dockerfile             # Container definition
├── docker-compose.yml     # Local development environment
├── static/                # Frontend assets
│   ├── css/
│   └── js/
├── templates/             # HTML templates
├── tests/                 # Test suite
├── .github/workflows/     # CI/CD pipeline
├── k8s/                   # Kubernetes manifests
├── terraform/             # Infrastructure as Code
└── scripts/               # Deployment automation
```

## Quick Start

### Run Locally
```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python main.py
```
Access at: http://localhost:8000

### Run with Docker
```bash
docker-compose up --build
```
Access at: http://localhost:80

## Testing

```bash
# Run tests
pytest tests/ -v

# Run with coverage
pytest tests/ --cov=. --cov-report=html
```

## Deployment

### Kubernetes
```bash
kubectl apply -f k8s/
```

### Infrastructure (Terraform)
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Project Structure
```
├── main.py              # FastAPI application
├── requirements.txt     # Python dependencies
├── Dockerfile          # Container configuration
├── docker-compose.yml  # Local dev environment
├── tests/              # Test suite
├── k8s/                # Kubernetes manifests
├── terraform/          # Infrastructure as Code
└── .github/workflows/  # CI/CD pipeline
```

## Tech Stack
- **Backend**: Python, FastAPI
- **Frontend**: HTML, CSS, JavaScript
- **DevOps**: Docker, Kubernetes, GitHub Actions, Terraform
- **Cloud**: Azure (AKS, ACR)
- **Testing**: pytest

---
**DevOps Assignment - 3rd Year Computer Science**