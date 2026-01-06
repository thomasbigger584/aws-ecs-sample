# AWS ECS Nginx Deployment on Spot Instances

This project provides a Terraform-based solution for deploying an Nginx service on Amazon Elastic Container Service (ECS) using EC2 Spot Instances. It is designed to be cost-effective and includes automated dynamic DNS updates via DuckDNS.

## Features

*   **Cost-Optimized Compute**: Utilizes `t3.micro` EC2 Spot Instances to minimize infrastructure costs.
*   **ECS Cluster**: Deploys a lightweight ECS cluster backed by EC2.
*   **Nginx Service**: Hosts a sample Nginx container serving a custom HTML page.
*   **Dynamic DNS**: Automatically updates a DuckDNS domain with the instance's public IP using user data scripts and cron jobs.
*   **Containerized Tooling**: Executes Terraform commands within a Docker container to ensure a consistent deployment environment.

## Prerequisites

*   [Docker](https://www.docker.com/) and Docker Compose.
*   An active [AWS Account](https://aws.amazon.com/) with programmatic access.
*   A [DuckDNS](https://www.duckdns.org/) account (domain and token).

## Configuration

Create a `.env` file in the project root with the following credentials and configuration:

```dotenv
# AWS Credentials
AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
AWS_DEFAULT_REGION=<your-aws-region>

# Terraform Variables
TF_VAR_duckdns_domain=<your-duckdns-subdomain>
TF_VAR_duckdns_token=<your-duckdns-token>
```

## Usage

This project leverages Docker Compose to encapsulate Terraform, eliminating the need for a local Terraform installation.

### Deploy Infrastructure

**Option 1: Plan and Apply (Recommended)**

1. Generate an execution plan to preview changes:

```bash
docker compose run --rm terraform-plan
```

2. Apply the generated plan:

```bash
docker compose run --rm terraform-apply-plan
```

**Option 2: Direct Apply (Development)**

Apply changes immediately without saving a plan file:

```bash
docker compose run --rm terraform-apply
```

### Accessing the Application

After the infrastructure is successfully deployed, the EC2 instance will automatically update your DuckDNS domain with its public IP address. You can access the Nginx HTML page by navigating to:

http://<your-duckdns-subdomain>.duckdns.org/

*Note: It may take a minute for the instance to start and the DNS record to update.*

### Destroy Infrastructure

Remove all provisioned resources to avoid incurring costs:

```bash
docker compose run --rm terraform-destroy
```

## State Management

### Reset Local State

To perform a clean initialization (useful for resolving state locking issues or refreshing providers), remove the local Terraform data:

```bash
sudo rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup
```