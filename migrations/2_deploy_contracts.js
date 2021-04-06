const Stock = artifacts.require("Stock");

module.exports = async function (deployer) {
  await deployer.deploy(Stock);
};
