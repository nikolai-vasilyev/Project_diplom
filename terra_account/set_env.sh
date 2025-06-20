#!/bin/bash
export TF_VAR_token=$(yc iam create-token)
export TF_VAR_cloud_id=$(yc config get cloud-id)
export TF_VAR_folder_id=$(yc config get folder-id)
export TF_VAR_remoute_ssh_pub=$(cat ~/.ssh/id_ed25519.pub)