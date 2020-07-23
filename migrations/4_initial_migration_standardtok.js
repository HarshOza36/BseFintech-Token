const StandardTokenContract = artifacts.require("StandardToken");

module.exports = function (deployer) {
  deployer.deploy(StandardTokenContract);
};
