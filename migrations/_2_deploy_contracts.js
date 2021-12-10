const ERC721TD = artifacts.require(
  "./ERC721TD.sol"
);
const MetaTxExercice = artifacts.require(
  "./MetaTxExercice.sol"
);

async function doDeploy(deployer, network, accounts) {
  masterAddress = "0x87400bCd1c90cf0BDFD5C7178f533E4b1D976272";

  const ERC721Contract = await deployer.deploy(
    ERC721TD,
    "MetaTxTd",
    "MTXTD"
  );

  const MetaTxExerciceContract = await deployer.deploy(
    MetaTxExercice,
    ERC721Contract.address
  );
  
  // Declare MetaTxExerciceContract as minter for ERC721
  await ERC721Contract.manageMinter(MetaTxExerciceContract.address, true);

  // Testing to get whitelisted a token
  const _hashToSign = await MetaTxExerciceContract.hashToSignToGetWhiteListed.call();
  console.log(_hashToSign)
  const parametersEncoded = web3.eth.abi.encodeParameters(['bytes32'], [_hashToSign]);
  // const hashToSign = web3.utils.keccak256(parametersEncoded)
  const signature = await web3.eth.sign(_hashToSign,accounts[1])
  console.log(signature)
   	await MetaTxExerciceContract.getWhiteListed(signature, {from: accounts[1]})

  console.log("Done")
  // Testing to get whitelisted a token
  const tokenNumber = await ERC721Contract.nextTokenId.call();
  const parametersEncoded2 = web3.eth.abi.encodeParameters(['address', 'uint256'], [ERC721Contract.address, tokenNumber]);
  const hashToSign2 = web3.utils.keccak256(parametersEncoded2)
  const signature2 = await web3.eth.sign(hashToSign2,accounts[1])
  console.log(signature2)
   	await MetaTxExerciceContract.claimAToken(signature2, {from: accounts[2]})

   	// const test = await ERC721Contract.nextTokenId.call();
   	// console.log(test)

   	console.log("ERC721 Address: "+ERC721Contract.address)
   	console.log("MetaTxExercice address: "+MetaTxExerciceContract.address)
   	console.log("Token "+ tokenNumber + ": authorized mint by address " + accounts [1] + ", and mint tx sent by address " + accounts[2])

}

module.exports = (deployer, network, accounts) => {
  deployer.then(async () => {
    await doDeploy(deployer, network, accounts);
  });
};
