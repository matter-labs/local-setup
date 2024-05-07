const e = [
    {
        apiUrl: "http://localhost:15102", bridgeUrl: "http://localhost:3000/bridge", hostnames: [
            "localhost"
        ], icon: "/images/icons/zksync-arrows.svg", l2ChainId: 270, l2NetworkName: "Master", maintenance: !1, name: "local", published: !0, rpcUrl: "http://localhost:15100"
    },
    {
        apiUrl: "http://localhost:15202", bridgeUrl: "http://localhost:3000/bridge", hostnames: [
            "localhost"
        ], icon: "/images/icons/zksync-arrows.svg", l2ChainId: 272, l2NetworkName: "Slave", maintenance: !1, name: "local_slave1", published: !0, rpcUrl: "http://localhost:15200"
    },
    {
        apiUrl: "http://localhost:15302", bridgeUrl: "http://localhost:3000/bridge", hostnames: [
            "localhost"
        ], icon: "/images/icons/zksync-arrows.svg", l2ChainId: 273, l2NetworkName: "Slave2", maintenance: !1, name: "local_slave2", published: !0, rpcUrl: "http://localhost:15300"
    }

]; var s = {
    networks: e
}; export {
    s as default, e as networks
};