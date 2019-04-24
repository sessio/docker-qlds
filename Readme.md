# Quake Live dedicated server docker image

x64 version is run

## Run

...todo

## Exposed ports

- Game: 27960 UDP (GAMEPORT env var)
- Rcon: 28960 UDP (RCON_PORT env var)

## Env

- `QLX_OWNER`: Steam64ID for server owner (must set)
- `REDIS_ADDRESS`: Redis address (defaults to 'redis')
- `SERVERNAME`: Server name in QL game browser (defaults to 'QLDS-docker')
- `STATS_ENABLED`: Stats enabled? (1/0, defaults to 1)
- `STATS_PASSWORD`: Stats password (defaults to 'mypass')
- `RCON_ENABLED`: Enable rcon? (1/0, defaults to 1)
- `RCON_PASSWORD`: Remote connection password (defaults to 'mypass')
