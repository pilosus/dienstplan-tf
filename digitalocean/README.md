# Deploy dienstplan to DigitalOcean with Terraform

## Architecture Overview

1. DigitalOcean Database (PostgreSQL)
2. DigitalOcean App (Docker container)

## Plan & Apply

1. Initialize

```
terraform init
```

2. Provide input variables

There are two options to provide input variables:

- Add them to `terraform.tfvars` files as follows:

```
do_access_token = "YOUR-ACCESS-TOKEN"
another_variable = ...
```

- Pass in a variable as a CLI option `-var`:

```
-var="do_access_token=YOUR-ACCESS-TOKEN"
```

3. Review the plan

```
terraform plan
# or with CLI arg
# terraform plan -var="do_access_token=YOUR-ACCESS-TOKEN"
```

4. Apply changes

```
terraform apply
# or with CLI arg
# terraform apply -var="do_access_token=YOUR-ACCESS-TOKEN"
```

5. Output results

```
terraform output
# machine readable format with sensitive data included
terraform output -json
```
