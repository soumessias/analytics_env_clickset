# ClickHouse + Superset Analytics Env

## Architecture Overview

This environment consists of four main services, each running in its own Docker container and working together to provide a complete analytics stack:

- **Apache Superset**:  
  - Modern open-source business intelligence (BI) platform for data exploration and visualization.
  - Provides a rich web UI for running SQL queries, creating charts, and building interactive dashboards.

- **ClickHouse**:  
  - High-performance, open-source columnar database management system.
  - Serves as the main data warehouse for analytics workloads, optimized for fast analytical queries on large datasets.
  - Can be used with local data or connected to external/production ClickHouse or ClickHouse Cloud instances.

- **PostgreSQL**:  
  - Reliable, open-source relational database.
  - Used exclusively by Superset to store all metadata, including user accounts, dashboard definitions, chart configurations, and access control information.

- **Redis**:  
  - In-memory data structure store, used as a cache and message broker.
  - Handles caching of query results and supports Superset’s asynchronous background tasks (such as dashboard refreshes and long-running queries).

All services are orchestrated via Docker Compose, making it easy to spin up a fully integrated analytics environment for development, testing, or production use. Configuration (such as credentials and connection URIs) is managed via environment variables, which can be customized in a `.env` file.

**Data Flow Example:**
1. A user logs into Superset and creates a dashboard.
2. Superset stores dashboard metadata in PostgreSQL.
3. When the user runs a query or loads a dashboard, Superset connects to ClickHouse to fetch analytics data.
4. Query results may be cached in Redis for faster subsequent access.
5. All services communicate over a Docker network, with ports exposed for local access.

## How it Works

- By default, all services run locally using Docker Compose with sensible defaults for development and testing.
- All credentials and connection details are managed via environment variables, which can be overridden by a `.env` file.
- You can connect Superset to a local or remote (e.g., ClickHouse Cloud) ClickHouse instance by editing the `.env` file.

## Quick Start

1. **Clone this repository**

2. **(Optional) Create a `.env` file**
   ```
   CLICKHOUSE_SQLALCHEMY_URI=clickhouse+http://<user>:<password>@<host>:<port>/
   SUPERSET_SECRET_KEY=your-very-secret-key
   SUPERSET_ENV=production
   # ...other variables...
   ```
   - If you don't provide a `.env`, the stack will run with all-local defaults.

3. **Build and start the environment**
   ```sh
   docker compose up --build
   ```

4. **Access Superset**
   - Open [http://localhost:8088](http://localhost:8088)
   - Default admin user: `admin` / `admin` (change in `.env` for production!)

5. **Connect to ClickHouse**
   - The ClickHouse connection is automatically registered in Superset using the URI from your `.env` or the default local ClickHouse.
   - By default the rights are limited, you may need to edit in the Database Details, to allow for example, DDL commands.

## Customization

- **Production ClickHouse**: Set `CLICKHOUSE_SQLALCHEMY_URI` in your `.env` to point to your production ClickHouse or ClickHouse Cloud instance.
- **Superset Environment**: Set `SUPERSET_ENV=production` in `.env` for production settings.
- **Secrets**: Always set a strong `SUPERSET_SECRET_KEY` and change all default passwords for production.

## License

MIT License

Copyright (c) 2025