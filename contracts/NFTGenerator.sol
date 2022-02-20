pragma solidity ^0.5.6;

import '../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import '../node_modules/openzeppelin-solidity/contracts/drafts/Counters.sol';

contract NFTGenerator is ERC721Full('NFTGenerator', 'NFT') {
  using Counters for Counters.Counter;
  Counters.Counter private currentTokenId;

  function mintTo(address recipient) public returns (uint256) {
    currentTokenId.increment();
    uint256 newItemId = currentTokenId.current();
    _safeMint(recipient, newItemId);
    return newItemId;
  }
}
