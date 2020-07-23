const BseTokenContract = artifacts.require("BSEToken");

module.exports = function (deployer) {
  deployer.deploy(BseTokenContract);
};
