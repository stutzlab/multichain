#!/bin/bash

cat << "EOF"

  __  __       _ _   _      _           _       
 |  \/  |_   _| | |_(_) ___| |__   __ _(_)_ __  
 | |\/| | | | | | __| |/ __| '_ \ / _` | | '_ \ 
 | |  | | |_| | | |_| | (__| | | | (_| | | | | |
 |_|  |_|\__,_|_|\__|_|\___|_| |_|\__,_|_|_| |_|
                                            v1.0

EOF

RPC_ALLOW_IP=0.0.0.0/0
NETWORK_PORT=9000
RPC_PORT=8000
EXPLORER_PORT=7000

# Create the chain if it is not there yet
if [ ! -d /root/.multichain/$CHAINNAME ]; then
    echo "No chain not found. Creating chain $CHAINNAME..."
    multichain-util create $CHAINNAME

    # Set some required parameters in the params.dat
    sed -i "s/^default-network-port.*/default-network-port = $NETWORK_PORT/" /root/.multichain/$CHAINNAME/params.dat
    sed -i "s/^default-rpc-port.*/default-rpc-port = $RPC_PORT/" /root/.multichain/$CHAINNAME/params.dat
    sed -i "s/^chain-name.*/chain-name = $CHAINNAME/" /root/.multichain/$CHAINNAME/params.dat
    sed -i "s/^chain-description.*/chain-description = MultiChain $CHAINNAME/" /root/.multichain/$CHAINNAME/params.dat

    # Loop over all variables that start with PARAM_
    #   PARAM_BLOCKTIME='target-block-time|40';
    #   PARAM_CONNECT='anyone-can-connect|true';
    ( set -o posix ; set ) | sed -n '/^PARAM_/p' | while read PARAM; do
        IFS='=' read -ra KV <<< "$PARAM"
        IFS='|' read -ra KV <<< "${!KV[0]}"
        sed -i "s/^${KV[0]}.*/${KV[0]} = ${KV[1]}/" /root/.multichain/$CHAINNAME/params.dat
    done

    cat << EOF > /root/.multichain/$CHAINNAME/multichain.conf
    rpcuser=$RPC_USER
    rpcpassword=$RPC_PASSWORD
    rpcallowip=$RPC_ALLOW_IP
    rpcport=$RPC_PORT
EOF

    cp /root/.multichain/$CHAINNAME/multichain.conf /root/.multichain/multichain.conf

    echo "Preparing Multichain Explorer config..."

    cat << EOF > /root/.multichain/explorer.conf
    port $EXPLORER_PORT
    host 0.0.0.0
    datadir += [{
            "dirname": "/root/.multichain/$CHAINNAME",
            "loader": "default",
            "chain": "$CHAINNAME",
            "policy": "MultiChain"
            }]
    dbtype = sqlite3
    connect-args = /root/.multichain/explorer.sqlite
EOF

    echo "$CHAINNAME params.dat:"
    cat /root/.multichain/$CHAINNAME/params.dat

fi

# if [ ! -z "$BLOCKNOTIFY_SCRIPT" ]; then
#     echo "blocknotify=$BLOCKNOTIFY_SCRIPT %s" >> /root/.multichain/$CHAINNAME/multichain.conf
# fi

echo "Starting Multichain Explorer..."
python -m Mce.abe --config /root/.multichain/explorer.conf&

echo "Starting Multichain..."
set -x
multichaind $CHAINNAME $RUNTIME_PARAMS
