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
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract IERC721Receiver {
  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safeTransfer`. This function MUST return the function selector,
   * otherwise the caller will revert the transaction. The selector to be
   * returned can be obtained as `this.onERC721Received.selector`. This
   * function MAY throw to revert and reject the transfer.
   * Note: the ERC721 contract address is always the message sender.
   * @param operator The address which called `safeTransferFrom` function
   * @param from The address which previously owned the token
   * @param tokenId The NFT identifier which is being transferred
   * @param data Additional data with no specified format
   * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes memory data
  ) public returns (bytes4);
}

/**
 * @title KIP17 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from KIP17 asset contracts.
 * @dev see http://kips.klaytn.com/KIPs/kip-17-non_fungible_token
 */
contract IKIP17Receiver {
  /**
   * @notice Handle the receipt of an NFT
   * @dev The KIP17 smart contract calls this function on the recipient
   * after a `safeTransfer`. This function MUST return the function selector,
   * otherwise the caller will revert the transaction. The selector to be
   * returned can be obtained as `this.onKIP17Received.selector`. This
   * function MAY throw to revert and reject the transfer.
   * Note: the KIP17 contract address is always the message sender.
   * @param operator The address which called `safeTransferFrom` function
   * @param from The address which previously owned the token
   * @param tokenId The NFT identifier which is being transferred
   * @param data Additional data with no specified format
   * @return bytes4 `bytes4(keccak256("onKIP17Received(address,address,uint256,bytes)"))`
   */
  function onKIP17Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes memory data
  ) public returns (bytes4);
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
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
 * directly accessed.
 */
library Counters {
  using SafeMath for uint256;

  struct Counter {
    // This variable should never be directly accessed by users of the library: interactions must be restricted to
    // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
    // this feature: see https://github.com/ethereum/solidity/issues/4637
    uint256 _value; // default: 0
  }

  function current(Counter storage counter) internal view returns (uint256) {
    return counter._value;
  }

  function increment(Counter storage counter) internal {
    counter._value += 1;
  }

  function decrement(Counter storage counter) internal {
    counter._value = counter._value.sub(1);
  }
}

/**
 * @dev Implementation of the `IKIP13` interface.
 *
 * Contracts may inherit from this and call `_registerInterface` to declare
 * their support of an interface.
 */
contract KIP13 is IKIP13 {
  /*
   * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
   */
  bytes4 private constant _INTERFACE_ID_KIP13 = 0x01ffc9a7;

  /**
   * @dev Mapping of interface ids to whether or not it's supported.
   */
  mapping(bytes4 => bool) private _supportedInterfaces;

  constructor() internal {
    // Derived contracts need only register support for their own interfaces,
    // we register support for KIP13 itself here
    _registerInterface(_INTERFACE_ID_KIP13);
  }

  /**
   * @dev See `IKIP13.supportsInterface`.
   *
   * Time complexity O(1), guaranteed to always use less than 30 000 gas.
   */
  function supportsInterface(bytes4 interfaceId) external view returns (bool) {
    return _supportedInterfaces[interfaceId];
  }

  /**
   * @dev Registers the contract as an implementer of the interface defined by
   * `interfaceId`. Support of the actual KIP13 interface is automatic and
   * registering its interface id is not required.
   *
   * See `IKIP13.supportsInterface`.
   *
   * Requirements:
   *
   * - `interfaceId` cannot be the KIP13 invalid interface (`0xffffffff`).
   */
  function _registerInterface(bytes4 interfaceId) internal {
    require(interfaceId != 0xffffffff, 'KIP13: invalid interface id');
    _supportedInterfaces[interfaceId] = true;
  }
}

/**
 * @title KIP17 Non-Fungible Token Standard basic implementation
 * @dev see http://kips.klaytn.com/KIPs/kip-17-non_fungible_token
 */
contract KIP17 is KIP13, IKIP17 {
  using SafeMath for uint256;
  using Address for address;
  using Counters for Counters.Counter;

  // Equals to `bytes4(keccak256("onKIP17Received(address,address,uint256,bytes)"))`
  // which can be also obtained as `IKIP17Receiver(0).onKIP17Received.selector`
  bytes4 private constant _KIP17_RECEIVED = 0x6745782b;

  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
  // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
  bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

  // Mapping from token ID to owner
  mapping(uint256 => address) private _tokenOwner;

  // Mapping from token ID to approved address
  mapping(uint256 => address) private _tokenApprovals;

  // Mapping from owner to number of owned token
  mapping(address => Counters.Counter) private _ownedTokensCount;

  // Mapping from owner to operator approvals
  mapping(address => mapping(address => bool)) private _operatorApprovals;

  /*
   *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
   *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
   *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
   *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
   *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
   *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
   *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
   *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
   *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
   *
   *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
   *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
   */
  bytes4 private constant _INTERFACE_ID_KIP17 = 0x80ac58cd;

  constructor() public {
    // register the supported interfaces to conform to KIP17 via KIP13
    _registerInterface(_INTERFACE_ID_KIP17);
  }

  /**
   * @dev Gets the balance of the specified address.
   * @param owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
  function balanceOf(address owner) public view returns (uint256) {
    require(owner != address(0), 'KIP17: balance query for the zero address');

    return _ownedTokensCount[owner].current();
  }

  /**
   * @dev Gets the owner of the specified token ID.
   * @param tokenId uint256 ID of the token to query the owner of
   * @return address currently marked as the owner of the given token ID
   */
  function ownerOf(uint256 tokenId) public view returns (address) {
    address owner = _tokenOwner[tokenId];
    require(owner != address(0), 'KIP17: owner query for nonexistent token');

    return owner;
  }

  /**
   * @dev Approves another address to transfer the given token ID
   * The zero address indicates there is no approved address.
   * There can only be one approved address per token at a given time.
   * Can only be called by the token owner or an approved operator.
   * @param to address to be approved for the given token ID
   * @param tokenId uint256 ID of the token to be approved
   */
  function approve(address to, uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(to != owner, 'KIP17: approval to current owner');

    require(
      msg.sender == owner || isApprovedForAll(owner, msg.sender),
      'KIP17: approve caller is not owner nor approved for all'
    );

    _tokenApprovals[tokenId] = to;
    emit Approval(owner, to, tokenId);
  }

  /**
   * @dev Gets the approved address for a token ID, or zero if no address set
   * Reverts if the token ID does not exist.
   * @param tokenId uint256 ID of the token to query the approval of
   * @return address currently approved for the given token ID
   */
  function getApproved(uint256 tokenId) public view returns (address) {
    require(_exists(tokenId), 'KIP17: approved query for nonexistent token');

    return _tokenApprovals[tokenId];
  }

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf.
   * @param to operator address to set the approval
   * @param approved representing the status of the approval to be set
   */
  function setApprovalForAll(address to, bool approved) public {
    require(to != msg.sender, 'KIP17: approve to caller');

    _operatorApprovals[msg.sender][to] = approved;
    emit ApprovalForAll(msg.sender, to, approved);
  }

  /**
   * @dev Tells whether an operator is approved by a given owner.
   * @param owner owner address which you want to query the approval of
   * @param operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(address owner, address operator) public view returns (bool) {
    return _operatorApprovals[owner][operator];
  }

  /**
   * @dev Transfers the ownership of a given token ID to another address.
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
   * Requires the msg.sender to be the owner, approved, or operator.
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public {
    //solhint-disable-next-line max-line-length
    require(_isApprovedOrOwner(msg.sender, tokenId), 'KIP17: transfer caller is not owner nor approved');

    _transferFrom(from, to, tokenId);
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onKIP17Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onKIP17Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   * Requires the msg.sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public {
    safeTransferFrom(from, to, tokenId, '');
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onKIP17Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onKIP17Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   * Requires the msg.sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
   * @param _data bytes data to send along with a safe transfer check
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) public {
    transferFrom(from, to, tokenId);
    require(_checkOnKIP17Received(from, to, tokenId, _data), 'KIP17: transfer to non KIP17Receiver implementer');
  }

  /**
   * @dev Returns whether the specified token exists.
   * @param tokenId uint256 ID of the token to query the existence of
   * @return bool whether the token exists
   */
  function _exists(uint256 tokenId) internal view returns (bool) {
    address owner = _tokenOwner[tokenId];
    return owner != address(0);
  }

  /**
   * @dev Returns whether the given spender can transfer a given token ID.
   * @param spender address of the spender to query
   * @param tokenId uint256 ID of the token to be transferred
   * @return bool whether the msg.sender is approved for the given token ID,
   * is an operator of the owner, or is the owner of the token
   */
  function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
    require(_exists(tokenId), 'KIP17: operator query for nonexistent token');
    address owner = ownerOf(tokenId);
    return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
  }

  /**
   * @dev Internal function to mint a new token.
   * Reverts if the given token ID already exists.
   * @param to The address that will own the minted token
   * @param tokenId uint256 ID of the token to be minted
   */
  function _mint(address to, uint256 tokenId) internal {
    require(to != address(0), 'KIP17: mint to the zero address');
    require(!_exists(tokenId), 'KIP17: token already minted');

    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to].increment();

    emit Transfer(address(0), to, tokenId);
  }

  /**
   * @dev Internal function to burn a specific token.
   * Reverts if the token does not exist.
   * Deprecated, use _burn(uint256) instead.
   * @param owner owner of the token to burn
   * @param tokenId uint256 ID of the token being burned
   */
  function _burn(address owner, uint256 tokenId) internal {
    require(ownerOf(tokenId) == owner, 'KIP17: burn of token that is not own');

    _clearApproval(tokenId);

    _ownedTokensCount[owner].decrement();
    _tokenOwner[tokenId] = address(0);

    emit Transfer(owner, address(0), tokenId);
  }

  /**
   * @dev Internal function to burn a specific token.
   * Reverts if the token does not exist.
   * @param tokenId uint256 ID of the token being burned
   */
  function _burn(uint256 tokenId) internal {
    _burn(ownerOf(tokenId), tokenId);
  }

  /**
   * @dev Internal function to transfer ownership of a given token ID to another address.
   * As opposed to transferFrom, this imposes no restrictions on msg.sender.
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param tokenId uint256 ID of the token to be transferred
   */
  function _transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) internal {
    require(ownerOf(tokenId) == from, 'KIP17: transfer of token that is not own');
    require(to != address(0), 'KIP17: transfer to the zero address');

    _clearApproval(tokenId);

    _ownedTokensCount[from].decrement();
    _ownedTokensCount[to].increment();

    _tokenOwner[tokenId] = to;

    emit Transfer(from, to, tokenId);
  }

  /**
   * @dev Internal function to invoke `onKIP17Received` on a target address.
   * The call is not executed if the target address is not a contract.
   *
   * This function is deprecated.
   * @param from address representing the previous owner of the given token ID
   * @param to target address that will receive the tokens
   * @param tokenId uint256 ID of the token to be transferred
   * @param _data bytes optional data to send along with the call
   * @return bool whether the call correctly returned the expected magic value
   */
  function _checkOnKIP17Received(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) internal returns (bool) {
    bool success;
    bytes memory returndata;

    if (!to.isContract()) {
      return true;
    }

    // Logic for compatibility with ERC721.
    (success, returndata) = to.call(abi.encodeWithSelector(_ERC721_RECEIVED, msg.sender, from, tokenId, _data));
    if (returndata.length != 0 && abi.decode(returndata, (bytes4)) == _ERC721_RECEIVED) {
      return true;
    }

    (success, returndata) = to.call(abi.encodeWithSelector(_KIP17_RECEIVED, msg.sender, from, tokenId, _data));
    if (returndata.length != 0 && abi.decode(returndata, (bytes4)) == _KIP17_RECEIVED) {
      return true;
    }

    return false;
  }

  /**
   * @dev Private function to clear current approval of a given token ID.
   * @param tokenId uint256 ID of the token to be transferred
   */
  function _clearApproval(uint256 tokenId) private {
    if (_tokenApprovals[tokenId] != address(0)) {
      _tokenApprovals[tokenId] = address(0);
    }
  }
}

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
