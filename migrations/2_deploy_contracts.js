var Ownable = artifacts.require("../contracts/Ownable.sol");
var Locations = artifacts.require("../contracts/Locations.sol");
var Event = artifacts.require("../contracts/Event.sol");
var TicketChain = artifacts.require("../contracts/TicketChain.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(Locations);
  deployer.link(Ownable, Event);
  deployer.link(Locations, Event);
  deployer.deploy(Event,0,'');
  deployer.link(Ownable, TicketChain);
  deployer.link(Event, TicketChain);
  deployer.deploy(TicketChain);
};
