// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract TenXBank is OwnableUpgradeable, ReentrancyGuardUpgradeable {
  using SafeERC20Upgradeable for IERC20Upgradeable;
  using SafeMathUpgradeable for uint256;

  /// @dev events
  event Deposit(address _accountAddress, uint256 _amount);
  event Withdraw(address _accountAddress, uint256 _amount);

  /// @dev custom errors
  error TenXBank_TransferFeeGreaterThanOneHundredPercent();
  error TenXBank_InvalidERC20Address();
  error TenXBank_NonExistentAccount();
  error TenXBank_InvalidPlatformFeeWithdrawalAmount();
  error TenXBank_NotEnoughBalance();

  mapping(string => address) public owners;
  mapping(address => mapping(string => uint256)) public balanceOf;
  mapping(address => string[]) private accounts;
  uint256 public transferFee;
  uint256 private totalPlatformFee;
  IERC20Upgradeable public erc20Token;

  function initialize(uint256 _transferFee, address _erc20Token)
    external
    initializer
  {
    OwnableUpgradeable.__Ownable_init();
    ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

    if (_transferFee > 1e18)
      revert TenXBank_TransferFeeGreaterThanOneHundredPercent();

    if (_erc20Token == address(0)) revert TenXBank_InvalidERC20Address();

    transferFee = _transferFee;
    erc20Token = IERC20Upgradeable(_erc20Token);
  }

  // deposit safetranserfrom
  function deposit(string calldata _accountName, uint256 _amount)
    external
    nonReentrant
  {
    address accountAddress = owners[_accountName];

    if (accountAddress == address(0)) revert TenXBank_NonExistentAccount();

    balanceOf[accountAddress][_accountName] += _amount;

    erc20Token.safeTransferFrom(msg.sender, address(this), _amount);

    emit Deposit(accountAddress, _amount);
  }

  // withdraw
  function withdraw(string calldata _accountName, uint256 _amount)
    external
    nonReentrant
  {
    address accountAddress = owners[_accountName];

    if (accountAddress == address(0)) revert TenXBank_NonExistentAccount();
    if (_amount > balanceOf[msg.sender][_accountName])
      revert TenXBank_NotEnoughBalance();

    balanceOf[accountAddress][_accountName] -= _amount;

    erc20Token.safeTransfer(msg.sender, _amount);

    emit Withdraw(accountAddress, _amount);
  }

  // tranfer
  function tranfer(
    string calldata _srcAccountName,
    string calldata _destAccountName,
    uint256 _amount
  ) external nonReentrant {
    address srcAccountAddress = owners[_srcAccountName];
    address destAccountAddress = owners[_destAccountName];

    if (srcAccountAddress == address(0) || destAccountAddress == address(0))
      revert TenXBank_NonExistentAccount();
    if (_amount > balanceOf[msg.sender][_srcAccountName])
      revert TenXBank_NotEnoughBalance();

    balanceOf[srcAccountAddress][_srcAccountName] -= _amount;
    uint256 fee = (_amount * transferFee) / 1e18;
    totalPlatformFee += fee;
    balanceOf[destAccountAddress][_destAccountName] += _amount - fee;
  }

  // withdrawPlatformFee
  function withdrawPlatformFee(uint256 _amount) external onlyOwner {
    if (_amount < 0 || _amount > totalPlatformFee)
      revert TenXBank_InvalidPlatformFeeWithdrawalAmount();

    totalPlatformFee -= _amount;

    erc20Token.safeTransfer(msg.sender, _amount);
  }

  // crate account
  function crateAccount(string calldata _accountName) external {
    owners[_accountName] = msg.sender;
    accounts[msg.sender].push(_accountName);
  }

  function getAccounts(address _accountAddress)
    external
    view
    returns (string[] memory)
  {
    return accounts[_accountAddress];
  }
}
