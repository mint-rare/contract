pragma solidity ^0.5.6;
pragma experimental ABIEncoderV2;

import '../node_modules/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol';
import '../node_modules/@klaytn/contracts/token/KIP17/KIP17.sol';
import '../node_modules/@klaytn/contracts/math/SafeMath.sol';
import '../node_modules/@klaytn/contracts/utils/Address.sol';

contract Market is KIP17, ReentrancyGuard {
  using SafeMath for uint256;
  using Address for address;

  uint256 private _totalSaleCount = 0;

  struct SaleTokenInfo {
    address owner;
    address tokenAddress;
    uint256 tokenId;
    uint256 price;
  }

  SaleTokenInfo[] saleTokenList;

  struct SaleTokenInfoMap {
    address payable seller;
    uint256 price;
    uint256 tokenListIndex;
  }

  mapping(address => mapping(uint256 => SaleTokenInfoMap)) saleTokenInfoMap;

  function tokenSaleRegistration(
    address tokenAddress,
    uint256 tokenId,
    uint256 price
  ) public {
    require(IKIP17(tokenAddress).ownerOf(tokenId) == msg.sender, 'caller is not owner');

    uint256 tokenIndex = saleTokenList.push(SaleTokenInfo(msg.sender, tokenAddress, tokenId, price)) - 1;
    saleTokenInfoMap[tokenAddress][tokenId] = SaleTokenInfoMap(msg.sender, price, tokenIndex);

    _totalSaleCount = _totalSaleCount.add(1);
  }

  function getSaleTokenList() public view returns (SaleTokenInfo[] memory) {
    return saleTokenList;
  }

  function getTotalSaleCount() public view returns (uint256) {
    return _totalSaleCount;
  }

  function checkOwnerOf(address tokenAddress, uint256 tokenId) public view returns (address) {
    require(IKIP17(tokenAddress).ownerOf(tokenId) == msg.sender, 'caller is not owner');
    return IKIP17(tokenAddress).ownerOf(tokenId);
  }

  function checkCallerAddress() public view returns (address) {
    return msg.sender;
  }

  function getSaleTokenInfoMap(address tokenAddress, uint256 tokenId)
    public
    view
    returns (
      address,
      uint256,
      uint256
    )
  {
    return (
      saleTokenInfoMap[tokenAddress][tokenId].seller,
      saleTokenInfoMap[tokenAddress][tokenId].price,
      saleTokenInfoMap[tokenAddress][tokenId].tokenListIndex
    );
  }

  function _removeFromSaleTokenList(uint256 index) private {
    require(index < saleTokenList.length);

    delete saleTokenInfoMap[saleTokenList[index].tokenAddress][saleTokenList[index].tokenId];

    if (saleTokenList.length > 1) {
      saleTokenList[index] = saleTokenList[saleTokenList.length.sub(1)];
      saleTokenInfoMap[saleTokenList[index].tokenAddress][saleTokenList[index].tokenId].tokenListIndex = index;
    }

    saleTokenList.pop();
  }

  function buyToken(address tokenAddress, uint256 tokenId) public payable nonReentrant {
    // address payable _market = address(uint160(address(this)));
    address payable _seller = saleTokenInfoMap[tokenAddress][tokenId].seller;

    uint256 _price = saleTokenInfoMap[tokenAddress][tokenId].price.mul(10**18);
    uint256 _fee = _price.mul(3).div(100);

    require(IKIP17(tokenAddress).getApproved(tokenId) == address(this));
    require(msg.value == _price);

    _seller.transfer(_price.sub(_fee));
    // _market.transfer(_fee);

    IKIP17(tokenAddress).transferFrom(_seller, msg.sender, tokenId);

    _removeFromSaleTokenList(saleTokenInfoMap[tokenAddress][tokenId].tokenListIndex);

    _totalSaleCount = _totalSaleCount.sub(1);
  }
}