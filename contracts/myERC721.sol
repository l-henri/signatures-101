// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract myERC721 is ERC721 {
  uint256 nextTokenId;
constructor() ERC721("Test", "TST") {

    }

function publicMint(address recipient) external returns(uint256)
{
  _mint(recipient,nextTokenId);
  nextTokenId += 1;
}

}