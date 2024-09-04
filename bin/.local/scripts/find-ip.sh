AWS_PROFILES="20min_prod-admin 20min_dev-admin 20min_sandbox-admin unity_preprod-admin ness-admin unity_sandbox-admin unity_dev-admin unity_prod-admin unity_preprod-admin disco_sandbox-admin disco_dev-admin disco_prod-admin"
for profile in $AWS_PROFILES; do \
  echo "Checking AWS account to $profile"; \
  aws-vault exec $profile -- \
  aws ec2 describe-network-interfaces --region eu-central-1 --query 'NetworkInterfaces[].[NetworkInterfaceId,Association.PublicIp]' --output text  --no-cli-pager | grep -n  18.185.156.69
  aws-vault exec $profile -- \
  aws ec2 describe-network-interfaces --region eu-west-1 --query 'NetworkInterfaces[].[NetworkInterfaceId,Association.PublicIp]' --output text  --no-cli-pager | grep -n  18.185.156.69
done