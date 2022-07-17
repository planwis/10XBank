// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.14;

import "./TenXBankBase.t.sol";

contract TenXBank_TestCreateAccount is TenXBankBaseTest {
  /// @dev foundry's setUp method
  function setUp() public override {
    super.setUp();
  }

  function test_WhenAccoutIsNotExist() external {
    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");

    assertEq(tenXBank.owners("Alicia"), ALICE);

    string[] memory expectedAccountNames = new string[](1);
    expectedAccountNames[0] = "Alicia";

    string[] memory actualAccountNames = tenXBank.getAccounts(ALICE);

    for (uint256 i = 0; i < actualAccountNames.length; i++) {
      assertEq(actualAccountNames[i], expectedAccountNames[i]);
    }
  }

  function test_WhenAccoutIsExist() external {
    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");

    vm.expectRevert(TenXBank.TenXBank_AccountNameAlreadyExists.selector);
    tenXBank.createAccount("Alicia");

    vm.stopPrank();
  }

  function test_WhenAddMultipleAccounts() external {
    string[3] memory AccountsName = ["Alicia", "Alicy", "Alison"];

    vm.startPrank(ALICE);
    for (uint256 i = 0; i < AccountsName.length; i++) {
      tenXBank.createAccount(AccountsName[i]);
    }

    string[] memory actualAccountNames = tenXBank.getAccounts(ALICE);

    for (uint256 i = 0; i < actualAccountNames.length; i++) {
      assertEq(actualAccountNames[i], AccountsName[i]);
    }
    vm.stopPrank();
  }
}
