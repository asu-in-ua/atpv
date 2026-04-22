FROM nodered/node-red:4.1.1

RUN npm install --unsafe-perm \
    node-red-contrib-s7@3.1.0 \
    node-red-node-mysql@2.0.0 \
    node-red-contrib-modbus@5.42.0 \
    @flowfuse/node-red-dashboard@1.23.0 \
    node-red-contrib-postgresql

COPY nodered/public /usr/src/node-red/public