pragma solidity ^0.4.24;

import './Ownable.sol';
import './Event.sol';

contract TicketChain is Ownable{

    // Maps owners with their events.
    mapping( address => address[] ) public events;

    constructor() public Ownable(){
    }

    event EventCreated(address event_);

    function eventsCount(address owner) public view returns(uint) {
        return events[owner].length;
    }

    function createEvent(string name) public{
        address event_ = new Event(msg.sender, name);
        events[msg.sender].push(event_);
        emit EventCreated(event_);
    }

}

