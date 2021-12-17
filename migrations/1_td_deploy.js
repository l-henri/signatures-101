
var TDErc20 = artifacts.require("ERC20TD.sol");
var evaluator = artifacts.require("Evaluator.sol");
var BouncerProxy = artifacts.require("BouncerProxy.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployTDToken(deployer, network, accounts); 
        await deployEvaluator(deployer, network, accounts); 
        await setPermissionsAndRandomValues(deployer, network, accounts); 
        await deployRecap(deployer, network, accounts); 
    });
};

async function deployTDToken(deployer, network, accounts) {
	TDToken = await TDErc20.new("TD-ERC20-101","TD-ERC20-101",web3.utils.toBN("20000000000000000000000000000"))
	console.log(TDToken.address)
	bouncerProxy = await BouncerProxy.new();
}

async function deployEvaluator(deployer, network, accounts) {
	Evaluator = await evaluator.new(TDToken.address, bouncerProxy.address)
	console.log(Evaluator.address)
}

async function setPermissionsAndRandomValues(deployer, network, accounts) {
	await TDToken.setTeacher(Evaluator.address, true)
	randomData = []
	randomSig = []
	for (i = 0; i < 20; i++)
		{
			const accountNumber = Math.floor(Math.random()*10);
		const parametersEncoded2 = web3.eth.abi.encodeParameters(['address', 'uint256'], [accounts[accountNumber], Math.floor(Math.random()*1000000000)]);
  		const hashToSign2 = web3.utils.keccak256(parametersEncoded2)
		randomData.push(hashToSign2)
		const signature2 = await web3.eth.sign(hashToSign2,accounts[accountNumber])
		randomSig.push(signature2)
		// randomTickers.push(web3.utils.utf8ToBytes(Str.random(5)))
		// randomTickers.push(Str.random(5))
		}

	console.log(randomData)
	console.log(randomSig)
	// console.log(web3.utils)
	// console.log(type(Str.random(5)0)
	await Evaluator.setRandomBytes32AndSignature(randomData, randomSig);

}

async function deployRecap(deployer, network, accounts) {
	console.log("TDToken " + TDToken.address)
	console.log("bouncerProxy reference " + bouncerProxy.address)
	console.log("Evaluator " + Evaluator.address)
}


