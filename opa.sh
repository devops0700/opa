#!/bin/bash

#curdir=`pwd`
script="$0"
#basename="$(dirname $script)"
curdir="$(dirname $script)"
 
#echo "Script name $script resides in $basename directory."
#echo $basename

# Initiate terraform init
cd $curdir
terraform init

# Create terraform plan
terraform plan -var-file="secret.tfvars" --out $curdir/tfplan_vpc.binary

if [ $? -ne 0 ]
then
  echo "ERROR:Command failed with errors."
  exit;
fi

# Convert terraform plan into JSON
terraform show -json $curdir/tfplan_vpc.binary > $curdir/tfplan_vpc.json

if [ $? -ne 0 ]
then
  echo "ERROR:Command failed with errors."
  exit;
fi

# Evaluate the OPA policy on the Terraform Plan
$(opa eval --format pretty --data $curdir/subnet.rego --input $curdir/tfplan_vpc.json "data.terraform.analysis.authz")

if [ $? -eq 0 ]
then
  cd $curdir
  terraform apply -var-file="secret.tfvars" -auto-approve
else
  echo "************************************************"
  echo "ERROR:Allowed resource creation policy violated"
  echo "INFO:You are not allowed to create requested resources!"
  echo "************************************************"
  exit;
fi

if [ $? -eq 0 ]
then
  echo "SUCCESS:Resources successfully created"
else
  echo "ERROR:Failed to successfully create resources"
fi
