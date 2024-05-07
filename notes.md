CHAIN_ETH_ZKSYNC_NETWORK_ID=271
-- inside base/chain.toml

export MNEMONIC="misery lizard beach magic blue one genre damage excess police image become"

also remember to 're-init' the databse (with 'limited' entrypoint.sh)


Change the CONTRACTS_BRIDGEHUB_PROXY_ADDR=0x35A3783781DE026E1e854A6DA45d7a903664a9dA
inside vim /etc/env/target/dev.env (or better in /etc/env/l1-inits/.init.env)

zk f yarn register-hyperchain
from /contracts/l1-contracts

Wrong mnemonic derivation?? - 0x3641c494B824FCe82f067Ac2154028C5aa4dA61B
cast send -r http://localhost:8545 0x3641c494B824FCe82f067Ac2154028C5aa4dA61B  --value 100ether 0x --private-key 0x27593fea79697e947890ecbecce7901b0008345e5d7259710d0dd5e500d040be

Had to use the 'original' mnemonic (fine music test violin matrix prize squirrel panther purchase material script deal) - as the other one was not the owner..

All these below should be changed in contracts.toml (or probably those l1-inits/.init.env)

CONTRACTS_STATE_TRANSITION_PROXY_ADDR=0x358E8b343f5Fd58aC74B262c4492BdFB9CC94116

error: chainid already registered
change 
CHAIN_ETH_ZKSYNC_NETWORK_ID=271

STM: initial cutHash mismatch

I need:
admin, getter mailbox and executor facets.

CONTRACTS_ADMIN_FACET_ADDR=0xde1eE9622c8D6F7Da5bb7fB6dAa456f7cbF8a68d
CONTRACTS_MAILBOX_FACET_ADDR=0xfF33105a4BC25D8e2d152850d040286800E906e1
CONTRACTS_EXECUTOR_FACET_ADDR=0x72093667348cA8381aFA17BBBe97946cc26B9B63
CONTRACTS_GETTERS_FACET_ADDR=0x359fC3e2c4417C19f48089DB28a6a51c16e92822

and diamond init:
CONTRACTS_DIAMOND_INIT_ADDR=0x9fbFBa544B76F67Bf821E3468990B21bFaE45a10

CONTRACTS_BLOB_VERSIONED_HASH_RETRIEVER_ADDR=0x585dFAf7332B9a725b8A1957fc6eF544A732bAD9
CONTRACTS_VERIFIER_ADDR=0x4e49ee147EaD1e39951B9779eA11e16eA30b19C2

And this was the output:



Using deployer wallet: 0x52312AD6f01657413b2eaE9287f6B9ADaD93D5FE
Using governor address: 0x52312AD6f01657413b2eaE9287f6B9ADaD93D5FE
Using gas price: 1.500000001 gwei
Using nonce: 170
Using base token address: 0x0000000000000000000000000000000000000001
Hyperchain registered, gas used: 3193077 and 3193077
Hyperchain registration tx hash: 0x49afc2e91b38a9f3cd4b3098ff27f83962aa4ff1bf1222998f329a707c163c94

CHAIN_ETH_ZKSYNC_NETWORK_ID=271
CONTRACTS_BASE_TOKEN_ADDR=0x0000000000000000000000000000000000000001
CONTRACTS_DIAMOND_PROXY_ADDR=0x7a50c1212c74fac4c8dbffaf96a4ceab32737d50

Validator registered, gas used: 21584, tx hash: 0xc37c42d4da1f8e451c20f79dd6aaadebbf969269f81f02254b19e51cc8dc7185
Validator 2 registered, gas used: 21572
BaseTokenMultiplier set, gas used: 55290
Done in 5.58s.


Now we also have to deploy the ValidatorTimelock..
 - and it needs CONTRACTS_CREATE2_FACTORY_ADDR
 (this required some 'hacking' of the deploy-utils)..

 and now we get: CONTRACTS_VALIDATOR_TIMELOCK_ADDR=0xC8cAD763dC6FF0985FD2434400db58e26C5B936e
 ^^this was still via: zk f yarn deploy-no-build



 zk f yarn initialize-validator
 Error: Hyperchain: not state transition manager...
 Or maybe this is really not needed - do we need a separate validator? or can they share??



Now tryign to deploy l2 through l1.
CONTRACTS_BASE_TOKEN_ADDR=0x0000000000000000000000000000000000000001

zk config compile dev

This also requires governance to be set (as this is what 'approves' this).
CONTRACTS_GOVERNANCE_ADDR

And now this worked:
zk contract deploy-l2-through-l1

We also need MultiCall3..
CONTRACTS_L1_MULTICALL3_ADDR=0xCF506433F1e04c008c7f230a8d2B8f9dd885837A


Now zk f zksync_server (remember - from the '/' dir).

it fails on ValidatorTimelock: only validator.

CONTRACTS_VALIDATOR_TIMELOCK_ADDR=0x66D64f3af78E0E4FC6F6f1922f728513BBC303Bd

And now -- nonce too low - I probably use the same operator as in  the other chain..
(I had to update nonce in eth_txs - and remove entry from eth_txs_history).

I have 'from': 0x4F9133D1d3F50011A6859807C837bdCB31Aaab13 (which is the same as 'commit' operator in the first chain).




ok -  Ihave to tell 'validator timelock', that I'm a validator for this new chain -id
Ok - the issue was, that we didn't set the correct timelock early enough..

So let's fix it for real, 2 new keys:
Address:     0xdbE3094f075AA8bC8D3EFeA39a488c759849Fa63
Private key: 0xbadbb556964c61aa6e752d2844a7cb942d85954affd2d0318c3a0d7dc97001d9

Address:     0xAC044784A139C70A589A8C17B5229D58ed0D786d
Private key: 0x13821fd6d08beb983d1139f7d3087cd2372f1cd7606e87d19aaa4a925e391b90


Update private.toml
// Remember to send some money there.

And re-registering:
yarn run v1.22.22
$ ts-node scripts/register-hyperchain.ts
Using deployer wallet: 0x52312AD6f01657413b2eaE9287f6B9ADaD93D5FE
Using governor address: 0x52312AD6f01657413b2eaE9287f6B9ADaD93D5FE
Using gas price: 1.500000001 gwei
Using nonce: 187
Using base token address: 0x0000000000000000000000000000000000000001
Validator registered, gas used: 73274, tx hash: 0x8ae33f67c2205dc603d882b89358c6c53477ba7ae2b321239e2743175d204703
Validator 2 registered, gas used: 73274
Done in 4.66s.


## Stuff to do:
* zkcli - to support chain id
* explorer app - to display different options


### Summary

## Trying again

CHAIN_ETH_ZKSYNC_NETWORK_ID=272  -- clearly select early.

* generate the wallets for the operator & blob operator.

Copy from the main one:

CONTRACTS_BRIDGEHUB_PROXY_ADDR=0x35A3783781DE026E1e854A6DA45d7a903664a9dA
CONTRACTS_STATE_TRANSITION_PROXY_ADDR=0x358E8b343f5Fd58aC74B262c4492BdFB9CC94116
CONTRACTS_ADMIN_FACET_ADDR=0xde1eE9622c8D6F7Da5bb7fB6dAa456f7cbF8a68d
CONTRACTS_MAILBOX_FACET_ADDR=0xfF33105a4BC25D8e2d152850d040286800E906e1
CONTRACTS_EXECUTOR_FACET_ADDR=0x72093667348cA8381aFA17BBBe97946cc26B9B63
CONTRACTS_GETTERS_FACET_ADDR=0x359fC3e2c4417C19f48089DB28a6a51c16e92822
CONTRACTS_DIAMOND_INIT_ADDR=0x9fbFBa544B76F67Bf821E3468990B21bFaE45a10
CONTRACTS_BLOB_VERSIONED_HASH_RETRIEVER_ADDR=0x585dFAf7332B9a725b8A1957fc6eF544A732bAD9
CONTRACTS_VERIFIER_ADDR=0x4e49ee147EaD1e39951B9779eA11e16eA30b19C2
CONTRACTS_L1_MULTICALL3_ADDR=0xCF506433F1e04c008c7f230a8d2B8f9dd885837A
CONTRACTS_VALIDATOR_TIMELOCK_ADDR=0x66D64f3af78E0E4FC6F6f1922f728513BBC303Bd
CONTRACTS_GOVERNANCE_ADDR=0x808Dfd96334E52c043e524C16FDD94832884302E

Successfully created new keypair.
Address:     0xEc39FE3212FedB610842DC15C7a64F6Ef2Cb003B
Private key: 0xca274905a4b9da86b41a0527228468057f1e901970d2e13bf5b0f3cfde1e6210
➜  local-setup git:(mmzk_0427_with_hyperchain) ✗ cast wallet new
Successfully created new keypair.
Address:     0x7217599A3129c7f3F9e907ae8f25CCDaDdA40756
Private key: 0x6782bd9efb4cd8a84a52a78b431a20e8811801f9b4d63978d2ec00b33fef7ff6

ETH_SENDER_SENDER_OPERATOR_PRIVATE_KEY=0xca274905a4b9da86b41a0527228468057f1e901970d2e13bf5b0f3cfde1e6210
ETH_SENDER_SENDER_OPERATOR_COMMIT_ETH_ADDR=0xEc39FE3212FedB610842DC15C7a64F6Ef2Cb003B
ETH_SENDER_SENDER_OPERATOR_BLOBS_PRIVATE_KEY=0x6782bd9efb4cd8a84a52a78b431a20e8811801f9b4d63978d2ec00b33fef7ff6
ETH_SENDER_SENDER_OPERATOR_BLOBS_ETH_ADDR=0x7217599A3129c7f3F9e907ae8f25CCDaDdA40756


zk db reset
zk contract register-hyperchain

$ ts-node scripts/register-hyperchain.ts
Using deployer wallet: 0x52312AD6f01657413b2eaE9287f6B9ADaD93D5FE
Using governor address: 0x52312AD6f01657413b2eaE9287f6B9ADaD93D5FE
Using gas price: 1.500000001 gwei
Using nonce: 189
Using base token address: 0x0000000000000000000000000000000000000001
Hyperchain registered, gas used: 3193077 and 3193077
Hyperchain registration tx hash: 0x7e613e87ea2391f4944d53698038c20c08d18a5ffa5700839c2be552578d64e8
CHAIN_ETH_ZKSYNC_NETWORK_ID=272
CONTRACTS_BASE_TOKEN_ADDR=0x0000000000000000000000000000000000000001
CONTRACTS_DIAMOND_PROXY_ADDR=0xac4edbf79496b70e82ec4359d8b9eb0b6da457a7
Validator registered, gas used: 73262, tx hash: 0x4a1790757e2f2a5e72f00bb066cfe3e753324f58eb3d8b88542ef25e052a0700
Validator 2 registered, gas used: 73274
BaseTokenMultiplier set, gas used: 55290
Done in 5.90s.
Writing to etc/env/l2-inits/docker.init.env
Configs compiled for docker

    zk f zksync_server --genesis
    zk contract deploy-l2-through-l1
 --failed on 'initializing chain governance'


 ## Manual transfer


Make sure to get the correct bridgehub address (in this example: 0x35A3783781DE026E1e854A6DA45d7a903664a9dA) from the hyperexplorer.

 ```
 cast send -r http://localhost:15045  --private-key 0x27593fea79697e947890ecbecce7901b0008345e5d7259710d0dd5e500d040be 0x35A3783781DE026E1e854A6DA45d7a903664a9dA "requestL2TransactionDirect((uint256, uint256, address, uint256, bytes, uint256, uint256, bytes[], address))" "(270,0xde0b6b3a7640000,0x005C43B2063625e9425943Fec65c42d005a2cD1f,10000000000000,"",10000000,800,[0x1234567890123456789012345678901234567890123456789012345678901234],0x005C43B2063625e9425943Fec65c42d005a2cD1f)" --value=1000000000000000000
 ```

## Hyperchains

Will start a hyperchain with 3 L2s, L1 and necessary explorers.

To run:

```shell
docker compose -f hyperchain-docker-compose.yml up -d
```