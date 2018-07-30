var Ownable = artifacts.require("../contracts/Ownable.sol");
var ArrayUtil = artifacts.require("../contracts/ArrayUtil.sol");
var Event = artifacts.require("../contracts/Event.sol");
var TicketChain = artifacts.require("../contracts/TicketChain.sol");

async function doDeploy(deployer, network){
    await deployer.deploy(Ownable);
    await deployer.deploy(ArrayUtil);
    await deployer.link(Ownable, Event);
    await deployer.link(ArrayUtil, [Event, TicketChain]);
    await deployer.deploy(Event,0,'');
    await deployer.link(Ownable, TicketChain);
    await deployer.link(Event, TicketChain);
    await deployer.deploy(TicketChain);
}

module.exports = (deployer, network) => {
    deployer.then(async () => {
        await doDeploy(deployer, network)
    });
};
