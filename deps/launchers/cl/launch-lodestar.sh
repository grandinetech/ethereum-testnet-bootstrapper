#!/bin/bash

set -euo pipefail

# the set -u option will make this fail if any of these variables don't exist
# shellcheck disable=SC2034
env_vars=(
  "$CONSENSUS_BEACON_API_PORT"
  "$CONSENSUS_BEACON_METRIC_PORT"
  "$CONSENSUS_BEACON_RPC_PORT"
  "$CONSENSUS_BOOTNODE_FILE"
  "$CONSENSUS_CHECKPOINT_FILE"
  "$CONSENSUS_CLIENT"
  "$CONSENSUS_CONFIG_FILE"
  "$CONSENSUS_GENESIS_FILE"
  "$CONSENSUS_GRAFFITI"
  "$CONSENSUS_NODE_DIR"
  "$CONSENSUS_P2P_PORT"
  "$CONSENSUS_VALIDATOR_METRIC_PORT"
  "$CONSENSUS_VALIDATOR_RPC_PORT"
  "$CONSENSUS_LOG_LEVEL"
  "$IP_ADDRESS"
  "$IP_SUBNET"
  "$JWT_SECRET_FILE"
  "$COLLECTION_DIR"
  "$NUM_CLIENT_NODES"
  "$EXECUTION_ENGINE_HTTP_PORT"
  "$EXECUTION_ENGINE_WS_PORT"
)

# we can wait for the bootnode enr to drop before we get the signal to start up.
while [ ! -f "$CONSENSUS_BOOTNODE_FILE" ]; do
  echo "consensus client waiting for bootnode enr file: $CONSENSUS_BOOTNODE_FILE"
  sleep 1
done

bootnode_enr="$(cat "$CONSENSUS_BOOTNODE_FILE")"

while [ ! -f "$CONSENSUS_CHECKPOINT_FILE" ]; do
  echo "Waiting for consensus checkpoint file: $CONSENSUS_CHECKPOINT_FILE"
  sleep 1
done

echo "Launching Lodestar beacon node in ${CONTAINER_NAME}"

beacon_args=(
  --metrics=true
  --metrics.port="$CONSENSUS_BEACON_METRIC_PORT"
  --metrics.address="$IP_ADDRESS"
  --dataDir="$CONSENSUS_NODE_DIR"
  --paramsFile="$CONSENSUS_CONFIG_FILE"
  --genesisStateFile="$CONSENSUS_GENESIS_FILE"
  --execution.urls="http://127.0.0.1:$EXECUTION_ENGINE_HTTP_PORT"
  --jwt-secret="$JWT_SECRET_FILE"
  --bootnodes="$bootnode_enr"
  --network.connectToDiscv5Bootnodes=true
  --discv5
  --rest
  --rest.address=0.0.0.0
  --rest.port="$CONSENSUS_BEACON_API_PORT"
  --rest.namespace="*"
  --logLevel="$CONSENSUS_LOG_LEVEL"
  --logFile="$CONSENSUS_NODE_DIR/beacon.log"
  --enr.ip="$IP_ADDRESS"
  --enr.tcp="$CONSENSUS_P2P_PORT"
  --enr.udp="$CONSENSUS_P2P_PORT"
  --subscribeAllSubnets=true
  --eth1.depositContractDeployBlock=0
  --suggestedFeeRecipient=0x00000000219ab540356cbb839cbe05303d7705fa
)

validator_args=(
  --metrics=true
  --metrics.port="$CONSENSUS_VALIDATOR_METRIC_PORT"
  --metrics.address="$IP_ADDRESS"
  --dataDir="$CONSENSUS_NODE_DIR"
  --paramsFile="$CONSENSUS_CONFIG_FILE"
  --keystoresDir="$CONSENSUS_NODE_DIR/keys/"
  --secretsDir="$CONSENSUS_NODE_DIR/secrets/"
  --beaconNodes="http://127.0.0.1:$CONSENSUS_BEACON_API_PORT"
  --validatorsDbDir="$CONSENSUS_NODE_DIR/validatorsdb"
  --logFile="$CONSENSUS_NODE_DIR/validatordb/validator.log"
  --logLevel="$CONSENSUS_LOG_LEVEL"
  --graffiti="$CONSENSUS_GRAFFITI"
  --force
)

lodestar beacon "${beacon_args[@]}" > /data/logs/"service_$CONTAINER_NAME--lodestar-bn" 2>&1 &

sleep 10

echo "Launching Lodestar validator client in ${CONTAINER_NAME}"

lodestar validator "${validator_args[@]}" > /data/logs/"service_$CONTAINER_NAME--lodestar-vc" 2>&1
