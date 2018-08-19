var Ownable = artifacts.require("../contracts/Ownable.sol");
var ArrayUtil = artifacts.require("../contracts/ArrayUtil.sol");
var TicketLib = artifacts.require("../contracts/TicketLib.sol");
var LocationLib = artifacts.require("../contracts/LocationLib.sol");
var EventLib = artifacts.require("../contracts/EventLib.sol");
var Event = artifacts.require("../contracts/Event.sol");
var TicketChain = artifacts.require("../contracts/TicketChain.sol");

async function doDeploy(deployer, network){
    await deployer.deploy(Ownable);
    await deployer.link(Ownable, [Event, TicketChain]);

    await deployer.deploy(ArrayUtil);
    await deployer.link(ArrayUtil, [EventLib, LocationLib, TicketLib]);

    await deployer.deploy(TicketLib);
    await deployer.link(TicketLib, [EventLib, LocationLib]);

    await deployer.deploy(LocationLib);
    await deployer.link(LocationLib, [EventLib]);

    await deployer.deploy(EventLib);
    await deployer.link(EventLib, [Event, TicketChain]);

    await deployer.deploy(Event,0,'');
    await deployer.link(Event, [TicketChain]);

    await deployer.deploy(TicketChain);
}

module.exports = (deployer, network) => {
    deployer.then(async () => {
        await doDeploy(deployer, network)
    });
};
