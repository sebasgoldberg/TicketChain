pragma solidity ^0.4.18;

contract TicketChain {

    struct Event {
        address owner;
        string name;
        // js: new Date(date).getTime()/1000 == date
        // js: new Date().getTime()/1000 == now
        uint48 date;
        }

    Event[] events;

    event EventCreated(uint indexed ID, address indexed eventOwner, string eventName, uint256 eventDate);

    constructor() public {
    }

    function createEvent(string name, uint48 date) public returns(uint eventId) {
        uint ID = events.length;
        events.push(Event(msg.sender, name, date));
        emit EventCreated(ID, events[ID].owner, events[ID].name, events[ID].date);
        return ID;
    }




}
