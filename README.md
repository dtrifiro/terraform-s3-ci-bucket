# opendatahub-io/vllm sccache bucket

1. Create a bucket:

```bash

terraform plan
terraform apply # create a `.tfvars` with region/bucket name if you want to customize this
```

2. Get the secrets to get write access to the bucket
3. Follow the guide at https://docs.ci.openshift.org/docs/how-tos/adding-a-new-secret-to-ci/ to add the secret to CI
