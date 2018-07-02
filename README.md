# Deploy Concourse-Lite on Azure

```
cp terraform.tfvars.sample terraform.tfvars
```

Configure your azure environment in `terraform.tfvars`.

> [`az-automation`](https://github.com/pivotal-cf/terraforming-azure#creating-an-automation-account) could be useful to create an automation account.

```
terraform init
terraform plan -out plan
terraform apply plan
```

```
./create-concourse.sh
```

```
cat <<EOF
url: https://$(cat terraform.tfstate | jq -r '.modules[0].outputs.external_ip.value')
username: admin
password: $(bosh int concourse-creds.yml --path /admin_password)
EOF
```
