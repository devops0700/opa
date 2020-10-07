# AWSConfig
1) Refresh your local git repository or clone the complete
git pull 
or
git clone git@github.com:devops0700/opa.git

2) Navigate to RDS directory

3) RDS directory contains following files

README.md
aws_config.ya
datasource.tf
provider.tf
rds.tf
rds_vpc.tf
secret.tfvars
variables.tf


4) Update following variables value in secret.tfvars

aws_access_key_id = "*****************"
aws_secret_access_key = "****************"

5) Initalize working directory

terraform init

6) Deploy the RDS instance

terraform apply -var-file="secret.tfvars"

Note: wait for it to complete.

7) Login to AWS and deply the AWSConfig using cloudformation using "aws_config.yaml"

In the parameters input, leave the value as default for "DeliveryChannelExists" parameter. however for "mailrecipeints" please provide an email id to subscribe to SNS topic to receive notification email. Please note that you will receive an email for SNS topic subscription, please confirm.

Note: After successful completion, it will configure AWS Config rule to check "RDS_INSTANCE_DELETION_PROTECTION_ENABLED"
it will also setup Delivery channel, Config recorder, S3 bucket to write the snapshot and AWS config event log, setup SNS and create SNS topic
and subcribe your provided email id.

8) You may have to wait for AWS config evaluation to detect the rule "RDS_INSTANCE_DELETION_PROTECTION_ENABLED" or you could navigate to AWS config page, go to "Rule" and select your rule and manually evaluate the rule to trigger the evaluation. After successful eveluation, you should receive a notification for your RDS instance to be non-compliant.

9) Delete your AWS config stack that you created. It will fail while deleteing the S3 bucket, please go ahead and manually delete it and then execute the "delete" stack again.

10) Once done, go ahead and destroy your setup to delete RDS database

terraform destroy -var-file="secret.tfvars"





