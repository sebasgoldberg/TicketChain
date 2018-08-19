pragma solidity ^0.4.24;

import './TicketLib.sol';
import './ArrayUtil.sol';

library LocationLib{

    struct Location {
        uint ID;
        string name;
        uint ticketsEmited;
        uint capacity;
        uint basePrice; // in wei
        uint[] ticketsIDsForSale;
        }

    using TicketLib for TicketLib.Ticket;
    using ArrayUtil for uint[];

    event LocationChanged(address indexed event_, uint indexed locationID);

    function init(Location storage self, uint ID, string name, uint capacity, uint basePrice) public{
        self.ID = ID;
        self.name = name;
        self.ticketsEmited = 0;
        self.capacity = capacity;
        self.basePrice = basePrice;
    }

    function addTicket(Location storage self, TicketLib.Ticket storage ticket) public{
        self.ticketsEmited++;
        if (ticket.isForSale)
            self.ticketsIDsForSale.push(ticket.ID);
    }

    function pendingTicketsToEmit(Location storage self) view public returns(uint){
        return (self.capacity - self.ticketsEmited);
    }

    function change(Location storage self, string name,
        uint capacity, uint price)
        public {

        emit LocationChanged(address(this), self.ID);

        require( capacity >= self.ticketsEmited, "The capacity should be greather than tickets emitted." );

        self.name = name;
        self.capacity = capacity;
        self.basePrice = price;
    }
 
    function ticketsForSale(Location storage self) public view returns(uint){
        return self.ticketsIDsForSale.length;
    }
 
    function hasTicketsForSale(Location storage self, uint quantity) public view returns(bool){
        return ticketsForSale(self)>=quantity;
    }

    function selectTickets(Location storage self, uint quantity) public view returns(uint[] ticketsIDs) {
        require(hasTicketsForSale(self, quantity),
            "The are not enough tickets for the required quantity");
        uint from = self.ticketsIDsForSale.length - quantity;
        uint length = self.ticketsIDsForSale.length;
        ticketsIDs = new uint[](quantity);
        uint k = 0;
        for (uint i=from; i<length; i++){
            ticketsIDs[k] = self.ticketsIDsForSale[i];
            k++;
        }
    }

    function sellTicket(Location storage self, TicketLib.Ticket storage ticket) public {
        ticket.sell();
        removeTicketFromSale(self, ticket);
    }

    function removeTicketFromSale(Location storage self, TicketLib.Ticket storage ticket) public{
        ticket.removeFromSale();
        self.ticketsIDsForSale.removeByValue(ticket.ID);
    }

}
