#!/bin/bash
set -e
echo '===== LOAD COMMON FUNCTIONS ====='
exit_if_not_set() {
    if [ -z "${!1}" ] ; then
        echo "Warning: ${1} environment variable is not set."
        return 1;
    fi
    echo "${1} is set"
}

create_storage_account_container() {
    echo '===== CREATE STORAGE ACCOUNT CONTAINER ====='
    export AZURE_STORAGE_KEY=$( az storage account keys list --account-name "${TF_VAR_tfstate_storage_account}" --resource-group "${TF_VAR_tfstate_resource_group}" --output tsv --query [0].value )
    az storage container create --name "${TF_VAR_tfstate_storage_container}" \
                                --account-name "${TF_VAR_tfstate_storage_account}" \
                                --subscription "${SUBSCRIPTION_ID}"
    echo '====== CREATE DONE ======'
    az storage container set-permission --name "${TF_VAR_tfstate_storage_container}" \
                                --account-name "${TF_VAR_tfstate_storage_account}" \
                                --public-access off
}

set_header_variables() {
    if [ -z "${TF_VAR_subscription_shortname}" ] ; then
        export TF_VAR_subscription_shortname=${SUBSCRIPTION_NAME}
    fi
    export TF_VAR_subscription_name=${TF_VAR_subscription_shortname}
    export TF_VAR_subscription_id=${SUBSCRIPTION_ID}
    export TF_VAR_tenant_id=${tenantId}
    export TF_VAR_client_id=${servicePrincipalId}
    export TF_VAR_client_secret=${servicePrincipalKey}
    export TF_VAR_location_name=${TF_VAR_region_name_primary}
}

check_init_variables_exists() {
    exit_if_not_set TF_VAR_resource_group_name
    exit_if_not_set TF_VAR_tfstate_storage_account
    exit_if_not_set TF_VAR_tfstate_storage_container
    exit_if_not_set SUBSCRIPTION_ID
    exit_if_not_set servicePrincipalId
    exit_if_not_set servicePrincipalKey
    exit_if_not_set tenantId
}

check_apply_variables_exists() {
    exit_if_not_set TF_VAR_subscription_name
    exit_if_not_set TF_VAR_resource_group_name
    exit_if_not_set TF_VAR_client_secret
    exit_if_not_set TF_VAR_client_id
    exit_if_not_set TF_VAR_tenant_id
    exit_if_not_set TF_VAR_subscription_id
}

terraform_init() {
   terraform init -reconfigure -backend-config="storage_account_name=${TF_VAR_tfstate_storage_account}" \
   -backend-config="container_name=${TF_VAR_tfstate_storage_container}" \
   -backend-config="resource_group_name=${TF_VAR_tfstate_resource_group}" \
   -backend-config="subscription_id=${SUBSCRIPTION_ID}" \
   -backend-config="tenant_id=${tenantId}" \
   -backend-config="client_id=${servicePrincipalId}" \
   -backend-config="client_secret=${servicePrincipalKey}" \
   -backend-config="key=${TF_VAR_state_file}" \
   # -plugin-dir="/azp/terraform/plugins/linux_amd64" \
   # -verify-plugins=false
}

export_env() {
    if [ ! -z "${1}" ] && [ -e ${1} ] ; then
        while IFS='=' read -r envvar_key envvar_value
        do
            if [[ "${envvar_key}" == TF_VAR_* ]]; then
                export ${envvar_key}=${envvar_value}
                echo "${envvar_key} exported"
            fi
        done < <( cat ${1} )
        echo "${1} variables have been exported."
    else
        echo "Input file ${1} must be supplied to export variables."
        return 1;
    fi
}

