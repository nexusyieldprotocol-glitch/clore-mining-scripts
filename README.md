# Clore Mining Scripts

**clore-mining-scripts** provides optimized mining configurations and deployment scripts for Clore.ai GPU cloud servers. Designed for maximum hash rate and efficiency across multiple cryptocurrency mining operations.

## Overview

- Optimized GPU mining scripts for Clore.ai
- Multi-coin support (ETH, XMR, FLUX, etc.)
- Automatic pool selection and failover
- Real-time performance monitoring
- Energy-efficient configurations
- Docker deployment ready

## Supported Coins

- **Ethereum (ETH)**: Proof-of-Work
- **Monero (XMR)**: RandomX
- **Kaspa (KAS)**: KHeavyHash
- **Flux (FLUX)**: ProgPow

## Quick Start

```bash
git clone https://github.com/nexusyieldprotocol-glitch/clore-mining-scripts.git
cd clore-mining-scripts

# Install dependencies
npm install

# Configure for your setup
cp config.example.json config.json
nano config.json

# Start mining
npm start
```

## Configuration

### config.json

```json
{
  "coin": "ETH",
  "pool": "your-pool-url",
  "wallet": "0xyour-address",
  "worker": "worker-name",
  "gpu_devices": [0, 1, 2],
  "power_limit": 300,
  "core_clock": 1500,
  "memory_clock": 7000
}
```

## Performance Targets

- **RTX 4090**: 450+ MH/s (ETH)
- **RTX 4080**: 300+ MH/s (ETH)
- **RTX 4070**: 220+ MH/s (ETH)
- **A100**: 6000+ MH/s (XMR)

## Features

- Real-time hashrate monitoring
- Automatic pool switching on failure
- Temperature management
- Power consumption tracking
- Revenue calculator
- Multi-GPU coordination

## API

### Miner

```bash
npm start -- --coin ETH --pool stratum+tcp://pool.example.com:3333
npm stop
npm run status
npm run stats
```

## Deployment

### Docker

```bash
docker build -t clore-mining .
docker run --gpus all -v $(pwd)/config.json:/app/config.json clore-mining
```

### Clore.ai

1. Create a compute instance on Clore.ai
2. Select GPU tier (RTX 4090 recommended)
3. Upload config.json
4. Run: `npm install && npm start`

## Monitoring

```bash
# Watch live stats
npm run watch

# Export performance data
npm run export:stats

# Revenue analysis
npm run report:revenue
```

## Troubleshooting

- **Low hashrate**: Verify GPU clocks, driver version, pool settings
- **High rejection rate**: Check wallet address, pool credentials
- **Temperature issues**: Reduce power limit, improve ventilation

## Contributing

Contributions welcome for:
- New coin support
- Optimization techniques
- Documentation

## License

MIT
