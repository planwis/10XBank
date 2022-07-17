// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.14;

import "./TenXBankBase.t.sol";

contract TenXBank_TestTransfer is TenXBankBaseTest {
  // event
  event Transfer(address _src, address _dest, uint256 _amount);

  /// @dev foundry's setUp method
  function setUp() public override {
    super.setUp();
  }

  function test_WhenAccoutIsNotExist() external {
    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");
    // non exists srcAccountName
    vm.expectRevert(TenXBank.TenXBank_NonExistentAccount.selector);
    tenXBank.transfer("Boby", "Alicia", 10e6);

    // non exists destAccountName
    vm.expectRevert(TenXBank.TenXBank_NonExistentAccount.selector);
    tenXBank.transfer("Alicia", "Boby", 10e6);
    vm.stopPrank();
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
    tenXBank.createAccount("Boby");
    vm.expectRevert(TenXBank.TenXBank_NotTheOwnerOfAccount.selector);
    tenXBank.transfer("Alicia", "Boby", 10e6);
  }

  function test_WhenSuccessfullyTransfer() external {
    // prepare scenario: Alice created "Alicia" account and deposit 10 USDT
    // And Bob created "Boby" account and deposit 20 USDT
    // mint 15 USDT to Alice and mint 20 USDT to Bob
    usdt.mint(ALICE, 15e6);
    usdt.mint(BOB, 20e6);

    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");

    // Alicia deposit 10 USDT
    usdt.approve(address(tenXBank), 10e6);
    tenXBank.deposit("Alicia", 10e6);

    changePrank(BOB);
    tenXBank.createAccount("Boby");

    // Boby deposit 20 USDT
    usdt.approve(address(tenXBank), 20e6);
    tenXBank.deposit("Boby", 20e6);

    uint256 aliciaUSDTBalanceBeforeTransfer = tenXBank.balanceOf(
      ALICE,
      "Alicia"
    );
    uint256 bobyUSDTBalanceBeforeTransfer = tenXBank.balanceOf(BOB, "Boby");
    uint256 totalPlatformFeeBeforeTransfer = tenXBank.totalPlatformFee();
    uint256 expectedFee = (10e6 * 1e16) / 1e18;

    // ALicia transfer 10 USDT to "Boby"
    changePrank(ALICE);
    vm.expectEmit(true, true, true, true, address(tenXBank));
    emit Transfer(ALICE, BOB, 10e6 - expectedFee);
    tenXBank.transfer("Alicia", "Boby", 10e6);
    vm.stopPrank();

    assertEq(
      tenXBank.balanceOf(ALICE, "Alicia"),
      aliciaUSDTBalanceBeforeTransfer - 10e6
    );

    assertEq(
      tenXBank.balanceOf(BOB, "Boby"),
      bobyUSDTBalanceBeforeTransfer + 10e6 - expectedFee
    );

    assertEq(
      tenXBank.totalPlatformFee(),
      totalPlatformFeeBeforeTransfer + expectedFee
    );
  }

  function test_WhenTransferExceedBalance() external {
     // prepare scenario: Alice created "Alicia" account and deposit 10 USDT
    // And Bob created "Boby" account and deposit 20 USDT
    // mint 15 USDT to Alice and mint 20 USDT to Bob
    usdt.mint(ALICE, 15e6);
    usdt.mint(BOB, 20e6);

    vm.startPrank(ALICE);
    tenXBank.createAccount("Alicia");

    // Alicia deposit 10 USDT
    usdt.approve(address(tenXBank), 10e6);
    tenXBank.deposit("Alicia", 10e6);

    changePrank(BOB);
    tenXBank.createAccount("Boby");

    // Boby deposit 20 USDT
    usdt.approve(address(tenXBank), 20e6);
    tenXBank.deposit("Boby", 20e6);

    // ALicia transfer 10 USDT to "Boby"
    changePrank(ALICE);
    vm.expectRevert(TenXBank.TenXBank_NotEnoughBalance.selector);
    tenXBank.transfer("Alicia", "Boby", 30e6);
    vm.stopPrank();
  }
}
