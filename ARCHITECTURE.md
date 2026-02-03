# Autonomous Analytics Platform - Architecture Overview

## Tech Stack

### Core Components

```
┌─────────────────────────────────────────────────────────────┐
│                     CLIENT BROWSER                          │
│                  (React/Next.js Frontend)                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   APPLICATION LAYER                         │
│              (Node.js/FastAPI Backend)                      │
│  • User Authentication                                      │
│  • API Endpoints                                            │
│  • Session Management                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
┌───────────────────────────┐   ┌──────────────────────────┐
│      SNOWFLAKE            │   │        n8n               │
│   (Data Warehouse)        │   │  (Workflow Automation)   │
│                           │   │                          │
│ • All analytical data     │   │ • Scheduled queries      │
│ • Client data isolation   │   │ • Report generation      │
│ • Query result caching    │   │ • Alert monitoring       │
│ • RBAC security          │   │ • Data quality checks    │
│ • Automatic scaling      │   │ • Email/Slack notif.     │
└───────────────────────────┘   └──────────────────────────┘
                │                           │
                └───────────┬───────────────┘
                            │
                            ▼
                  ┌──────────────────┐
                  │   PostgreSQL     │
                  │ (App Metadata)   │
                  │ • User accounts  │
                  │ • Configurations │
                  │ • Credentials    │
                  └──────────────────┘
```

## Data Flow

### 1. Client Onboarding
```
User → Frontend → Backend → Snowflake Connection Test → Store Credentials
```

### 2. Scheduled Data Processing
```
n8n Cron Trigger → Query Snowflake → AI Analysis → Store Insights → Notify Users
```

### 3. Dashboard Access
```
User Request → Backend → Snowflake Query → Cache Results → Render Charts → Display
```

### 4. Natural Language Query
```
User Question → AI (Text-to-SQL) → Validate SQL → Execute on Snowflake → Results
```

### 5. Report Generation
```
n8n Schedule → Query Snowflake → Generate PDF/PPTX → Store in S3 → Email User
```

## Key Architecture Decisions

### Why Snowflake?

✅ **Single Source of Truth**: All analytical data in one place
✅ **Automatic Scaling**: Handles varying workloads automatically
✅ **Built-in Caching**: Query result caching out of the box
✅ **Multi-Tenancy**: Easy data isolation via schemas/databases
✅ **Security**: End-to-end encryption, RBAC, audit logs
✅ **Performance**: Columnar storage, clustering, materialized views
✅ **Cost Tracking**: Monitor compute credits per client

### Why n8n?

✅ **Visual Workflows**: Easy to build and maintain automation
✅ **Snowflake Integration**: Native Snowflake node available
✅ **Flexible Scheduling**: Cron triggers for any frequency
✅ **Error Handling**: Built-in retry logic and error branches
✅ **Notifications**: Email, Slack, webhooks out of the box
✅ **Self-Hosted Option**: Can run on your infrastructure
✅ **Extensible**: Custom nodes and JavaScript code steps

## Component Responsibilities

### Frontend (React/Next.js)
- User interface for dashboards and reports
- Snowflake connection configuration
- Interactive charts and visualizations
- Natural language query interface
- User preferences and settings

### Backend (Node.js/FastAPI)
- Authentication and authorization
- API endpoints for frontend
- Snowflake query execution
- Text-to-SQL conversion (via Claude API)
- API rate limiting
- Response caching (Redis)

### Snowflake (Data Warehouse)
- **Primary storage** for all analytical data
- Query execution for dashboards
- Materialized views for performance
- Result caching
- User role management
- Data quality monitoring queries

### n8n (Workflow Engine)
- **Scheduled data refresh** workflows
- **Report generation** (PDF/PPTX creation)
- **Alert monitoring** (threshold checks)
- **Data quality checks** (run SQL validations)
- **Email/Slack notifications**
- **AI insight generation** workflows
- **Webhook triggers** for events

### PostgreSQL (Application DB)
- User accounts and profiles
- Snowflake connection credentials (encrypted)
- Dashboard configurations
- Saved queries and bookmarks
- Application settings
- n8n workflow metadata

### Redis (Cache Layer)
- API response caching
- Session storage
- Rate limiting counters
- Temporary query results

## Multi-Tenancy Strategy

### Option A: Schema-per-Tenant
```sql
-- Each client gets their own schema in shared database
CREATE SCHEMA client_acme;
CREATE SCHEMA client_globex;

-- Grant access via Snowflake roles
GRANT USAGE ON SCHEMA client_acme TO ROLE acme_role;
```

**Pros**: Easy management, shared compute resources
**Cons**: All in one database, potential noisy neighbor issues

### Option B: Database-per-Tenant
```sql
-- Each client gets their own database
CREATE DATABASE client_acme;
CREATE DATABASE client_globex;

-- Complete isolation
```

**Pros**: Complete isolation, easier billing tracking
**Cons**: More overhead, harder to manage many clients

**Recommendation**: Start with Schema-per-Tenant, migrate high-value clients to Database-per-Tenant

## Security Model

### Data Security
- **Snowflake credentials**: Encrypted in PostgreSQL using AES-256
- **Network security**: VPC/VPN connection to Snowflake
- **Row-level security**: Snowflake row access policies
- **Column masking**: Sensitive data masked per role

### Access Control
```
User Login → JWT Token → Backend validates → 
Snowflake Role Assignment → Execute Query with User Role
```

### Audit Logging
- All queries logged in Snowflake QUERY_HISTORY
- User actions logged in PostgreSQL
- n8n workflow executions tracked
- API calls logged with timestamps

## Performance Optimization

### Snowflake Layer
1. **Result Caching**: Automatic 24-hour cache
2. **Clustering Keys**: Optimize common filter patterns
3. **Materialized Views**: Pre-compute frequent aggregations
4. **Warehouse Sizing**: Right-size compute for workload

### Application Layer
1. **Redis Caching**: Cache API responses (5-60 min TTL)
2. **Query Optimization**: Review slow queries in Snowflake
3. **Lazy Loading**: Load charts on-demand
4. **Pagination**: Limit result sets to 1000 rows default

### n8n Workflows
1. **Incremental Processing**: Only process new/changed data
2. **Parallel Execution**: Run independent tasks concurrently
3. **Error Handling**: Graceful degradation on failures

## Cost Management

### Snowflake Credits
- Monitor per-tenant usage via WAREHOUSE_METERING_HISTORY
- Set up auto-suspend (1 min) for warehouses
- Use smaller warehouses for small queries
- Scale up only for heavy aggregations

### n8n Workflows
- Optimize workflow frequency (hourly vs. daily)
- Disable unused workflows
- Use workflow templates to avoid duplication

## Development Workflow with Ralph

Ralph will implement each component following this pattern:

1. **US-001**: Snowflake connection UI → Frontend + Backend
2. **US-002**: n8n setup → Workflow templates + Integration
3. **US-003**: AI insights → n8n workflow + Claude API
4. **US-004**: Visualizations → Frontend + Snowflake queries
5. **US-005**: Dashboards → Full-stack feature
6. **US-006**: Reports → n8n workflow + PDF/PPTX generation
7. **US-007**: Portal → Frontend + Backend + Snowflake RBAC
8. **US-008**: Alerts → n8n workflows
9. **US-009**: Text-to-SQL → Backend + Claude API
10. **US-010**: Data quality → n8n workflows
11. **US-011**: Predictions → ML models + Snowflake
12. **US-012**: Multi-tenancy → Snowflake schemas + RBAC
13. **US-013**: API → Backend endpoints
14. **US-014**: Onboarding → Frontend wizard
15. **US-015**: Performance → Optimization across stack

## Getting Started

### Prerequisites
1. **Snowflake Account**: Trial or paid account
2. **n8n Instance**: Self-hosted or n8n.cloud
3. **PostgreSQL**: For application metadata
4. **Redis**: For caching
5. **Claude API Key**: For AI features

### Initial Setup
1. Run Ralph to build the application
2. Configure Snowflake connection
3. Set up n8n workflows
4. Deploy frontend and backend
5. Test with sample data

## Monitoring & Observability

### What to Monitor
- Snowflake compute credits usage
- n8n workflow success/failure rates
- API response times
- Dashboard load times
- Cache hit rates
- Error logs

### Tools
- Snowflake: Built-in monitoring dashboards
- n8n: Workflow execution logs
- Application: Custom logging + monitoring service
- Alerts: Set up in n8n workflows

---

This architecture provides a scalable, cost-effective platform for autonomous analytics powered by Snowflake and n8n!
