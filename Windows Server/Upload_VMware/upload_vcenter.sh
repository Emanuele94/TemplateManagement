#/bin/sh

#Clone su VM

#Upload in Content Library
govc vm.clone -on=False -vm $VM_VERSIONED -folder="$VC_VM_TEMPLATE_MOVE_FOLDER" -ds=$DATASTORE_TARGET $VC_VM_EPHEMERAL

#govc library.clone -vm="$VM_VERSIONED" -ds="$DATASTORE_TARGET" -cluster="$VC_CLUSTER_NAME" $CL_DEPLOY_TEMPLATE $VC_TEMPLATE_NAME

govc library.clone -vm $VC_VM_NAME -name $VC_TEMPLATE_NAME -library $VM_LIBRARY -description "Template for Windows Server 2019"
govc vm.destroy $VC_VM_EPHEMERAL
