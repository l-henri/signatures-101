
var TDErc20 = artifacts.require("ERC20TD.sol");
var evaluator = artifacts.require("Evaluator.sol");
var BouncerProxy = artifacts.require("BouncerProxy.sol");
var myERC721 = artifacts.require("myERC721.sol");
var minter = artifacts.require("Minter.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await instanciateToken(deployer, network, accounts); 
		await deployRecap(deployer, network, accounts); 
		await deploySolution(deployer, network, accounts); 
    });
};

async function instanciateToken(deployer, network, accounts) {
	TDToken = await TDErc20.at("0x791952b6b16FB23628fCEBaBaa275dFDCCde6883")
	Evaluator = await evaluator.at("0x7bBa6291CF1F3c1b612e0CFEDB561264e11B1440")
	bouncerProxy = await BouncerProxy.at("0xb1E518123Ef521aB9A64835e457Fb51368Aae0DA")
}

async function deployRecap(deployer, network, accounts) {
	console.log("TDToken " + TDToken.address)
	console.log("bouncerProxy reference " + bouncerProxy.address)
	console.log("Evaluator " + Evaluator.address)
}
async function readBalance(accounts, deployer, network) {
	console.log(accounts[0])
	points = await TDToken.balanceOf(accounts[0]);
	console.log(points + " points")
}
async function deploySolution(deployer, network, accounts) {
	myERC721Deployed = await myERC721.new();
	myMinter = await minter.new(myERC721Deployed.address);
	await readBalance(accounts);
	await Evaluator.submitExercice(myERC721Deployed.address);
	test = await Evaluator.exerciceProgression(accounts[0],0);
	console.log("ex0: " + test)
	await Evaluator.ex1_testERC721();
	test = await Evaluator.exerciceProgression(accounts[0],1);
	console.log("1: " + test)
	await readBalance(accounts);

}