const ERC20simpleContract = artifacts.require("ERC20Simple");

module.exports = function (deployer) {
  deployer.deploy(ERC20simpleContract);
};
