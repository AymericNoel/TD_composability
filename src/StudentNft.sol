// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;
pragma abicoder v2;

import "./IStudentNft.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StudentNft is ERC721, IStudentNft {
    constructor() 
      ERC721("DominikNft", "DNFT") { }
  
    // Mint a new NFT with a unique token ID and assign it to the specified address
    function mint(uint256 tokenId) external {
        _mint(address(this), tokenId);
    }

    function burn(uint id) external {
      require(msg.sender == _ownerOf(id), "not owner");
      _burn(id);
    }
}
