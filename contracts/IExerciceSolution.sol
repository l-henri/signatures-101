pragma solidity ^0.6.0;


interface IExerciceSolution
{
	function ERC721Address() external returns (address);

	function mintATokenForMe() external returns (uint256);

	function getAddressFromSignature(bytes32 _hash, bytes calldata _signature) external returns (address);

	function signerIsWhitelisted(bytes32 _hash, bytes calldata _signature) external returns (bool);

	function whitelist(address _signer) external returns (bool);
 
}
