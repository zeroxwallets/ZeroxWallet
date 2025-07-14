const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with:", deployer.address);

  const Wallet = await hre.ethers.getContractFactory("ZeroxWallet");
  const wallet = await Wallet.deploy();
  await wallet.deployed();
  console.log("ZeroxWallet deployed to:", wallet.address);

  const Paymaster = await hre.ethers.getContractFactory("ZeroxPaymaster");
  const paymaster = await Paymaster.deploy();
  await paymaster.deployed();
  console.log("ZeroxPaymaster deployed to:", paymaster.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
