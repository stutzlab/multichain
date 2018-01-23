# multichain-genesis
Multichain Docker container image for generating new chains. You can specify the new chain parameters by setting ENV properties during container instantiation.

## Usage
Download docker-compose.yml file from this repository and change ENV accordingly. After that, run 
```
docker-compose up
```

## Custom configuration

The following ENV attributes are supported:
 * CHAINNAME: MyChain
 * RPC_USER: multichainrpc
 * RPC_PASSWORD: multichain123

Additionally, use ENVs to define properties that will be searched and replaced in the default Multichain configuration file, for example,
```
PARAM_ANYONE_CAN_CONNECT: anyone-can-connect|false
```
This will change the attribute 'anyone-can-connect' from the multichain config to 'false'
