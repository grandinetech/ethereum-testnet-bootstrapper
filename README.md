[![etb-all-clients](https://github.com/antithesishq/ethereum-testnet-bootstrapper/actions/workflows/etb-all-clients.yml/badge.svg)](https://github.com/antithesishq/ethereum-testnet-bootstrapper/actions/workflows/etb-all-clients.yml)

# ethereum-testnet-bootstrapper

## Client Versions

**Consensus Clients**

Client | Current Release | Branch/tag used for Antithesis testing
--- | --- | ---
Nimbus | 23.3.2 | [unstable](https://github.com/status-im/nimbus-eth2/tree/unstable)
Lodestar | 1.7.2 | [unstable](https://github.com/ChainSafe/lodestar/tree/unstable)
Lighthouse | 4.0.1 | [unstable](https://github.com/sigp/lighthouse/tree/unstable)
Prysm | 4.0.1 | [4.0.0-rc.2](https://github.com/prysmaticlabs/prysm/tree/v4.0.0-rc.2)
Teku | 23.3.1 | [master](https://github.com/ConsenSys/teku/tree/master)

**Execution Clients**
Client | Current Release | Branch used for Antithesis testing
--- | --- | ---
Geth | 1.11.5 | [master](https://github.com/ethereum/go-ethereum/tree/master)
Besu | 23.1.3 | [main](https://github.com/hyperledger/besu/tree/main)
Nethermind | 1.17.3 | [master](https://github.com/NethermindEth/nethermind/tree/master)

## Building images

`make build-all-images`

To rebuild images without cache:

`make rebuild-all-images`

## Building a single image

`source ./common.sh && cd deps/dockers/el && build_image geth geth.Dockerfile`

To rebuild without cache:

`source ./common.sh && cd deps/dockers/el && REBUILD_IMAGES=1 build_image geth geth.Dockerfile`
