# ERC20 101

## Introduction

Welcome! This is an automated workshop that will explain how to deploy and ERC20 token, and customize it to perform specific functions.
It is aimed at developpers that have never written code in Solidity, but who understand its syntax.

## How to work on this TD

### Introduction

The TD has two components:

- An ERC20 token, ticker TD-ERC20-101, that is used to keep track of points
- An evaluator contract, that is able to mint and distribute TD-ERC20-101 points

Your objective is to gather as many TD-ERC20-101 points as possible. Please note :

- The 'transfer' function of TD-ERC20-101 has been disabled to encourage you to finish the TD with only one address
- You can answer the various questions of this workshop with different ERC20 contracts. However, an evaluated address has only one evaluated ERC20 contract at a time. To change the evaluated ERC20 contract associated with your address, call `submitExercice()` with that specific address.
- In order to receive points, you will have to do execute code in `Evaluator.sol` such that the function `TDERC20.distributeTokens(msg.sender, n);` is triggered, and distributes n points.
- This repo contains an interface `IExerciceSolution.sol`. Your ERC20 contract will have to conform to this interface in order to validate the exercice; that is, your contract needs to implement all the functions described in `IExerciceSolution.sol`.
- A high level description of what is expected for each exercice is in this readme. A low level description of what is expected can be inferred by reading the code in `Evaluator.sol`.
- The Evaluator contract sometimes needs to make payments to buy your tokens. Make sure he has enough ETH to do so! If not, you can send ETH directly to the contract.

### Getting to work

- Clone the repo on your machine
- Install the required packages `npm i`
- Register for an infura API key
- Register for an etherscan API key
- Create a `.env` file that contains private key for deployment, an infura API key.
- To deploy a contract, configure a script in the [scripts folder](script). Look at the way the TD is deployed and try to iterate
- Test your deployment locallly with `anvil` and `forge script script/your-script.s.sol --fork-url http://localhost:8545 --broadcast -vvvv`
- Deploy on Sepolia `forge script script/deployTD.s.sol --rpc-url $sepolia_url --broadcast -vvvv `

## Points list

### Setting up

- Create a hardhat project and configure it on Infura (2pts)
- Create an ERC721 smart contract and a separate minter contract that is allowed to mint ERC721 tokens using `ex1_testERC721` (2 pts)

### Generating and reading signatures

- Generate a signature and send it to evaluator using `ex2_generateASignature` (2 pts)
- Add a function getAddressFromSignature in the minter contract. Get points with `ex3_extractAddressFromSignature` (2 pts)
- Add a function signerIsWhitelisted() similar to bouncerProxy to know if a signer is whitelisted. Get points with `ex4_manageWhiteListWithSignature` (2 pts)
- Add a function to let anyone claim a token, as long as they provide a signature by an authorized minter. Get points with `ex5_mintATokenWithASpecificSignature` (3 pts)

### Meta transactions

- Deploy bouncerProxy contract and add one of your account (A) as a signer. Get points with `ex6_deployBouncerProxyAndWhitelistYourself` (3 pts)
- Call Evaluator from bouncerProxy, originatin the tx from an account not whitelisted in bouncerProxy. Get points with `ex7_useBouncerProxyToCallEvaluator` (4 pts)

### All in one

- Finish all the workshop in a single transaction! Write a contract that implements a function called `completeWorkshop()` when called. Call `ex8_allInOne()` from this contract. All points are credited to the validating contract.

## TD addresses

- ERC20TD [`0xA5175D7881a0B0fBd531986a9C8feA4231cbd874`](https://sepolia.etherscan.io/address/0xA5175D7881a0B0fBd531986a9C8feA4231cbd874)
- Evaluator [`0x7599A6d243a1d78c495817cFB9D9583E6f6740DD`](https://sepolia.etherscan.io/address/0x7599A6d243a1d78c495817cFB9D9583E6f6740DD)
