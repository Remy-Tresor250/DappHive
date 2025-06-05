var AppURL = artifacts.require("./AppURL.sol");
var AirDrop = artifacts.require("./AirDrop.sol");
var trexToken = artifacts.require("./trexToken.sol");
var Attestation = artifacts.require("./Attestation.sol");

module.exports = function(deployer, network, accounts) {
      deployer.deploy(trexToken, 1000000)
    .then(function() {
        return deployer.deploy(AirDrop, trexToken.address);
    }).then(function() {
        return deployer.deploy(AppURL);
    }).then(function() {
        return deployer.deploy(Attestation);
    });
};
