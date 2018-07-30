const TicketChain = artifacts.require("TicketChain");
const Event = artifacts.require("Event");


class LocationStruct{
    constructor(ID, name, ticketsEmited, capacity, basePrice, ticketsIDsForSale){
        this.ID = ID.toNumber();
        this.name = name;
        this.ticketsEmited = ticketsEmited.toNumber();
        this.capacity = capacity.toNumber();
        this.basePrice = basePrice.toNumber();
        this.ticketsIDsForSale = ticketsIDsForSale;
    }
}


class TicketStruct{
    constructor(owner, locationID){
        this.owner = owner;
        this.locationID = locationID.toNumber();
    }
}


contract('Event test', async (accounts) => {

    let instance;
    let contractAccount = accounts[0];
    let eventAccount = accounts[1];
    let buyerAccount = accounts[2];
    let event;
    let location;

    it("Should be possible to create an event", async () => {

        instance = await TicketChain.deployed();
        let eventName = "My Event";
        //let eventDate = new Date('3000-12-31T12:34:56').getTime()/1000;
        let receipt = await instance.createEvent(
            eventName,
            {from: eventAccount}
            );
        assert.equal(receipt.logs.length, 1, "an event was triggered");
        assert.equal(receipt.logs[0].event, "EventCreated", "the event type is correct");
        assert.isDefined(receipt.logs[0].args.event_, "The event address is defined");

        let eventsCount = await instance.eventsCount(eventAccount);

        let theSame = false;
        for (let i=0; i<eventsCount; i++){
            theSame = ( receipt.logs[0].args.event_ ==
                await instance.events(eventAccount,0) );
            if (theSame)
                break;
        }
        assert.isTrue(
            theSame,
            "The EventCreated address and the stored address are the same.");

        let eventAddress = receipt.logs[0].args.event_;
        event = await Event.at(eventAddress);

        assert.equal(await event.name(), eventName, "The event name is correct");
        assert.equal(await event.owner(), eventAccount, "The event owner is correct");

    });

    it("Should be possible to add a location for an event", async () => {

        let locationName = "Location A";
        let locationCapacity = 100;
        let locationPrice = web3.toWei(.5, 'ether');

        let receipt = await event.addLocation(
            locationName,
            locationCapacity,
            locationPrice,
            {from: eventAccount}
            );

        assert.equal(receipt.logs.length, 1, "an event was triggered");
        assert.equal(receipt.logs[0].event, "LocationAdded", "the event type is correct");
        assert.equal(receipt.logs[0].args.event_, event.address, "The event address is correct");
        assert.equal(receipt.logs[0].args.locationID, 0, "The location ID is correct");

        let locationID = receipt.logs[0].args.locationID;

        location = new LocationStruct(...await event.locations(locationID));

        assert.equal(location.ID, locationID, "The location ID is correct");
        assert.equal(location.name, locationName, "The location name is correct");
        assert.equal(location.ticketsEmited, 0, "The location tickets emited is correct");
        assert.equal(location.capacity, locationCapacity, "The location capacity is correct");
        assert.equal(location.basePrice, locationPrice, "The location base price is correct");

    });

    it("Should only the event owner can add a location.", async () => {

        let locationName = "Location B";
        let locationCapacity = 101;
        let locationPrice = web3.toWei(.51, 'ether');

        try {
            await event.addLocation(
                locationName,
                locationCapacity,
                locationPrice
                );
            assert.fail("Only the event owner can add a location.");
        } catch (e) {
            assert(e.message.indexOf('revert') >= 0, "The error message should contain revert.");
        }

    });

    it("Should be possible to change a location for an event", async () => {

        let locationName = "Location Z";
        let locationCapacity = 200;
        let locationPrice = web3.toWei(.3, 'ether');

        let receipt = await event.changeLocation(
            0,
            locationName,
            locationCapacity,
            locationPrice,
            {from: eventAccount}
            );

        assert.equal(receipt.logs.length, 1, "an event was triggered");
        assert.equal(receipt.logs[0].event, "LocationChanged", "the event type is correct");
        assert.equal(receipt.logs[0].args.event_, event.address, "The event address is correct");
        assert.equal(receipt.logs[0].args.locationID, 0, "The location ID is correct");

        location = new LocationStruct(...await event.locations(0));

        assert.equal(location.name, locationName, "The location name is correct");
        assert.equal(location.capacity, locationCapacity, "The location capacity is correct");
        assert.equal(location.basePrice, locationPrice, "The location price is correct");

    });

    it("Should only the event owner can change a location.", async () => {

        let locationName = "Location B";
        let locationCapacity = 101;
        let locationPrice = web3.toWei(.51, 'ether');

        try {
            await event.changeLocation(
                0,
                locationName,
                locationCapacity,
                locationPrice
                );
            assert.fail("Only the event owner can change a location.");
        } catch (e) {
            assert(e.message.indexOf('revert') >= 0, "The error message should contain revert.");
        }

    });

    it("Should be possible to buy tickets.", async () => {

        let locationID = 0;
        let locationQuantity = 2;

        let receipt = await event.buyLocations(
            [locationID],
            [locationQuantity],
            {from: buyerAccount,
            value:location.price}
            );

        assert.equal(receipt.logs.length, 2, "an event was triggered");
        assert.equal(receipt.logs[0].event, "TicketBuyed", "the event type is correct");
        assert.equal(receipt.logs[0].args.event_, event.address, "The event address is correct");
        assert.isDefined(receipt.logs[0].args.ticketID, "The ticket ID is correct");
        assert.equal(receipt.logs[1].event, "TicketBuyed", "the event type is correct");
        assert.equal(receipt.logs[1].args.event_, event.address, "The event address is correct");
        assert.isDefined(receipt.logs[1].args.ticketID, "The ticket ID is correct");

        receipt.logs.map( log => log.args.ticketID).forEach( async ticketID => {
            let ticket = new TicketStruct(...await event.tickets(ticketID));

            assert.equal(ticket.owner, buyerAccount, "The ticket owner is correct");
            assert.equal(ticket.locationID, locationID, "The location ID is correct");
            assert.isFalse(event.ticketForSale(ticketID), "The ticket is not for sale");
        });

        assert.equal(await event.balance(), locationQuantity*location.price,
            "The contract balance is the value spent in the tickets");

    });


});

