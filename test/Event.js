const TicketChain = artifacts.require("TicketChain");
const Event = artifacts.require("Event");

class LocationStruct{
    constructor(name, disponibility, price){
        this.name = name;
        this.disponibility = disponibility.toNumber();
        this.price = price.toNumber();
    }
}

contract('Event test', async (accounts) => {

    let instance;
    let contractAccount = accounts[0];
    let eventAccount = accounts[1];
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


        assert.equal(
            receipt.logs[0].args.event_,
            await instance.events(eventAccount,0),
            "The EventCreated address and the stored address are the same.");

        let eventAddress = receipt.logs[0].args.event_;
        event = await Event.at(eventAddress);

        assert.equal(await event.name(), eventName, "The event name is correct");
        assert.equal(await event.owner(), eventAccount, "The event owner is correct");

    });

    it("Should be possible to add a location for an event", async () => {

        let locationName = "Location A";
        let locationDisponibility = 100;
        let locationPrice = web3.toWei(.5, 'ether');

        let receipt = await event.addLocation(
            locationName,
            locationDisponibility,
            locationPrice,
            {from: eventAccount}
            );

        assert.equal(receipt.logs.length, 1, "an event was triggered");
        assert.equal(receipt.logs[0].event, "LocationAdded", "the event type is correct");
        assert.equal(receipt.logs[0].args.event_, event.address, "The event address is correct");
        assert.equal(receipt.logs[0].args.locationID, 0, "The location ID is correct");

        let locationID = receipt.logs[0].args.locationID;

        location = new LocationStruct(...await event.locations(locationID));

        assert.equal(location.name, locationName, "The location name is correct");
        assert.equal(location.disponibility, locationDisponibility, "The location disponibility is correct");
        assert.equal(location.price, locationPrice, "The location price is correct");

    });

    it("Should only the event owner can add a location.", async () => {

        let locationName = "Location B";
        let locationDisponibility = 101;
        let locationPrice = web3.toWei(.51, 'ether');

        try {
            await event.addLocation(
                locationName,
                locationDisponibility,
                locationPrice
                );
            assert.fail("Only the event owner can add a location.");
        } catch (e) {
            assert(e.message.indexOf('revert') >= 0, "The error message should contain revert.");
        }

    });

});

