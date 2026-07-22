# DevOps Metrics and KPIs

This document covers key metrics and KPIs for measuring DevOps effectiveness.

## DORA Metrics

The four key metrics from the DORA (DevOps Research and Assessment) research:

### 1. Deployment Frequency
How often code is deployed to production.

**Good**: Multiple deploys per day
**Elite**: On-demand, multiple deploys per day

**How to measure**:
```bash
# Count deployments in last 30 days
git log --oneline --since="30 days ago" | grep -i deploy | wc -l
```

### 2. Lead Time for Changes
Time from code commit to production deployment.

**Good**: Less than 1 day
**Elite**: Less than 1 hour

**How to measure**:
```bash
# Calculate average time between commit and deployment
git log --format="%H %aI" | head -20
```

### 3. Change Failure Rate
Percentage of deployments causing a failure in production.

**Good**: 0-15%
**Elite**: 0-15%

**How to measure**:
```
Change Failure Rate = (Failed Deployments / Total Deployments) × 100
```

### 4. Time to Restore Service
Time to restore service after a production failure.

**Good**: Less than 1 day
**Elite**: Less than 1 hour

**How to measure**:
- Track incident start time
- Track incident resolution time
- Calculate average restoration time

## Infrastructure Metrics

### Server Utilization
- **CPU Usage**: Target 60-80% average
- **Memory Usage**: Target 70-80% average
- **Disk I/O**: Monitor IOPS and throughput
- **Network I/O**: Monitor bandwidth utilization

### Resource Efficiency
- **Cost per Transaction**: Infrastructure cost / transactions
- **Resource Waste**: Unused or underutilized resources
- **Auto-scaling Effectiveness**: How well auto-scaling responds to load

## Application Performance Metrics

### Availability
- **Uptime**: Target 99.9% or higher
- **SLA Compliance**: Meeting service level agreements
- **Error Rate**: Percentage of failed requests

### Performance
- **Response Time**: Average time to serve requests
- **Latency**: P50, P95, P99 response times
- **Throughput**: Requests per second

### Reliability
- **MTBF**: Mean Time Between Failures
- **MTTR**: Mean Time To Recovery
- **Failure Frequency**: How often failures occur

## Process Metrics

### Code Quality
- **Code Coverage**: Percentage of code covered by tests
- **Technical Debt**: Time to fix code quality issues
- **Code Review Time**: Time to complete code reviews
- **Bug Escape Rate**: Bugs found in production vs development

### Build and Deployment
- **Build Success Rate**: Percentage of successful builds
- **Build Duration**: Time to complete builds
- **Deployment Success Rate**: Percentage of successful deployments
- **Rollback Rate**: Percentage of deployments requiring rollback

### Security
- **Vulnerability Density**: Vulnerabilities per thousand lines of code
- **Mean Time to Patch**: Time to apply security patches
- **Compliance Score**: Percentage of compliant systems
- **Security Incidents**: Number of security incidents

## Team Metrics

### Productivity
- **Story Points per Sprint**: Team velocity
- **Cycle Time**: Time from start to completion of work
- **Pull Request Size**: Average lines of code per PR
- **Review Turnaround**: Time to review pull requests

### Collaboration
- **Cross-team Contributions**: Code reviews across teams
- **Knowledge Sharing**: Documentation contributions
- **Meeting Efficiency**: Time spent in meetings vs productive work

## Customer Metrics

### User Experience
- **Page Load Time**: Frontend performance
- **API Response Time**: Backend performance
- **Error Rate**: User-facing errors
- **User Satisfaction**: NPS or satisfaction scores

### Business Impact
- **Revenue Impact**: Revenue affected by downtime
- **Customer Churn**: Customer loss due to issues
- **Feature Adoption**: Usage of new features
- **Time to Market**: Speed of delivering new features

## Monitoring Tools

### Infrastructure Monitoring
- **Prometheus**: Metrics collection and alerting
- **Grafana**: Visualization and dashboards
- **Datadog**: Full-stack monitoring
- **New Relic**: Application performance monitoring

### Log Management
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **Splunk**: Log analysis and monitoring
- **Fluentd**: Log collection and processing

### Alerting
```yaml
# Example Prometheus Alert
groups:
  - name: example
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: High error rate detected
```

## Dashboard Design

### Key Dashboard Elements
1. **Overview Panel**: High-level metrics
2. **Trend Charts**: Historical data
3. **Heatmaps**: Distribution patterns
4. **Alerts Panel**: Active incidents
5. **Comparison Views**: Before/after changes

### Dashboard Best Practices
- Keep dashboards focused and simple
- Use consistent color schemes
- Include context and thresholds
- Make dashboards actionable
- Regular review and updates

## Reporting

### Weekly Reports
- Deployment frequency and success rate
- Incident count and resolution time
- Performance trends
- Team productivity metrics

### Monthly Reports
- DORA metrics trends
- Infrastructure cost analysis
- Security posture review
- Customer impact analysis

## See Also

- [[devops-guide]]
- [[devops-practices]]
- [[devops-tools]]
- [[devops-interview-questions]]
