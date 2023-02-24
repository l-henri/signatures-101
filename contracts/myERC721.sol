pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract myERC721 is ERC721 {
  uint256 nextTokenId;
constructor() public ERC721("Test", "TST") {

    }

function publicMint(address recipient) external returns(uint256)
{
  _mint(recipient,nextTokenId);
  nextTokenId += 1;
}

}