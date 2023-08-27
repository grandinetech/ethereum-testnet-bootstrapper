FROM ethereum-testnet-bootstrapper as builder

ARG CONFIG_PATH="configs/capella-testing.yaml"

RUN mkdir /data

RUN mkdir /source/data
RUN touch /source/data/testnet_bootstrapper.log

RUN /source/entrypoint.sh --config "/source/configs/capella-testing.yaml" --init-testnet --log-level debug

RUN ls /data
RUN ls /source/data

FROM scratch

COPY --from=builder /source/deps /deps 
COPY --from=builder /source/src /src 
COPY --from=builder /data /data 
COPY --from=builder /source/configs /configs 
COPY --from=builder /source/entrypoint.sh /entrypoint.sh 
COPY --from=builder /source/docker-compose.yaml /docker-compose.yaml 

#FROM scratch

#ADD deps deps
#ADD apps apps
#ADD data data
#ADD configs configs
#ADD entrypoint.sh entrypoint.sh
#ADD docker-compose.yaml docker-compose.yaml
