# AWS ECS Spot Instance Test

This project demonstrates how to deploy an Nginx service on AWS ECS using EC2 Spot Instances. It utilizes Terraform for Infrastructure as Code (IaC) and includes automatic DuckDNS updates for the EC2 instance IP.

## Features

*   **AWS ECS Cluster**: Deploys a lightweight ECS cluster backed by EC2.
*   **Spot Instances**: Uses `t3.micro` Spot Instances to minimize costs.
*   **Nginx Service**: Runs a simple Nginx container serving a custom HTML page.
*   **DuckDNS Integration**: Automatically updates a DuckDNS domain with the Spot Instance's public IP via user data scripts and cron jobs.
*   **Dockerized Terraform**: Runs Terraform commands inside a Docker container for a consistent environment.

## Prerequisites

*   [Docker](https://www.docker.com/) and Docker Compose installed.
*   An [AWS Account](https://aws.amazon.com/) with appropriate permissions.
*   A [DuckDNS](https://www.duckdns.org/) account (domain and token).

## Configuration

Create a `.env` file in the root directory with the following variables:

```toml
# AWS Credentials
AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
AWS_DEFAULT_REGION=<your-aws-region>

# Terraform Variables
TF_VAR_duckdns_domain=<your-duckdns-subdomain>
TF_VAR_duckdns_token=<your-duckdns-token>
```

## Usage

This project uses Docker Compose to wrap Terraform commands, ensuring you don't need to install Terraform locally.

### Provision Infrastructure

To initialize and apply the Terraform configuration:

```bash
docker compose run --rm terraform-apply
```

### Destroy Infrastructure

To tear down all resources:

```bash
docker compose run --rm terraform-destroy
```

### Clean Local State

If you need to force a clean initialization (e.g., if you encounter state locking issues or want to re-download providers), you can remove the local Terraform data:

```bash
sudo rm -rf .terraform .terraform.lock.hcl terraform.tfstate
```
