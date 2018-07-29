var Ownable = artifacts.require("../contracts/Ownable.sol");
var ArrayUtil = artifacts.require("../contracts/ArrayUtil.sol");
var Event = artifacts.require("../contracts/Event.sol");
var TicketChain = artifacts.require("../contracts/TicketChain.sol");

module.exports = async(deployer) => {
  await deployer
  await deployer.deploy(Ownable);
  await deployer.deploy(ArrayUtil);
  await deployer.link(Ownable, Event);
  await deployer.link(ArrayUtil, Event);
  await deployer.deploy(Event,0,'');
  await deployer.link(Ownable, TicketChain);
  await deployer.link(Event, TicketChain);
  await deployer.deploy(TicketChain);
};
