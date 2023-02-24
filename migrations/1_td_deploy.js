
var TDErc20 = artifacts.require("ERC20TD.sol");
var evaluator = artifacts.require("Evaluator.sol");
var BouncerProxy = artifacts.require("BouncerProxy.sol");
var myERC721 = artifacts.require("myERC721.sol");
var minter = artifacts.require("Minter.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployTDToken(deployer, network, accounts); 
        await deployEvaluator(deployer, network, accounts); 
        await setPermissionsAndRandomValues(deployer, network, accounts); 
        await deployRecap(deployer, network, accounts); 
		await deploySolution(deployer, network, accounts); 
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

// truffle run verify ERC20TD@0x53e37895Ec887F577EC481549Aeb14B367D1904a --network goerli
// truffle run verify BouncerProxy@0xc1C00C5A5d620A9A907c0B6f4e186838f5d82532 --network goerli
// truffle run verify evaluator@0x657e2603c61eC6562258d72ce9E2C27E8537F81C --network goerli


async function readBalance(accounts, deployer, network) {
	console.log(accounts[0])
	points = await TDToken.balanceOf(accounts[0]);
	console.log(points + " points")
}
async function deploySolution(deployer, network, accounts) {
	myERC721Deployed = await myERC721.new();
	myMinter = await minter.new(myERC721Deployed.address);
	await readBalance(accounts);
	await Evaluator.submitExercice(myMinter.address);
	test = await Evaluator.exerciceProgression(accounts[0],0);
	console.log("ex0: " + test)
	await Evaluator.ex1_testERC721();
	await readBalance(accounts);

	test = await Evaluator.exerciceProgression(accounts[0],1);
	console.log("ex1: " + test)

	test2 = await Evaluator.exerciceProgression(accounts[0],2);
	console.log("ex2: " + test2)
	// const hashToSign = 0x00000000596f75206e65656420746f207369676e207468697320737472696e67
	
	console.log(web3.utils.padLeft('0x00000000596f75206e65656420746f207369676e207468697320737472696e67'))
	// const parametersEncoded2 = web3.eth.abi.encodeParameters(['uint256'], [test4]);
	// console.log(parametersEncoded2)
	const signature = await web3.eth.sign('0x00000000596f75206e65656420746f207369676e207468697320737472696e67',accounts[0])
	test3 = await Evaluator.extractAddressExternal('0x00000000596f75206e65656420746f207369676e207468697320737472696e67', signature);
	console.log("test3: " + test3)
	console.log(accounts[0])
	
	await Evaluator.ex2_generateASignature(signature);
}
