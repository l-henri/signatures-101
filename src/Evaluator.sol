// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "./ERC20TD.sol";
import "./IExerciceSolution.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./BouncerProxy.sol";
import "./IAllInOneSolution.sol";

contract Evaluator {
    mapping(address => bool) public teachers;
    ERC20TD TDERC20;

    mapping(address => mapping(uint256 => bool)) public exerciceProgression;
    mapping(address => IExerciceSolution) public studentExerciceSolution;
    mapping(address => bool) public hasBeenPaired;

    bytes32[20] private randomBytes32ToSign;
    bytes[20] private associatedSignatures;
    uint256 public nextValueStoreRank;
    mapping(bytes32 => bool) public signedBytes32;
    address payable public referenceBouncerProxy;

    event constructedCorrectly(address erc20Address, address referenceBouncerProxy);
    event UpdateWhitelist(address _account, bool _value);
    event newRandomBytes32AndSig(bytes32 data, bytes sig);

    constructor(ERC20TD _TDERC20, address payable _referenceBouncerProxy) {
        TDERC20 = _TDERC20;
        referenceBouncerProxy = _referenceBouncerProxy;
        emit constructedCorrectly(address(TDERC20), referenceBouncerProxy);
    }

    fallback() external payable {}

    receive() external payable {}

    function ex1_testERC721() public {
        // Checking a solution was submitted
        require(exerciceProgression[msg.sender][0], "No solution submitted");

        // Retrieve ERC721 address from ExerciceSolution
        address studentERC721Address = studentExerciceSolution[msg.sender].ERC721Address();
        IERC721 studentERC721 = IERC721(studentERC721Address);

        // Check they are two different contracts
        require(studentERC721Address != address(studentExerciceSolution[msg.sender]), "ERC721 and minter are the same");

        // Checking balance pre minting
        uint256 evaluatorBalancePreMint = studentERC721.balanceOf(address(this));
        uint256 minterBalancePreMint = studentERC721.balanceOf(address(studentExerciceSolution[msg.sender]));

        // Claim a token through minter
        uint256 newToken = studentExerciceSolution[msg.sender].mintATokenForMe();

        // Checking balance post minting
        uint256 evaluatorBalancePostMint = studentERC721.balanceOf(address(this));
        uint256 minterBalancePostMint = studentERC721.balanceOf(address(studentExerciceSolution[msg.sender]));

        // Check that token 1 belongs to the Evaluator
        require(evaluatorBalancePostMint == evaluatorBalancePreMint + 1, "Did not receive one token");
        require(studentERC721.ownerOf(newToken) == address(this), "New token does not belong to meeee");

        // Check the token was minted, not lazily transferred
        require(minterBalancePostMint == minterBalancePreMint, "Minter balance changed, did not mint");

        // Check that token 1 can be transferred back to msg.sender, so it's a real ERC721
        uint256 senderBalancePreTransfer = studentERC721.balanceOf(msg.sender);
        studentERC721.safeTransferFrom(address(this), msg.sender, newToken);
        require(
            studentERC721.balanceOf(address(this)) == evaluatorBalancePreMint, "Balance did not decrease after transfer"
        );
        require(studentERC721.ownerOf(newToken) == msg.sender, "Token does not belong to you");
        require(
            studentERC721.balanceOf(msg.sender) == senderBalancePreTransfer + 1,
            "Balance did not increase after transfer"
        );

        // Crediting points
        if (!exerciceProgression[msg.sender][1]) {
            exerciceProgression[msg.sender][1] = true;
            // ERC721 points
            TDERC20.distributeTokens(msg.sender, 2);
        }
    }

    function ex2_generateASignature(bytes memory _signature) public {
        bytes32 stringToSignToGetPoint = 0x00000000596f75206e65656420746f207369676e207468697320737472696e67;

        // If tx fails here, it means the transaction did not receive a valid signature
        address signatureSender = extractAddress(stringToSignToGetPoint, _signature);
        require(tx.origin == signatureSender, "signature does not match tx originator");

        // Crediting points
        if (!exerciceProgression[msg.sender][2]) {
            exerciceProgression[msg.sender][2] = true;
            // ERC721 points
            TDERC20.distributeTokens(msg.sender, 2);
        }
    }

    function ex3_extractAddressFromSignature() public {
        // Retrieving a random signature and associated address
        address signatureSender =
            extractAddress(randomBytes32ToSign[nextValueStoreRank], associatedSignatures[nextValueStoreRank]);

        // Checking that student contract is able to extract the address from the signature
        address retrievedAddressByExerciceSolution = studentExerciceSolution[msg.sender].getAddressFromSignature(
            randomBytes32ToSign[nextValueStoreRank], associatedSignatures[nextValueStoreRank]
        );

        require(signatureSender == retrievedAddressByExerciceSolution, "Signature not interpreted correctly");

        // Incrementing next value store rank
        nextValueStoreRank += 1;
        if (nextValueStoreRank >= 20) {
            nextValueStoreRank = 0;
        }

        // Crediting points
        if (!exerciceProgression[msg.sender][3]) {
            exerciceProgression[msg.sender][3] = true;
            // ERC721 points
            TDERC20.distributeTokens(msg.sender, 2);
        }
    }

    function ex4_manageWhiteListWithSignature(bytes32 _aBytes32YouChose, bytes memory _theAssociatedSignature) public {
        // Is your signature correctly formated
        address signatureSender = extractAddress(_aBytes32YouChose, _theAssociatedSignature);
        // Broadcaster is signer
        require(signatureSender == tx.origin, "signature does not match tx originator");

        // Is the signer whitelisted
        require(studentExerciceSolution[msg.sender].whitelist(signatureSender), "originator not whitelisted");
        require(
            studentExerciceSolution[msg.sender].signerIsWhitelisted(_aBytes32YouChose, _theAssociatedSignature),
            "Signature not validated correctly"
        );

        // Extracting a random signer
        address storedSignatureSender =
            extractAddress(randomBytes32ToSign[nextValueStoreRank], associatedSignatures[nextValueStoreRank]);

        // Is a random signer whitelisted whitelisted
        require(!studentExerciceSolution[msg.sender].whitelist(storedSignatureSender), "Random signer is whitelisted");
        require(
            !studentExerciceSolution[msg.sender].signerIsWhitelisted(
                randomBytes32ToSign[nextValueStoreRank], associatedSignatures[nextValueStoreRank]
            ),
            "Random signature works"
        );

        // Incrementing next value store rank
        nextValueStoreRank += 1;
        if (nextValueStoreRank >= 20) {
            nextValueStoreRank = 0;
        }
        // Crediting points
        if (!exerciceProgression[msg.sender][4]) {
            exerciceProgression[msg.sender][4] = true;
            // ERC721 points
            TDERC20.distributeTokens(msg.sender, 2);
        }
    }

    function ex5_mintATokenWithASpecificSignature(bytes memory _theRequiredSignature) public {
        // Retrieve ERC721 address from ExerciceSolution
        address studentERC721Address = studentExerciceSolution[msg.sender].ERC721Address();
        IERC721 studentERC721 = IERC721(studentERC721Address);

        // Generating the data that needs to be signed to claim a token on student contract.
        // We hash the concatenation of the evaluator address, the sender's address, and the ERC721 address
        bytes32 dataToSign = keccak256(abi.encodePacked(address(this), tx.origin, studentERC721Address));

        // Has sender signed the correct piece of data, and extract the address
        address signatureSender = extractAddress(dataToSign, _theRequiredSignature);

        // Broadcaster is signer
        require(signatureSender == tx.origin, "signature does not match tx originator");

        // Checking that we own no NFT before claiming
        uint256 evaluatorBalancePreMint = studentERC721.balanceOf(address(this));

        // Claim a token through minter
        uint256 newToken = studentExerciceSolution[msg.sender].mintATokenForMeWithASignature(_theRequiredSignature);

        // Checking balance post minting
        uint256 evaluatorBalancePostMint = studentERC721.balanceOf(address(this));

        // Check that token 1 belongs to the Evaluator
        require(evaluatorBalancePostMint == evaluatorBalancePreMint + 1, "Did not receive one token");
        require(studentERC721.ownerOf(newToken) == address(this), "New token does not belong to meeee");

        // Incrementing next value store rank
        nextValueStoreRank += 1;
        if (nextValueStoreRank >= 20) {
            nextValueStoreRank = 0;
        }
        // Crediting points
        if (!exerciceProgression[msg.sender][5]) {
            exerciceProgression[msg.sender][5] = true;
            // ERC721 points
            TDERC20.distributeTokens(msg.sender, 3);
        }
    }

    function ex6_deployBouncerProxyAndWhitelistYourself(address payable myBouncerProxy) public {
        // Build bouncer proxy
        BouncerProxy localBouncer = BouncerProxy(myBouncerProxy);
        // Retrieving your contract code hash
        bytes32 codeHash;
        assembly {
            codeHash := extcodehash(myBouncerProxy)
        }
        // Checking it is the correct code hash
        bytes32 referenceCodeHash;
        address _referenceBouncerProxy = referenceBouncerProxy;
        assembly {
            referenceCodeHash := extcodehash(_referenceBouncerProxy)
        }

        require(referenceCodeHash == codeHash, "Deployed code is different from reference");

        // Check if sender is whitelisted
        require(localBouncer.whitelist(tx.origin), "Tx originator is not whitelisted");
        // For fun, whitelist sender also
        require(localBouncer.whitelist(msg.sender), "Message sender is not whitelisted");

        // Crediting points
        if (!exerciceProgression[msg.sender][6]) {
            exerciceProgression[msg.sender][6] = true;
            // ERC721 points
            TDERC20.distributeTokens(msg.sender, 3);
        }
    }

    function ex7_useBouncerProxyToCallEvaluator() public {
        // Retrieving caller contract code hash
        bytes32 codeHash;
        address _sender = msg.sender;
        assembly {
            codeHash := extcodehash(_sender)
        }
        // Checking it is the correct code hash
        bytes32 referenceCodeHash;
        address _referenceBouncerProxy = referenceBouncerProxy;
        assembly {
            referenceCodeHash := extcodehash(_referenceBouncerProxy)
        }

        require(referenceCodeHash == codeHash, "Deployed code is different from reference");

        // Build bouncer proxy
        BouncerProxy localBouncer = BouncerProxy(payable(msg.sender));
        // Check if sender is whitelisted
        require(!localBouncer.whitelist(tx.origin), "Tx originator is whitelisted");

        // Crediting points
        if (!exerciceProgression[msg.sender][7]) {
            exerciceProgression[msg.sender][7] = true;
            // ERC721 points
            TDERC20.distributeTokens(msg.sender, 4);
        }
    }

    function ex8_allInOne() public {
        // Checking that solution has no token yet
        uint256 initialBalance = TDERC20.balanceOf(msg.sender);
        require(initialBalance == 0, "Solution should start with 0 points");

        // Calling the solution so that it solves the workshop
        IAllInOneSolution callerSolution = IAllInOneSolution(msg.sender);
        callerSolution.completeWorkshop();

        // Checking that at least 10 exercices where validated
        uint256 finalBalance = TDERC20.balanceOf(msg.sender);
        uint256 decimals = TDERC20.decimals();
        require(finalBalance >= 10 ** decimals * 16, "Solution should end with at least than 2 points");

        if (!exerciceProgression[msg.sender][8]) {
            exerciceProgression[msg.sender][8] = true;
            // Distribute points
            TDERC20.distributeTokens(msg.sender, 2);
        }
    }

    modifier onlyTeachers() {
        require(TDERC20.teachers(msg.sender));
        _;
    }

    /* Internal functions and modifiers */
    function submitExercice(IExerciceSolution studentExercice) public {
        // Checking this contract was not used by another group before
        require(!hasBeenPaired[address(studentExercice)]);

        // Assigning passed ERC20 as student ERC20
        studentExerciceSolution[msg.sender] = studentExercice;
        hasBeenPaired[address(studentExercice)] = true;

        if (!exerciceProgression[msg.sender][0]) {
            exerciceProgression[msg.sender][0] = true;
            // setup points
            TDERC20.distributeTokens(msg.sender, 2);
        }
    }

    function setRandomBytes32AndSignature(bytes32[20] memory _randomData, bytes[20] memory _signatures)
        public
        onlyTeachers
    {
        randomBytes32ToSign = _randomData;
        associatedSignatures = _signatures;
        nextValueStoreRank = 0;
        for (uint256 i = 0; i < 20; i++) {
            emit newRandomBytes32AndSig(randomBytes32ToSign[i], associatedSignatures[i]);
        }
    }

    function _compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    function extractAddressExternal(bytes32 _hash, bytes calldata _signature) external pure returns (address) {
        return extractAddress(_hash, _signature);
    }

    function extractAddress(bytes32 _hash, bytes memory _signature) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        // Check the signature length
        if (_signature.length != 65) {
            return address(0);
        }
        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }
        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return address(0);
        } else {
            // solium-disable-next-line arg-overflow
            return ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)), v, r, s);
        }
    }
}
