pragma solidity ^0.6.0;
import "./IExerciceSolution.sol";
import "./myERC721.sol";

contract Minter is IExerciceSolution {
    myERC721 public myERC721Instance;

    constructor(myERC721 _myERC721Instance) public 
    {
        myERC721Instance = _myERC721Instance;
    }


	function ERC721Address() external override returns (address)
    {return address(myERC721Instance);}

	function mintATokenForMe() external override returns (uint256)
    {   
        uint256 newTokenId = myERC721Instance.publicMint(msg.sender);
        return newTokenId;
    }

	function mintATokenForMeWithASignature(bytes calldata _signature) external override returns (uint256)
    {return 0;}

	function getAddressFromSignature(bytes32 _hash, bytes calldata _signature) external override returns (address)
    {return address(0);}
	function signerIsWhitelisted(bytes32 _hash, bytes calldata _signature) external override returns (bool)
    {return true;}
	function whitelist(address _signer) external override returns (bool)
    {return true;}

}