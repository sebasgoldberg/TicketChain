const TicketChain = artifacts.require("TicketChain");

contract('TicketChain test', async (accounts) => {

    let instance;
    let contractAccount = accounts[0];
    let eventAccount = accounts[1];

    it("Should be possible to create an event", async () => {
        instance = await TicketChain.deployed();
        let eventName = "My Event";
        let eventDate = new Date('3000-12-31T12:34:56').getTime()/1000;
        let receipt = await instance.createEvent(
            eventName,
            eventDate,
            {from: eventAccount}
            );
        assert.equal(receipt.logs.length, 1, "an event was triggered");
        assert.equal(receipt.logs[0].event, "EventCreated", "the event type is correct");
        assert.equal(receipt.logs[0].args.eventOwner, eventAccount, "The event owner is correct");
        assert.equal(receipt.logs[0].args.eventName, eventName, "The event name is correct");
        assert.equal(receipt.logs[0].args.eventDate, eventDate, "The event date is correct");
    });

});

