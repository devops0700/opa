# opa
1) Clone the git repository 
git clone git@github.com:devops0700/opa.git

2) OPA repository contains following files

variables.tf
provider.tf
vpc.tf
opa.sh
secret.tfvars
subnet.rego

3) Download opa v0.23.2

https://github.com/open-policy-agent/opa/releases

4) Download terraform and Install it by following below link

https://learn.hashicorp.com/tutorials/terraform/install-cli

5) Update following variables value in secret.tfvars

aws_access_key_id = "*****************"
aws_secret_access_key = "****************"

6) Initalize working directory

terraform init

7) Generate terraform plan and output in plan.binary

terraform plan -var-file="secret.tfvars" --out tfplan.binary

8) Convert the Terraform plan into JSON

terraform show -json tfplan.binary > tfplan.json

9) Execute the opa.sh 

<dir_path>/opa.sh

Note: It should result in following error message

************************************************
ERROR:Allowed resource creation policy violated
INFO:You are not allowed to create requested resources!
************************************************

Notes:

You can also test the policy in Rego Playground

https://play.openpolicyagent.org/

Use this link to beautify the json file

https://codebeautify.org

#Evaluate the OPA policy on the Terraform plan
opa eval --format pretty --explain=notes --data subnet.rego --input tfplan.json "data.terraform.analysis.score"
opa eval --format pretty --explain=notes --data subnet.rego --input tfplan.json "data.terraform.analysis.authz"
