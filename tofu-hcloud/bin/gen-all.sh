#/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INVENTORY_DIR=$SCRIPT_DIR/../../ansible/inventory/hcloud

# create inventory folder
mkdir -p $INVENTORY_DIR/group_vars

# generate hosts file
echo "generate hosts file"
$SCRIPT_DIR/gen-hosts.py >$INVENTORY_DIR/hosts.ini

# copy group_vars
if [ ! -f $INVENTORY_DIR/group_vars/all.yml ]
then
    echo "generate groups vars file."
    sed "s/very_secret_token__replace_me/`uuid`/" "$SCRIPT_DIR/../../inventory/sample/group_vars/all.yml" >$INVENTORY_DIR/group_vars/all.yml
fi
echo "done"