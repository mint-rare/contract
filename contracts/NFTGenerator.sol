pragma solidity ^0.5.6;

import '../node_modules/@klaytn/contracts/token/KIP17/KIP17Full.sol';
import '../node_modules/@klaytn/contracts/drafts/Counters.sol';

contract NFTGenerator is KIP17Full('NFTGenerator', 'NFT') {
  using Counters for Counters.Counter;
  Counters.Counter private currentTokenId;

  function mintTo(address recipient) public returns (uint256) {
    currentTokenId.increment();
    uint256 newItemId = currentTokenId.current();
    _mint(recipient, newItemId);
    return newItemId;
  }
}
