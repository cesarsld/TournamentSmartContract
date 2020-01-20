pragma solidity ^0.5.11;

contract TournamentAccessControl
{
	address payable public owner;
	address public organiser2;
	address public organiser3;

	constructor() public
	{
		owner = msg.sender;
	}

	modifier isOwner()
	{
		require(msg.sender == owner,
		"Sender not authorised to access.");
		_;
	}

	modifier isTournamentOrganiser()
	{
		require(msg.sender == owner ||
				msg.sender == organiser2 ||
				msg.sender == organiser3,
				"Sender not authorised to access.");
		_;
	}

	function setNewOwner(address payable _newOwner) external isOwner
	{
		owner = _newOwner;
	}

	function setNewOrganiser2(address _newOrganiser2) external isOwner
	{
		organiser2 = _newOrganiser2;
	}

	function setNewOrganiser3(address _newOrganiser3) external isOwner
	{
		organiser2 = _newOrganiser3;
	}
}