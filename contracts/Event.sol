pragma solidity ^0.4.24;

import './Ownable.sol';
import './EventLib.sol';

contract Event is Ownable{

    using EventLib for EventLib.Event;

    EventLib.Event public event_;

    constructor(address _owner, string _name) public Ownable() {
        owner = _owner;
        event_.name = _name;
    }

    function pendingTicketsToEmit(uint locationID) view public returns(uint){
        return event_.pendingTicketsToEmit(locationID);
    }

    function createTickets(uint locationID, uint quantity, bool forSale)
        onlyOwner public {
        event_.createTickets(locationID, quantity, forSale);
    }

    function addLocation(string name, uint capacity,
        uint price)
        onlyOwner public {
        event_.addLocation(name, capacity, price);
    }

    function changeLocation(uint locationID, string name,
        uint capacity, uint price)
        onlyOwner public {
        event_.changeLocation(locationID, name, capacity, price);
    }

    function buyLocation(uint locationID,
        uint quantity) public payable{
        event_.buyLocation(locationID, quantity);
    }

    function buyLocations(uint[] locationIDs,
        uint[] locationQuantities) public payable{
        event_.buyLocations(locationIDs, locationQuantities);
    }

    function removeTicketFromSale(uint ticketID) public {
        event_.removeTicketFromSale(ticketID);
    }

    function buyTickets(uint[] ticketsIDs) public payable{
        event_.buyTickets(ticketsIDs);
    }

    function getTicketsValue(uint[] ticketsIDs) view public returns(uint value){
        return event_.getTicketsValue(ticketsIDs);
    }

    function requireSameLegth(uint[] a, uint[] b, string message) internal pure{
        require(a.length == b.length, message);
    }

    function hasTicketsForSale(uint locationID, uint quantity) public view returns(bool available){
        return event_.hasTicketsForSale(locationID, quantity);
    }

    function hasTicketsForSale(uint[] locationIDs,
        uint[] locationQuantities) public view returns(bool available){
        return event_.hasTicketsForSale(locationIDs, locationQuantities);
    }

    function selectTickets(uint[] locationIDs,
        uint[] locationQuantities) public view returns(uint[] ticketsIDs){
        return event_.selectTickets(locationIDs, locationQuantities);
    }

    function selectTickets(uint locationID, uint quantity) public view returns(uint[] ticketsIDs) {
        return event_.selectTickets(locationID, quantity);
    }

}


