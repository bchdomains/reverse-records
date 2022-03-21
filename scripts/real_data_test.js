const hre = require("hardhat");
const CONTRACTS = {
  'ropsten': '0x5bBFe410e18DCcaebbf5fD7A00844d4255615258',
  'rinkeby': '0x196eC7109e127A353B709a20da25052617295F6f',
  'goerli': '0x333Fc8f550043f239a2CF79aEd5e9cF4A20Eb41e',
  'mainnet': '0x3671aE578E63FdF66ad4F3E12CC0c0d71Ac7510C',
  'smartbch': '0x67F0DD63065675830cba1f3CDb74390f4d5251E1',
  'smartbch-amber': '0xAA5BFa3011E4857ba6C25e841e01504c79268f54'
}

async function main(env) {
  console.log('hre.network.name', hre.network.name, CONTRACTS[hre.network.name]);
  const reverseRecords = await hre.ethers.getContractAt('ReverseRecords', CONTRACTS[hre.network.name])
  const addresses = [
    '0xd8da6bf26964af9d7eed9e03e53415d37aa96045',
    '0x5A384227B65FA093DEC03Ec34e111Db80A040615',
    '0x983110309620D911731Ac0932219af06091b6744',
    '0xb69d54a4e31f24AFdD9eB1b53f8319aC83C646c9',
  ]
  const result = await reverseRecords.getNames(addresses)
  for (let index = 0; index < result.length; index++) {
    console.log(addresses[index], result[index])
  }
}

main(process.env)
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
