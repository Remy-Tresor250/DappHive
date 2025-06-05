var AppURL = artifacts.require("./AppURL.sol");

contract('AppURL', function(accounts) {
    var appInstance;

    before(function () {
        return AppURL.deployed().then(function(instance) {
            appInstance = instance;
        });
    });

    it("should be able to reserve a url", function() {
        return appInstance.reserve('vinay_035','srind1',{from:accounts[1]}).then(function(instance){
            return appInstance.retrieveWalletForapp.call('vinay_035');
        }).then(function(result) {
            assert.equal(result,accounts[1],"Should be able to retrive the same wallet address");
            return appInstance.retrieveappForWallet.call(accounts[1]);
        }).then(function(result) {
            assert.equal(result,'vinay_035',"Should be able to retrive the same app");
            return appInstance.retrievetrexroleIdForapp.call('vinay_035');
        }).then(function(result) {
            assert.equal(result,'srind1',"Should be able to retrive the same trexrole id");
            return appInstance.retrieveappFortrexroleId.call('srind1');
        }).then(function(result) {
            assert.equal(result,'vinay_035',"Should be able to retrive the same app");
        }).catch(function(error){
            assert.isUndefined(error,"should be able to reserve a url")
        })
    });

    it("reserve url should be case insensitive", function() {
        return appInstance.reserve('CASEIN','srind2').then(function(instance){
            return appInstance.retrieveWalletForapp.call('casein');
        }).then(function(result) {
            assert.equal(result,accounts[0],"Should be able to retrive the same wallet address");
            return appInstance.retrieveappForWallet.call(accounts[0]);
        }).then(function(result) {
            assert.equal(result,'casein',"reserve url should be case insensitive");
            return appInstance.retrievetrexroleIdForapp.call('casein');
        }).then(function(result) {
            assert.equal(result,'srind2',"Should be able to retrive the same trexrole id");
            return appInstance.retrieveappFortrexroleId.call('srind2');
        }).then(function(result) {
            assert.equal(result,'casein',"Should be able to retrive the same app");
        }).catch(function(error){
            assert.isUndefined(error,"should be able to reserve a url")
        })
    });

    it("should fail when tried to reserve non alphanumeric keywords", function() {
        return appInstance.reserve('Vi@345').then(function(instance){
            assert.isUndefined(instance,"should fail when tried to reserve non alphanumeric keywords")
        }).catch(function(error){
            assert.isDefined(error,"should fail when tried to reserve non alphanumeric keywords")
        })
    });

    it("should fail when tried to reserve less then 4 characters", function() {
        return appInstance.reserve('van').then(function(instance){
            assert.isUndefined(instance,"should fail when tried to reserve less then 4 characters")
        }).catch(function(error){
            assert.isDefined(error,"should fail when tried to reserve less then 4 characters")
        })
    });

    it("should fail when tried to reserve already reserved keyword", function() {
        return appInstance.reserve('vinay035').then(function(instance){
            assert.isUndefined(instance,"should fail when tried to reserve lready reserved keyword")
        }).catch(function(error){
            assert.isDefined(error,"should fail when tried to reserve already reserved keyword")
        })
    });

    it("should be able to transfer a app", function() {
        return appInstance.transferOwnershipForAppURL(accounts[3],{from:accounts[1]}).then(function(instance){
            return appInstance.retrieveWalletForapp.call('vinay_035');
        }).then(function(result) {
            assert.equal(result,accounts[3],"Should be able to retrive the same wallet address");
            return appInstance.retrieveappForWallet.call(accounts[3]);
        }).then(function(result) {
            assert.equal(result,'vinay_035',"Should be able to retrive the same app");
        }).catch(function(error){
            assert.isUndefined(error,"should be able to reserve a url")
        })
    });

    it("owner only should be able to release a app", function() {
        return appInstance.releaseAppURL('casein',{from:accounts[3]}).then(function(instance){
            assert.isDefined(instance,"owner only should be able to release a app")
        }).catch(function(error){
            assert.isDefined(error,"owner should be able to release a app")
        })
    });

    it("owner should be able to release a app", function() {
        return appInstance.releaseAppURL('casein').then(function(instance){
            return appInstance.retrieveWalletForapp.call('casein');
        }).then(function(result){
            assert.equal(result,'0x0000000000000000000000000000000000000000',"owner should be able to release a app")
            return appInstance.retrievetrexroleIdForapp.call('casein');
        }).then(function(result){
            assert.equal(result,'',"owner should be able to release a app")
        }).catch(function(error){
            assert.isUndefined(error,"owner should be able to release a app")
        })
    });

    it("owner only should be able to call reserveAppURLByOwner", function() {
        return appInstance.reserveAppURLByOwner(accounts[4],'testowner','srind3','0x',{from:accounts[3]}).then(function(instance){
            assert.isDefined(instance,"owner only should be able to call reserveAppURLByOwner")
        }).catch(function(error){
            assert.isDefined(error,"owner only should be able to call reserveAppURLByOwner")
        })
    });

    it("owner should be able to call reserveAppURLByOwner and assign a app to any address", function() {
        return appInstance.reserveAppURLByOwner(accounts[4],'testowner','srind3','0x').then(function(instance){
            return appInstance.retrieveWalletForapp.call('testowner');
        }).then(function(result) {
            assert.equal(result,accounts[4],"Should be able to retrive the same wallet address");
            return appInstance.retrieveappForWallet.call(accounts[4]);
        }).then(function(result) {
            assert.equal(result,'testowner',"Should be able to retrive the same app");
        }).catch(function(error){
            assert.isUndefined(error,"owner should be able to call reserveAppURLByOwner and assign a app to any address")
        })
    });

    it("should error on change AppURL when address has no app", function() {
        return appInstance.changeAppURL('noassigned',{from:accounts[5]}).then(function(instance){
            assert.isUndefined(instance,"should error on change AppURL when not assigned")
        }).catch(function(error){
            assert.isDefined(error,"should error on change AppURL when not assigned")
        })
    });

    it("should error on change AppURL when app is in use", function() {
        return appInstance.changeAppURL('vinay035','srind4',{from:accounts[3]}).then(function(instance){
            assert.isUndefined(instance,"should error on change AppURL when not assigned")
        }).catch(function(error){
            assert.isDefined(error,"should error on change AppURL when not assigned")
        })
    });

    it("should be able to change AppURL", function() {
        return appInstance.changeAppURL('vinay0351','srind5',{from:accounts[3]}).then(function(instance){
            assert.isDefined(instance,"should be able to change AppURL")
        }).catch(function(error){
            console.log(error);
            assert.isUndefined(error,"should be able to change AppURL")
        })
    });
});
