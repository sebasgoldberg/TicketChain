pragma solidity ^0.4.24;

import './Ownable.sol';
import './ArrayUtil.sol';

contract Event is Ownable{

    using ArrayUtil for uint[];

    string public name;
    // js: new Date(date).getTime()/1000 == date
    // js: new Date().getTime()/1000 == now
    //uint48[] dates;

    struct Location {
        uint ID;
        string name;
        uint ticketsEmited;
        uint capacity;
        uint basePrice; // in wei
        uint[] ticketsIDsForSale;
        }

    struct Ticket {
        uint ID;
        address owner;
        uint locationID;
        bool isForSale;
        uint price;
        }

    Location[] public locations;
    Ticket[] public tickets;
    mapping( address => uint ) public balances;

    event LocationAdded(address indexed event_, uint indexed locationID);
    event LocationChanged(address indexed event_, uint indexed locationID);
    event TicketSold(address indexed event_, uint indexed ticketID);

    constructor(address _owner, string _name) public Ownable() {
        owner = _owner;
        name = _name;
    }

    function addLocation(string _name, uint capacity,
        uint price)
        onlyOwner public {

        emit LocationAdded(address(this), ID);

        uint ID = locations.length;
        locations.push(Location(locations.length, _name,
            0, capacity, price, new uint[](0)));



    }

    function changeLocation(uint locationID, string _name,
        uint capacity, uint price)
        onlyOwner public {

        emit LocationChanged(address(this), locationID);

        Location storage location = locations[locationID];
        location.name = _name;
        location.capacity = capacity;
        location.basePrice = price;
    }

    /// Buy the required locations and the required quantities for the
    /// specified locations.
    function buyLocations(uint[] locationIDs,
        uint[] locationQuantities) public payable{

        // The length of parameters is correct.
        requireSameLegth(locationIDs, locationQuantities,
            "locationIDs and locationQuantities parameters, must have the same length.");

        // All the requested locations and quantities are available for sale.
        require(areLocationsAvailable(locationIDs, locationQuantities),
            "The requested quantities per location are not completely available.");

        // For each location and its quantities, are obtained the possible
        // tickets.
        uint[] memory ticketsIDs = selectTickets(
            locationIDs, locationQuantities);

        buyTickets(ticketsIDs);

    }

    function sellTicket(Ticket ticket) internal {

        emit TicketSold(address(this), ticket.ID);
        require(ticket.isForSale, "A ticket specified is not for sale.");
        balances[ticket.owner] += ticket.price;
        ticket.owner = msg.sender;
        removeTicketFromSale(ticket.ID);

    }

    function removeTicketFromSale(uint ticketID) public {
        Ticket storage ticket = tickets[ticketID];
        require(ticket.owner == msg.sender,
            "Only the owner of the ticket can remove the ticket from sale.");
        require(ticket.isForSale, "A ticket specified is not for sale.");
        ticket.isForSale = false;
        Location storage location = locations[ticket.locationID];
        location.ticketsIDsForSale.removeByValue(ticket.ID);
        location.ticketsIDsForSale.length--;
    }

    function buyTickets(uint[] ticketsIDs) public payable{

        uint ticketsValue = getTicketsValue(ticketsIDs);

        // Check if the value of the transaction is grather than or equal to the
        // tickets' price.
        require(msg.value >= ticketsValue,
            "The payment does not achive the tickets' price.");

        uint balance = msg.value;

        for (uint i; i<ticketsIDs.length; i++){
            Ticket storage ticket = tickets[ticketsIDs[i]];
            balance -= ticket.price;
            sellTicket(ticket);
        }

        assert(ticketsValue+balance == msg.value);

        // We assign the remaining balance.
        balances[msg.sender] += balance;
    }

    function getTicketsValue(uint[] ticketsIDs) view public returns(uint value){
        value = 0;
        for (uint i=0; i<ticketsIDs.length; i++){
            uint ticketID = ticketsIDs[i];
            value += tickets[ticketID].price;
        }
    }

    function requireSameLegth(uint[] a, uint[] b, string message) internal pure{
        require(a.length == b.length, message);
    }

    function areLocationsAvailable(uint[] locationIDs,
        uint[] locationQuantities) public view returns(bool available){

        // The length of parameters is correct.
        requireSameLegth(locationIDs, locationQuantities,
            "locationIDs and locationQuantities parameters, must have the same length.");

        uint length = locations.length;

        for (uint i; i<length; i++){
            if (locations[i].ticketsIDsForSale.length < locationQuantities[i])
                return false;
        }

        return true;
    }

    function selectTickets(uint[] locationIDs,
        uint[] locationQuantities) public view returns(uint[] ticketsIDs){

        requireSameLegth(locationIDs, locationQuantities,
            "locationIDs and locationQuantities parameters, must have the same length.");

        uint length = locations.length;

        ticketsIDs = new uint[](locationQuantities.sum());

        uint k = 0;
        for (uint i; i<length; i++){
            uint[] memory ticketsIDs_ = selectTickets(locationIDs[i], locationQuantities[i]);
            for (uint j; j<ticketsIDs_.length; j++){
                ticketsIDs[k] = ticketsIDs_[j];
                k++;
            }
        }

    }

    function hasQuantityForSale(uint locationID, uint quantity) public view returns(bool isForSale) {
        return (locations[locationID].ticketsIDsForSale.length >= quantity);
    }

    function selectTickets(uint locationID, uint quantity) public view returns(uint[] ticketsIDs) {
        require(hasQuantityForSale(locationID, quantity),
            "The are not enough tickets for the required quantity");
        Location storage location = locations[locationID];
        uint from = location.ticketsIDsForSale.length - quantity;
        uint length = location.ticketsIDsForSale.length;
        ticketsIDs = new uint[](quantity);
        uint k = 0;
        for (uint i=from; i<length; i++){
            ticketsIDs[k] = location.ticketsIDsForSale[i];
            k++;
        }
    }

}


