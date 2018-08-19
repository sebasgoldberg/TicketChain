pragma solidity ^0.4.24;

library TicketLib{

    event TicketSold(address indexed event_, uint indexed ticketID);

    struct Ticket {
        uint ID;
        address owner;
        uint locationID;
        bool isForSale;
        uint price;
        }

    function sell(Ticket storage self) public {
        require(self.isForSale, "A ticket specified is not for sale.");
        emit TicketSold(address(this), self.ID);
        self.owner = msg.sender;
    }

    function removeFromSale(Ticket storage self) public {
        require(self.owner == msg.sender,
            "Only the owner of the ticket can remove the ticket from sale.");
        require(self.isForSale, "A ticket specified is not for sale.");
        self.isForSale = false;
    }


}

