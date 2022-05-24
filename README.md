# homework
Here you will find the code that creates an s3 bucket, the lambda importer and a redis node

```
This code will create the resources needed to store a file name in a redis node that was uploaded to an S3 bucket
```

Steps to deploy:

```
1. Manually create an aws user with administrator privileges, with programmatic access to configure the credentials in the aws cli
2. Configure the aws profile, in this case named "homework", including the access and secret keys created in step #1
3. Modify the vars.tfvars file and type the requested data
4. To deploy the infrastructure, go to /aws/terraform and type terraform init to initialize the backend, terraform plan to confirm changes and 
   terraform apply to create the infrastructure.
``` Note you can type terraform plan and terraform apply with flags --var-file vars.tfvars, eg. "terraform plan --var-file vars.tfvars
