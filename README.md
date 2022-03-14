# zkSync local development setup

This repository contains the tooling necessary to bootstrap zkSync locally.

## Dependencies

To run zkSync locally, you must have `docker-compose` and `Docker` installed on your machine. 

## Usage

To bootstrap zkSync locally, run the `start.sh` script:

```
> ./start.sh
```

This command will bootstrap three docker containers:
- Postgres (used as the database for zkSync).
- Local Geth node (used as L1 for zkSync).
- zkSync server itself.

By default, the HTTP JSON-RPC API will run on port `3050`, while WS API will run on port `3051`. 

*Note, that it is important that the first start script goes uninterrupted. If you face any issues after the bootstrapping process unexpectedly stopped, you should [reset](#resetting-zksync-state) the local zkSync state and try again.* 

## Resetting zkSync state

To reset the zkSync state, run the `./clear.sh` script:

```
> ./clear.sh
```

Note, that you may receive a "permission denied" error when running this command. In this case, you should run it with the root privileges:

```
> sudo ./clear.sh
```

## Rich wallets

Local zkSync setup comes with some "rich" wallets with large amounts of ETH on both L1 and L2.

The full list of the addresses of these accounts with the corresponding private keys can be found [here](./rich-wallets.json).

Also, during the initial bootstrapping of the system, several ERC-20 contracts are deployed locally. Note, that large quantities of these ERC-20 belong to the wallet `0x36615Cf349d7F6344891B1e7CA7C72883F5dc049` (the first one in the list of the rich wallet). Right after bootstrapping the system, these ERC-20 funds are available only on L1.

## Using custom database/L1

To use custom Postgres database or Layer 1, you should change the `environment` parameters in the docker-compose file:

```yml
environment:
    - DATABASE_URL=postgres://postgres@postgres/zksync_local
    - ETH_CLIENT_WEB3_URL=http://geth:8545
```

- `DATABASE_URL` is the URL to the Postgres database.
- `ETH_CLIENT_WEB3_URL` is the URL to the HTTP JSON-RPC interface of the L1 node.

## Local testing example

You can an example of hardhat project that utilizes local testing capabilities [here](https://github.com/matter-labs/tutorial-examples/tree/main/local-setup-testing).

To run tests, clone the repo and run `yarn test`:

```
git clone https://github.com/matter-labs/tutorial-examples.git
cd local-setup-testing
yarn test
```
