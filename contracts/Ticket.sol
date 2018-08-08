pragma solidity ^0.4.24;

import './ArrayUtil.sol';

library TicketLib{

    using ArrayUtil for uint[];
    event TicketSold(address indexed event_, uint indexed ticketID);

    struct Ticket {
        uint ID;
        address owner;
        uint locationID;
        bool isForSale;
        uint price;
        }

    function sell(Ticket storage self,
        uint[] storage ticketsIDsForSale) public {

        emit TicketSold(address(this), self.ID);
        require(self.isForSale, "A ticket specified is not for sale.");
        self.owner = msg.sender;
        removeFromSale(self, ticketsIDsForSale);

    }

    function removeFromSale(Ticket storage self, uint[] storage ticketsIDsForSale) public {
        require(self.owner == msg.sender,
            "Only the owner of the ticket can remove the ticket from sale.");
        require(self.isForSale, "A ticket specified is not for sale.");
        self.isForSale = false;
        ticketsIDsForSale.removeByValue(self.ID);
    }


}

