// Deploying the TD somewhere
// To verify it on Etherscan:
// npx hardhat verify --network sepolia <address> <constructor arg 1> <constructor arg 2>

const hre = require("hardhat");
const Str = require('@supercharge/strings')

async function main() {
  // // Deploying contracts
  const ERC20TD = await hre.ethers.getContractFactory("ERC20TD");
  const Evaluator = await hre.ethers.getContractFactory("Evaluator");
  const BouncerProxy = await hre.ethers.getContractFactory("BouncerProxy");
  const erc20 = await ERC20TD.attach("0x9d3b872573c4c39DE0c1d546D5EB6F53087e0086");
  const bouncerproxy = await BouncerProxy.attach("0xe317d9b156c73114D8b1Ea1fa1307b7F0061a318");
  const evaluator = await Evaluator.attach("0x59566F304aC1F7Ba78A1FB3D8b9195A09d60e891");

    // setting random values
  randomData = []
	randomSig = []
	for (i = 0; i < 20; i++){
    let wallet = new ethers.Wallet(process.env.PRIVATE_KEY);
    // console.log(wallet.address);
    const hashToSign2 = ethers.utils.solidityKeccak256(['address', 'uint256'], [wallet.address, Math.floor(Math.random()*1000000000)]);
    randomData.push(hashToSign2)
    const signature2 = await wallet.signMessage(hashToSign2)
    randomSig.push(signature2)
	}

	console.log(randomData)
	console.log(randomSig)
	await evaluator.setRandomBytes32AndSignature(randomData, randomSig);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
