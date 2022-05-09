#!/bin/bash
# Init terraform session to the product resources in the subscription
set -e
echo "===== TERRAFORM INIT SCRIPT ====="
if [ -z "${SYSTEM_DEFAULTWORKINGDIRECTORY}" ]; then
    echo "Error: Azure SYSTEM_DEFAULTWORKINGDIRECTORY environment variable was not defined."
    exit 1
fi

source ${SYSTEM_DEFAULTWORKINGDIRECTORY}/scripts/functions.sh
export_env ${SYSTEM_DEFAULTWORKINGDIRECTORY}/env/${SUBSCRIPTION_NAME}/values.env
exit_if_not_set SUBSCRIPTION_NAME
export TF_VAR_state_file=${TF_VAR_tf_state_file}-${SUBSCRIPTION_NAME}

echo "------------------------ Environment Variables Start -----------------------"
env
echo "------------------------ Environment Variables End -----------------------"
echo ${business_unit}
create_storage_account_container
set_header_variables
check_init_variables_exists
terraform_init