pragma solidity ^0.5.6;
pragma experimental ABIEncoderV2;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 *
 * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
 * metering changes introduced in the Istanbul hardfork.
 */
contract ReentrancyGuard {
  bool private _notEntered;

  constructor() internal {
    // Storing an initial non-zero value makes deployment a bit more
    // expensive, but in exchange the refund on every call to nonReentrant
    // will be lower in amount. Since refunds are capped to a percetange of
    // the total transaction's gas, it is best to keep them low in cases
    // like this one, to increase the likelihood of the full refund coming
    // into effect.
    _notEntered = true;
  }

  /**
   * @dev Prevents a contract from calling itself, directly or indirectly.
   * Calling a `nonReentrant` function from another `nonReentrant`
   * function is not supported. It is possible to prevent this from happening
   * by making the `nonReentrant` function external, and make it call a
   * `private` function that does the actual work.
   */
  modifier nonReentrant() {
    // On the first call to nonReentrant, _notEntered will be true
    require(_notEntered, 'ReentrancyGuard: reentrant call');

    // Any calls to nonReentrant after this point will fail
    _notEntered = false;

    _;

    // By storing the original value once again, a refund is triggered (see
    // https://eips.ethereum.org/EIPS/eip-2200)
    _notEntered = true;
  }
}

/**
 * @dev Interface of the KIP-13 standard, as defined in the
 * [KIP-13](http://kips.klaytn.com/KIPs/kip-13-interface_query_standard).
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others.
 *
 * For an implementation, see `KIP13`.
 */
interface IKIP13 {
  /**
   * @dev Returns true if this contract implements the interface defined by
   * `interfaceId`. See the corresponding
   * [KIP-13 section](http://kips.klaytn.com/KIPs/kip-13-interface_query_standard#how-interface-identifiers-are-defined)
   * to learn more about how these ids are created.
   *
   * This function call must use less than 30 000 gas.
   */
  function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an KIP17 compliant contract.
 */
contract IKIP17 is IKIP13 {
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
  event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

  /**
   * @dev Returns the number of NFTs in `owner`'s account.
   */
  function balanceOf(address owner) public view returns (uint256 balance);

  /**
   * @dev Returns the owner of the NFT specified by `tokenId`.
   */
  function ownerOf(uint256 tokenId) public view returns (address owner);

  /**
   * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
   * another (`to`).
   *
   * Requirements:
   * - `from`, `to` cannot be zero.
   * - `tokenId` must be owned by `from`.
   * - If the caller is not `from`, it must be have been allowed to move this
   * NFT by either `approve` or `setApproveForAll`.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public;

  /**
   * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
   * another (`to`).
   *
   * Requirements:
   * - If the caller is not `from`, it must be approved to move this NFT by
   * either `approve` or `setApproveForAll`.
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public;

  function approve(address to, uint256 tokenId) public;

  function getApproved(uint256 tokenId) public view returns (address operator);

  function setApprovalForAll(address operator, bool _approved) public;

  function isApprovedForAll(address owner, address operator) public view returns (bool);

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) public;
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, 'SafeMath: addition overflow');

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, 'SafeMath: subtraction overflow');
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   *
   * _Available since v2.4.0._
   */
  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, 'SafeMath: multiplication overflow');

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, 'SafeMath: division by zero');
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   *
   * _Available since v2.4.0._
   */
  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, 'SafeMath: modulo by zero');
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   *
   * _Available since v2.4.0._
   */
  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

/**
 * @dev Collection of functions related to the address type,
 */
library Address {
  /**
   * @dev Returns true if `account` is a contract.
   *
   * This test is non-exhaustive, and there may be false-negatives: during the
   * execution of a contract's constructor, its address will be reported as
   * not containing a contract.
   *
   * > It is unsafe to assume that an address for which this function returns
   * false is an externally-owned account (EOA) and not a contract.
   */
  function isContract(address account) internal view returns (bool) {
    // This method relies in extcodesize, which returns 0 for contracts in
    // construction, since the code is only stored at the end of the
    // constructor execution.

    uint256 size;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      size := extcodesize(account)
    }
    return size > 0;
  }
}

/**
 * import 이슈
 * https://stackoverflow.com/questions/67321111/file-import-callback-not-supported
 */
contract Market is IKIP17, ReentrancyGuard {
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
