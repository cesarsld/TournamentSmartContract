pragma solidity ^0.5.11;

import "./TournamentAccessControl.sol";

contract TournamentOrganiser is TournamentAccessControl
{
	uint256	entryFee;
	bool	ongoingTournament;
	uint256	bank;
	uint256	cut;
	uint256	firstCut;
	uint256	secondCut;
	uint256	thirdCut;

	constructor () public
	{
		entryFee = 0.05 ether;
		ongoingTournament = false;
		cut = 100;
		firstCut = 6000;
		secondCut = 2500;
		thirdCut = 1400;
		bank = 0;
	}

	event PlayerRegistered(address player);

	modifier isOngoing()
	{
		require(ongoingTournament == true,
		"Error, no ongoing tournaments currently.");
		_;
	}

	modifier CutIsHundred()
	{
		require(cut + firstCut + secondCut + thirdCut == 10000,
		"Cut percentage sum is not 100%.");
		_;
	}

	function CreateTournament() public isTournamentOrganiser
	{
		ongoingTournament = true;
	}

	function SendRewardsToWinners(
		address payable _first,
		address payable _second,
		address payable _third) public isTournamentOrganiser CutIsHundred
	{
		uint256 firstReward;
		uint256 secondReward;
		uint256 thirdReward;
		firstReward = (address(this).balance - bank) / 10000 * firstCut;
		secondReward = (address(this).balance - bank) / 10000 * secondCut;
		thirdReward = (address(this).balance - bank) / 10000 * thirdCut;
		_first.transfer(firstReward);
		_second.transfer(secondReward);
		_third.transfer(thirdReward);
		bank = address(this).balance;
		ongoingTournament = false;
	}

	function SetEntryFee(uint256 _fee) public isTournamentOrganiser
	{
		require(ongoingTournament == false,
		"Ongoing tournament. Cannot set fee now.");
		entryFee = _fee;
	}

	function RegisterToTournament() public payable isOngoing
	{
		require (msg.value == entryFee, "Error, wrong entry free sent.");
		emit PlayerRegistered(msg.sender);
	}

	function SetCuts(uint32 _first, uint32 _second, uint32 _third, uint32 _cut) public isOwner
	{
		require(ongoingTournament == false,
		"Tournament ongoing, you can't modify cuts.");
		require(_first + _second + _third + _cut == 10000,
		"Error, cut sum not equal to 100%.");
		firstCut = _first;
		secondCut = _second;
		thirdCut = _third;
		cut = _cut;
	}

	function withdrawBalance() external isOwner
	{
		require(ongoingTournament == false,
		"Tournament ongoing, you can't withdraw funds.");
		owner.transfer(address(this).balance);
	}
}