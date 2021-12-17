# Signatures 101

## Introduction
Welcome! This is an automated workshop that will guide you into learning out to use Ethereum signatures in smart contracts, and in meta transactions.
It is aimed at developpers that are familiar with Solidity.

## How to work on this TD
### Introduction
The TD has three components:
- An ERC20 token, ticker TD-SIG-101, that is used to keep track of points 
- An evaluator contract, that is able to mint and distribute TD-SIG-101 points

Your objective is to gather as many TD-SIG-101 points as possible. Please note :
- The 'transfer' function of TD-SIG-101 has been disabled to encourage you to finish the TD with only one address
- You can answer the various questions of this workshop with different contracts. However, an evaluated address has only one evaluated contract at a time. To change the evaluated contract associated with your address, call `submitExercice()`  with that specific address.
- In order to receive points, you will have to do execute code in `Evaluator.sol` such that the function `TDERC20.distributeTokens(msg.sender, n);` is triggered, and distributes n points.
- This repo contains an interface `IExerciceSolution.sol`. Your solution contract will have to conform to this interface in order to validate the exercice; that is, your contract needs to implement all the functions described in `IExerciceSolution.sol`. 
- A high level description of what is expected for each exercice is in this readme. A low level description of what is expected can be inferred by reading the code in `Evaluator.sol`.
- The Evaluator contract sometimes needs to make payments to buy your tokens. Make sure he has enough ETH to do so! If not, you can send ETH directly to the contract.

### Getting to work
- Clone the repo on your machine
- Install the required packages `npm install truffle`, `npm install @openzeppelin/contracts@3.4.1` , `npm install @truffle/hdwallet-provider`, `npm i @supercharge/strings`
- Rename `example-truffle-config.js` to `truffle-config.js` . That is now your truffle config file.
- Configure a seed for deployment of contracts in your truffle config file
- Register for an infura key and set it up in your truffle config file
- Download and launch Ganache
- Test that you are able to connect to the ganache network with `truffle console`
- Test that you are able to connect to the rinkeby network with `truffle console --network rinkeby`
- To deploy a contract, configure a migration in the [migration folder](migrations). Look at the way the TD is deploy and try to iterate
- Test your deployment in Ganache `truffle migrate`
- Deploy on Rinkeby `truffle migrate --network rinkeby --skip-dry-run`


## Points list
### Setting up

- Create a truffle project and configure it on Infura (2pts)
- Create an ERC721 smart contract and a separate minter contract that is allowed to mint ERC721 tokens using `ex1_testERC721` (2 pts)

### Generating and reading signatures
- Generate a signature and send it to evaluator using `ex2_generateASignature` (2 pts)
- Add a function getAddressFromSignature in the minter contract. Get points with `ex3_extractAddressFromSignature` (2 pts)
- Add a function signerIsWhitelisted() similar to bouncerProxy to know if a signer is whitelisted. Get points with `ex4_manageWhiteListWithSignature` (2 pts)
- Add a function to let anyone claim a token, as long as they provide a signature by an authorized minter. Get points with `ex5_mintATokenWithASpecificSignature` (3 pts)

### Meta transactions
- Deploy bouncerProxy contract and add one of your account (A) as a signer. Get points with `ex6_deployBouncerProxyAndWhitelistYourself` (3 pts)
- Call Evaluator from bouncerProxy, originatin the tx from an account not whitelisted in bouncerProxy. Get points with `ex7_useBouncerProxyToCallEvaluator` (4 pts)

## TD addresses
- Points contracts `0x878D1Dbbc0a3f5b73009f09ceCBEEBba36184297`
- Evaluator `0x0605830a47081c4f3F8C4583C624A901945321dB`

