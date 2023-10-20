# dienstplan: Terraform config for DigitalOcean provider

Deploy infrastructure for
[dienstplan](https://github.com/pilosus/dienstplan) using
[Terraform](https://developer.hashicorp.com/terraform) in
[DigitalOcean](https://www.digitalocean.com/) public cloud.

## Architecture Overview

1. DigitalOcean Managed Database (PostgreSQL)
2. DigitalOcean App (Docker container):
   - server (service)
   - job (DB migration)
   - [TODO] job (cron job)
3. Firewall Rule:
   - allow App <> Database only

## Usage

1. Clone the repo

2. Define input variables:

- Add them to the `terraform.tfvars` file as follows:

```
do_access_token = "YOUR-ACCESS-TOKEN"
another_variable = ...
```

- Alternatively, use `-var="var1=val1"-var="var2=val2" ...` when
  invoking `terraform plan` or `terraform apply`

2. Initialise

```
terraform init
```

3. Review the plan

```
terraform plan
```

4. Apply changes

```
terraform apply
```

5. Output results

Get outputs with:

```
terraform output
```

The most important one is an URL of deployed app printed under `app_live_url`.

Validate the app is deployed correctly:

```
curl -SsL "$( terraform output -json | jq --raw-output '.app_live_url.value' )/api/healthcheck" | jq
```
