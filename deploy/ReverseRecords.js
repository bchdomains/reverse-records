const Registry = require("@bchdomains/lns-contracts/deployments/smartbch/ENSRegistryWithFallback.json");
const AmberRegistry = require("@bchdomains/lns-contracts/deployments/smartbch-amber/ENSRegistryWithFallback.json");

const REGISTRY_ADDRESSES = {
  'smartbch': Registry.address,
  'smartbch-amber': AmberRegistry.address
}

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments

  const { mnemonic } = await getNamedAccounts();
  console.log(mnemonic)

  const REGISTRY_ADDRESS = REGISTRY_ADDRESSES[hre.network.name];
  if (!REGISTRY_ADDRESS) {
    throw "No registry address for network " + hre.network.name;
  }

  await deploy("ReverseRecords", {
    from: mnemonic,
    args: [REGISTRY_ADDRESS],
    log: true,
    deterministicDeployment: false
  })
}

module.exports.tags = ["ReverseRecords"]
module.exports.dependencies = []
