pragma solidity ^0.4.24;

import './LocationLib.sol';
import './TicketLib.sol';
import './ArrayUtil.sol';

library EventLib{

    struct Event{
        string name;
        LocationLib.Location[] locations;
        TicketLib.Ticket[] tickets;
        mapping( address => uint ) balances;
    }

    using LocationLib for LocationLib.Location;
    using TicketLib for TicketLib.Ticket;
    using ArrayUtil for uint[];

    // js: new Date(date).getTime()/1000 == date
    // js: new Date().getTime()/1000 == now
    //uint48[] dates;

    event LocationAdded(address indexed event_, uint indexed locationID);
    event TicketCreated(address indexed event_, uint indexed ticketID);


    function pendingTicketsToEmit(Event storage self, uint locationID) view public returns(uint){
        return self.locations[locationID].pendingTicketsToEmit();
    }

    function _createTicket(Event storage self, LocationLib.Location storage location, bool forSale) internal{
        uint ID = self.tickets.length;
        self.tickets.push(
            TicketLib.Ticket(
                ID, msg.sender, location.ID, forSale, location.basePrice
            )
        );
        TicketLib.Ticket storage ticket = self.tickets[ID];
        location.addTicket(ticket);
        emit TicketCreated(address(this), ticket.ID);
    }

    function createTickets(Event storage self, uint locationID, uint quantity, bool forSale)
        public {

        LocationLib.Location storage location = self.locations[locationID];

        require(
            location.pendingTicketsToEmit() >= quantity,
            "The quantity of created tickets should be lower or equal than capacity.");

        for (uint i=0; i<quantity; i++){
            _createTicket(self, location, forSale);
        }
            
    }

    function addLocation(Event storage self, string name, uint capacity,
        uint price)
        public {

        uint ID = self.locations.length;

        emit LocationAdded(address(this), ID);

        self.locations.length++;

        self.locations[ID].init(ID, name, capacity, price);

    }

    function changeLocation(Event storage self, uint locationID, string name,
        uint capacity, uint price)
        public {

        LocationLib.Location storage location = self.locations[locationID];
        location.change(name, capacity, price);
    }

    /// Buy the required quantity for the specified location 
    function buyLocation(Event storage self, uint locationID,
        uint quantity) public {

        // All the requested locations and quantities are available for sale.
        require(hasTicketsForSale(self, locationID, quantity),
            "The requested quantities per location are not completely available.");

        // For each location and its quantities, are obtained the possible
        // tickets.
        uint[] memory ticketsIDs = selectTickets(self, locationID, quantity);

        buyTickets(self, ticketsIDs);

    }

    /// Buy the required locations and the required quantities for the
    /// specified locations.
    function buyLocations(Event storage self, uint[] locationIDs,
        uint[] locationQuantities) public {

        // The length of parameters is correct.
        requireSameLegth(locationIDs, locationQuantities,
            "locationIDs and locationQuantities parameters, must have the same length.");

        // All the requested locations and quantities are available for sale.
        require(hasTicketsForSale(self, locationIDs, locationQuantities),
            "The requested quantities per location are not completely available.");

        // For each location and its quantities, are obtained the possible
        // tickets.
        uint[] memory ticketsIDs = selectTickets(self, locationIDs, locationQuantities);

        buyTickets(self, ticketsIDs);

    }

    function removeTicketFromSale(Event storage self, uint ticketID) public {
        TicketLib.Ticket storage ticket = self.tickets[ticketID];
        LocationLib.Location storage location = self.locations[ticket.locationID];
        location.removeTicketFromSale(ticket);
    }

    function buyTickets(Event storage self, uint[] ticketsIDs) public {

        require(ticketsIDs.isUnique(), "The tickets IDs are not unique.");

        uint ticketsValue = getTicketsValue(self, ticketsIDs);

        // Check if the value of the transaction is grather than or equal to the
        // tickets' price.
        require(msg.value >= ticketsValue,
            "The payment does not achive the tickets' price.");

        uint balance = msg.value;

        for (uint i; i<ticketsIDs.length; i++){

            LocationLib.Location storage location = self.locations[ticket.locationID];
            TicketLib.Ticket storage ticket = self.tickets[ticketsIDs[i]];

            location.sellTicket(ticket);

            balance -= ticket.price;
            self.balances[ticket.owner] += ticket.price;
        }

        assert(ticketsValue+balance == msg.value);

        // We assign the remaining balance.
        self.balances[msg.sender] += balance;
    }

    function getTicketsValue(Event storage self, uint[] ticketsIDs) view public returns(uint value){
        value = 0;
        for (uint i=0; i<ticketsIDs.length; i++){
            uint ticketID = ticketsIDs[i];
            value += self.tickets[ticketID].price;
        }
    }

    function requireSameLegth(uint[] a, uint[] b, string message) internal pure{
        require(a.length == b.length, message);
    }

    function hasTicketsForSale(Event storage self, uint locationID, uint quantity) public view returns(bool available){
        LocationLib.Location storage location = self.locations[locationID];
        return location.ticketsForSale() >= quantity;
    }

    function hasTicketsForSale(Event storage self, uint[] locationIDs,
        uint[] locationQuantities) public view returns(bool available){

        // The length of parameters is correct.
        requireSameLegth(locationIDs, locationQuantities,
            "locationIDs and locationQuantities parameters, must have the same length.");

        require(locationIDs.isUnique(), "There are duplicated locations IDs.");

        uint length = locationIDs.length;

        for (uint i; i<length; i++){
            if (!hasTicketsForSale(self, locationIDs[i],locationQuantities[i]))
                return false;
        }

        return true;
    }

    function selectTickets(Event storage self, uint[] locationIDs,
        uint[] locationQuantities) public view returns(uint[] ticketsIDs){

        requireSameLegth(locationIDs, locationQuantities,
            "locationIDs and locationQuantities parameters, must have the same length.");

        require(locationIDs.isUnique(), "There are duplicated locations IDs.");

        uint length = self.locations.length;

        ticketsIDs = new uint[](locationQuantities.sum());

        uint k = 0;
        for (uint i; i<length; i++){
            uint[] memory ticketsIDs_ = selectTickets(self, locationIDs[i], locationQuantities[i]);
            for (uint j; j<ticketsIDs_.length; j++){
                ticketsIDs[k] = ticketsIDs_[j];
                k++;
            }
        }

    }

    function selectTickets(Event storage self, uint locationID, uint quantity) public view returns(uint[] ticketsIDs) {
        LocationLib.Location storage location = self.locations[locationID];
        return location.selectTickets(quantity);
    }

}



