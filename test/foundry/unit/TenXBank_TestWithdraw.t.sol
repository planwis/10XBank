// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.14;

import "./TenXBankBase.t.sol";

contract TenXBank_TestWithdraw is TenXBankBaseTest {
  // event
  event Withdraw(address _accountAddress, uint256 _amount);

  /// @dev foundry's setUp method
  function setUp() public override {
    super.setUp();
  }

  function test_WhenAccoutIsNotExist() external {
    vm.prank(ALICE);
    vm.expectRevert(TenXBank.TenXBank_NonExistentAccount.selector);
    tenXBank.withdraw("Alicia", 1 ether);
  }

  function test_WhenNotOwnerOfAccount() external {
    // prepare scenario: Alice created "Alicia" account and deposit 10 USDT
    // mint 15 USDT to alice
    usdt.mint(ALICE, 15e6);

    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");

    // Alice deposit 10 USDT
    usdt.approve(address(tenXBank), 10e6);
    tenXBank.deposit("Alicia", 10e6);

    // Bob withdraw 10 USDT from "Alicia"
    changePrank(BOB);
    vm.expectRevert(TenXBank.TenXBank_NotTheOwnerOfAccount.selector);
    tenXBank.withdraw("Alicia", 10e6);
  }

  function test_WhenSuccessfullyWithdraw() external {
    // prepare scenario: Alice created "Alicia" account and deposit 10 USDT
    // mint 15 USDT to alice
    usdt.mint(ALICE, 15e6);

    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");

    // Alice deposit 10 USDT
    usdt.approve(address(tenXBank), 10e6);
    tenXBank.deposit("Alicia", 10e6);

    uint256 aliceUSDTBalanceBeforeWithdraw = usdt.balanceOf(ALICE);
    uint256 tenXBankUSDTBalanceBeforeWithdraw = usdt.balanceOf(
      address(tenXBank)
    );

    // ALice withdraw 5 USDT from "Alicia"
    vm.expectEmit(true, true, true, true, address(tenXBank));
    emit Withdraw(ALICE, 5e6);
    tenXBank.withdraw("Alicia", 5e6);
    vm.stopPrank();

    assertEq(usdt.balanceOf(ALICE), aliceUSDTBalanceBeforeWithdraw + 5e6);
    assertEq(
      usdt.balanceOf(address(tenXBank)),
      tenXBankUSDTBalanceBeforeWithdraw - 5e6
    );

    assertEq(tenXBank.balanceOf(ALICE, "Alicia"), 10e6 - 5e6);
  }

  function test_WhenWithdrawExceedBalance() external {
    // prepare scenario: Alice created "Alicia" account and deposit 10 USDT
    // mint 15 USDT to alice
    usdt.mint(ALICE, 15e6);

    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");

    // Alice deposit 10 USDT
    usdt.approve(address(tenXBank), 10e6);
    tenXBank.deposit("Alicia", 10e6);

    // ALice withdraw 5 USDT from "Alicia"
    vm.expectRevert(TenXBank.TenXBank_NotEnoughBalance.selector);
    tenXBank.withdraw("Alicia", 15e6);
    vm.stopPrank();
  }
}
