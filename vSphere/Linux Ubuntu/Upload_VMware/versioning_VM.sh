#!/bin/sh

#Update variabili di ambiente
export VC_TEMPLATE_PACKER=win2019_template_packer
export VC_TEMPLATE_NAME=win2019_template
export VC_VM_TEMPLATE_PATH=/IT-DC/vm/Templates/win2019_template
export VC_VM_TEMPLATE_PACKER_PATH=/IT-DC/vm/Templates/win2019_template_packer
export VC_VM_TEMPLATE_MOVE_FOLDER=/IT-DC/vm/Templates/Versioning_Template
export DATASTORE_TARGET=/IT-DC/datastore/CELL02_DATASTORE01
export VC_VM_NAME="${VC_TEMPLATE_NAME}_$(date +%d%m%Y_%H%M)"
export VC_VM_EPHEMERAL=EPHEMERAL_TEMPLATE_VM_win2019
export VC_CLUSTER_NAME=CLUSTER01
export VM_VERSIONED="$VC_VM_TEMPLATE_MOVE_FOLDER"/"$VC_VM_NAME"
export CL_DEPLOY_TEMPLATE=Gitlab_Template

#Creazione clone template per versioning
govc vm.clone -on=False -vm $VC_VM_TEMPLATE_PACKER_PATH -folder="$VC_VM_TEMPLATE_MOVE_FOLDER" -ds=$DATASTORE_TARGET $VC_VM_NAME
govc vm.markastemplate $VC_VM_NAME

#Esportazione variabile per artefatto
echo "VC_TEMPLATE_NAME="$VC_TEMPLATE_NAME >> variables.txt
echo "VC_VM_TEMPLATE_PATH="$VC_VM_TEMPLATE_PATH >> variables.txt
echo "VC_VM_TEMPLATE_MOVE_FOLDER="$VC_VM_TEMPLATE_MOVE_FOLDER >> variables.txt
echo "DATASTORE_TARGET="$DATASTORE_TARGET >> variables.txt
echo "VC_VM_NAME="$VC_VM_NAME >> variables.txt
echo "VC_VM_EPHEMERAL="$VC_VM_EPHEMERAL >> variables.txt
echo "VC_CLUSTER_NAME="$VC_CLUSTER_NAME >> variables.txt
echo "VM_VERSIONED="$VM_VERSIONED >> variables.txt
echo "CL_DEPLOY_TEMPLATE="$CL_DEPLOY_TEMPLATE >> variables.txt
