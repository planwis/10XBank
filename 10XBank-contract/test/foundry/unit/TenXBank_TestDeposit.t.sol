// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.14;

import "./TenXBankBase.t.sol";

contract TenXBank_TestDeposit is TenXBankBaseTest {
  // event
  event Deposit(address _accountAddress, uint256 _amount);

  /// @dev foundry's setUp method
  function setUp() public override {
    super.setUp();
  }

  function test_WhenAccoutIsNotExist() external {
    vm.prank(ALICE);
    vm.expectRevert(TenXBank.TenXBank_NonExistentAccount.selector);
    tenXBank.deposit("Boby", 1 ether);
  }

  function test_WhenSuccessfullyDeposit() external {
    // mint 15 USDT to alice
    usdt.mint(ALICE, 15e6);

    uint256 aliceUSDTBalanceBeforeDeposit = usdt.balanceOf(ALICE);
    uint256 tenXBankUSDTBalanceBeforeDeposit = usdt.balanceOf(
      address(tenXBank)
    );

    vm.startPrank(ALICE);

    tenXBank.createAccount("Alicia");
    assertEq(tenXBank.balanceOf(ALICE, "Alicia"), 0);

    // Alice deposit 10 USDT
    usdt.approve(address(tenXBank), 10e6);
    vm.expectEmit(true, true, true, true, address(tenXBank));
    emit Deposit(ALICE, 10e6);
    tenXBank.deposit("Alicia", 10e6);

    vm.stopPrank();

    assertEq(usdt.balanceOf(ALICE), aliceUSDTBalanceBeforeDeposit - 10e6);
    assertEq(
      usdt.balanceOf(address(tenXBank)),
      tenXBankUSDTBalanceBeforeDeposit + 10e6
    );

    assertEq(tenXBank.balanceOf(ALICE, "Alicia"), 10e6);
  }

  function test_WhenDepositAmountIsGraterThanCurrentBalance() external {
    // mint 15 USDT to alice
    usdt.mint(ALICE, 15e6);

    vm.startPrank(ALICE);

    tenXBank.createAccount("Alicia");

    // Alice deposit 20 USDT
    usdt.approve(address(tenXBank), 20e6);
    vm.expectRevert(abi.encodePacked("ERC20: transfer amount exceeds balance"));
    tenXBank.deposit("Alicia", 20e6);
    vm.stopPrank();
  }
}
