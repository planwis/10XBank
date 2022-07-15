// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.14;

import "../unit/base/BaseTest.sol";
import "../unit/mock/MockERC20.sol";
import "../../../contracts/TenXBank.sol";

abstract contract TenXBankBaseTest is BaseTest {
  MockERC20 internal usdt;
  TenXBank internal tenXBank;

  /// @dev Foundry's setUp method
  function setUp() public virtual {
    usdt = _setupFakeERC20("Tether", "USDT");

    // 1 percent of 1e18 is 1e16
    tenXBank = _setupTenXBank(1e16, address(usdt));
  }

  // utils functions

  function _setupTenXBank(uint256 _transferFee, address _erc20Token)
    internal
    returns (TenXBank)
  {
    TenXBank _impl = new TenXBank();

    TransparentUpgradeableProxy _proxy = new TransparentUpgradeableProxy(
      address(_impl),
      address(proxyAdmin),
      abi.encodeWithSelector(
        bytes4(keccak256("initialize(uint256,address)")),
        _transferFee,
        _erc20Token
      )
    );

    return TenXBank(payable(_proxy));
  }

  function _setupFakeERC20(string memory _name, string memory _symbol)
    internal
    returns (MockERC20)
  {
    MockERC20 _impl = new MockERC20();
    TransparentUpgradeableProxy _proxy = new TransparentUpgradeableProxy(
      address(_impl),
      address(proxyAdmin),
      abi.encodeWithSelector(
        bytes4(keccak256("initialize(string,string)")),
        _name,
        _symbol
      )
    );
    return MockERC20(payable(_proxy));
  }
}
