#!/bin/bash
# Apply terraform changes to the product resources in the subscription

set -e

echo '===== TERRAFORM APPLY SCRIPT ====='

if [ -z "${SYSTEM_DEFAULTWORKINGDIRECTORY}" ] ; then
    echo "Error: Azure SYSTEM_DEFAULTWORKINGDIRECTORY environment variable was not defined."
    exit 1
fi

source ${SYSTEM_DEFAULTWORKINGDIRECTORY}/scripts/functions.sh
exit_if_not_set SUBSCRIPTION_NAME
export_env ${SYSTEM_DEFAULTWORKINGDIRECTORY}/env/${SUBSCRIPTION_NAME}/values.env
set_header_variables
check_apply_variables_exists
terraform apply -lock=false --auto-approve

