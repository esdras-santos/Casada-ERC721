const Stock = artifacts.require("Stock");
const DSM = artifacts.require("DSM");

module.exports = async function (deployer) {
  await deployer.deploy(Stock);
  var stock = await Stock.deployed();
  await stock.registerStock("Tesla","TES", 10000);
  var getstock = await stock.getStock("Tesla");
  var name = await getstock.name();
  console.log(name);
};
