FROM kunstmaan/explorer-multichain

ENV CHAINNAME        MainChain
ENV RPC_USER         multichainrpc
ENV RPC_PASSWORD     multichain123
ENV PARAM_BLOCKTIME  target-block-time|40
ENV PARAM_CONNECT    anyone-can-connect|false

EXPOSE 8000
EXPOSE 9000
EXPOSE 7000

COPY runchain.sh /root/runchain.sh
CMD ["/bin/bash", "/root/runchain.sh"]
