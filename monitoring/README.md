# Monitoring Configuration

This directory contains monitoring and observability configuration for the Blackjack DevOps application.

## Components

### 1. Prometheus Configuration (`prometheus-config.yml`)
- Metrics collection from Kubernetes pods
- Scrape interval: 15 seconds
- Monitors blackjack-app pods and Kubernetes metrics

### 2. Grafana Dashboard (`grafana-dashboard.json`)
Pre-configured dashboard displaying:
- **CPU Usage**: Real-time CPU utilization per pod
- **Memory Usage**: Memory consumption with thresholds
- **HTTP Request Rate**: Requests per second
- **Running Pods**: Number of active application pods
- **Response Time**: p95 and p99 latency metrics

### 3. Docker Compose Monitoring Stack (`docker-compose-monitoring.yml`)
Complete monitoring setup with:
- Prometheus (port 9090)
- Grafana (port 3000)
- Blackjack application

## Quick Start

### Local Development with Docker Compose

```bash
cd monitoring
docker-compose -f docker-compose-monitoring.yml up -d
```

Access:
- **Application**: http://localhost:8000
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)

### Kubernetes Deployment

1. **Deploy Prometheus**:
```bash
kubectl create configmap prometheus-config --from-file=prometheus-config.yml
kubectl apply -f k8s-monitoring/prometheus-deployment.yaml
```

2. **Deploy Grafana**:
```bash
kubectl create configmap grafana-dashboard --from-file=grafana-dashboard.json
kubectl apply -f k8s-monitoring/grafana-deployment.yaml
```

## Dashboard Metrics

### Key Performance Indicators
- **CPU Usage**: Should stay below 70% (yellow threshold), 90% (red threshold)
- **Memory Usage**: Should stay below 70% (yellow), 85% (red)
- **Response Time**: p95 should be < 200ms, p99 < 500ms
- **Request Rate**: Tracks traffic patterns
- **Pod Health**: Number of running pods (should match replica count)

## Alerts Configuration

Prometheus alerting rules can be added for:
- High CPU/Memory usage
- Elevated error rates
- Pod failures
- Slow response times

## Integration with Azure

When deployed to AKS:
- Metrics are forwarded to Azure Application Insights
- Logs sent to Azure Log Analytics
- Native Azure Monitor integration available

## Customization

Edit `grafana-dashboard.json` to:
- Add custom panels
- Modify thresholds
- Add business metrics (games played, bets placed, etc.)
- Create custom alerts

## Troubleshooting

1. **No metrics appearing**: Check Prometheus targets at http://localhost:9090/targets
2. **Dashboard not loading**: Verify Grafana datasource is configured to Prometheus
3. **Missing data**: Ensure application pods have proper labels for service discovery
