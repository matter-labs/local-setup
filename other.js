const e = [
    {
        apiUrl: "http://localhost:3052", bridgeUrl: "http://localhost:3000/bridge", hostnames: [
            "localhost"
        ], icon: "/images/icons/zksync-arrows.svg", l2ChainId: 270, l2NetworkName: "Localzz", maintenance: !1, name: "local", published: !0, rpcUrl: "http://localhost:3050"
    },
    {
        apiUrl: "http://localhost:3062", bridgeUrl: "http://localhost:3000/bridge", hostnames: [
            "localhost"
        ], icon: "/images/icons/zksync-arrows.svg", l2ChainId: 272, l2NetworkName: "Slave1", maintenance: !1, name: "local_slave1", published: !0, rpcUrl: "http://localhost:3060"
    },
    {
        apiUrl: "http://localhost:3072", bridgeUrl: "http://localhost:3000/bridge", hostnames: [
            "localhost"
        ], icon: "/images/icons/zksync-arrows.svg", l2ChainId: 273, l2NetworkName: "Slave2", maintenance: !1, name: "local_slave2", published: !0, rpcUrl: "http://localhost:3070"
    }

]; var s = {
    networks: e
}; export {
    s as default, e as networks
};