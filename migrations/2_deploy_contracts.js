var TicketChain = artifacts.require("./TicketChain.sol");

module.exports = function(deployer) {
  deployer.deploy(TicketChain);
};
