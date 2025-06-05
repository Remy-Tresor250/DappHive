pragma solidity ^0.4.24;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of “user permissions”.
 */

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */

contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}



contract AppURL is Ownable,Pausable {

  // This declares a state variable that mapping for AppURL to address
  mapping (string => address) app_address_mapping;
  // This declares a state variable that mapping for address to AppURL
  mapping (address => string ) address_app_mapping;
  // This declares a state variable that mapping for AppURL to trexrole ID
  mapping (string => string) app_trexrole_id_mapping;
  // This declares a state variable that mapping for trexrole ID to AppURL
  mapping (string => string) trexrole_id_app_mapping;

  event appReserved(address _to, string _app_url);
  event appTransfered(address _to,address _from, string _app_url);
  event appReleased(string _app_url);

  /* function to retrive wallet address from app url */
  function retrieveWalletForapp(string _app_url) constant public returns (address) {
    return app_address_mapping[_app_url];
  }

  /* function to retrive app url from address */
  function retrieveappForWallet(address _address) constant public returns (string) {
    return address_app_mapping[_address];
  }

  /* function to retrive wallet trexrole id from app url */
  function retrievetrexroleIdForapp(string _app_url) constant public returns (string) {
    return app_trexrole_id_mapping[_app_url];
  }

  /* function to retrive app url from address */
  function retrieveappFortrexroleId(string _trexrole_id) constant public returns (string) {
    return trexrole_id_app_mapping[_trexrole_id];
  }

  /*
    function to reserve AppURL
    1. Checks if app is check is valid
    2. Checks if address has already a app url
    3. check if app url is used by any other or not
    4. Check if app url is present in any other spingrole id
    5. Transfer the token
    6. Update the mapping variables
  */
  function reserve(string _app_url,string _trexrole_id) whenNotPaused public {
    _app_url = _toLower(_app_url);
    require(checkForValidity(_app_url));
    require(app_address_mapping[_app_url]  == address(0x0));
    require(bytes(address_app_mapping[msg.sender]).length == 0);
    require(bytes(trexrole_id_app_mapping[_trexrole_id]).length == 0);
    /* adding to app address mapping */
    app_address_mapping[_app_url] = msg.sender;
    /* adding to app trexrole id mapping */
    app_trexrole_id_mapping[_app_url] = _trexrole_id;
    /* adding to trexrole id app mapping */
    trexrole_id_app_mapping[_trexrole_id] = _app_url;
    /* adding to address app mapping */
    address_app_mapping[msg.sender] = _app_url;
    emit appReserved(msg.sender, _app_url);
  }

  /*
  function to make lowercase
  */

  function _toLower(string str) internal returns (string) {
		bytes memory bStr = bytes(str);
		bytes memory bLower = new bytes(bStr.length);
		for (uint i = 0; i < bStr.length; i++) {
			// Uppercase character...
			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
				// So we add 32 to make it lowercase
				bLower[i] = bytes1(int(bStr[i]) + 32);
			} else {
				bLower[i] = bStr[i];
			}
		}
		return string(bLower);
	}

  /*
  function to verify AppURL
  1. Minimum length 4
  2.Maximum lenght 200
  3.app url is only alphanumeric
   */
  function checkForValidity(string _app_url) returns (bool) {
    uint length =  bytes(_app_url).length;
    require(length >= 4 && length <= 200);
    for (uint i =0; i< length; i++){
      var c = bytes(_app_url)[i];
      if ((c < 48 ||  c > 122 || (c > 57 && c < 65) || (c > 90 && c < 97 )) && (c != 95))
        return false;
    }
    return true;
  }

  /*
  function to change app URL
    1. Checks whether app URL is check is valid
    2. Checks whether trexrole id has already has a app
    3. Checks if address has already a app url
    4. check if app url is used by any other or not
    5. Check if app url is present in reserved keyword
    6. Update the mapping variables
  */

  function changeAppURL(string _app_url, string _trexrole_id) whenNotPaused public {
    require(bytes(address_app_mapping[msg.sender]).length != 0);
    require(bytes(trexrole_id_app_mapping[_trexrole_id]).length == 0);
    _app_url = _toLower(_app_url);
    require(checkForValidity(_app_url));
    require(app_address_mapping[_app_url]  == address(0x0));

    app_address_mapping[_app_url] = msg.sender;
    address_app_mapping[msg.sender] = _app_url;
    app_trexrole_id_mapping[_app_url]=_trexrole_id;
    trexrole_id_app_mapping[_trexrole_id]=_app_url;

    emit appReserved(msg.sender, _app_url);
  }

  /*
  function to transfer ownership for app URL
  */
  function transferOwnershipForAppURL(address _to) whenNotPaused public {
    require(bytes(address_app_mapping[_to]).length == 0);
    require(bytes(address_app_mapping[msg.sender]).length != 0);
    address_app_mapping[_to] = address_app_mapping[msg.sender];
    app_address_mapping[address_app_mapping[msg.sender]] = _to;
    emit appTransfered(msg.sender,_to,address_app_mapping[msg.sender]);
    delete(address_app_mapping[msg.sender]);
  }

  /*
  function to transfer ownership for app URL by Owner
  */
  function reserveAppURLByOwner(address _to,string _app_url,string _trexrole_id,string _data) whenNotPaused onlyOwner public {
      _app_url = _toLower(_app_url);
      require(checkForValidity(_app_url));
      /* check if app url is being used by anyone */
      if(app_address_mapping[_app_url]  != address(0x0))
      {
        /* Sending app Transfered Event */
        emit appTransfered(app_address_mapping[_app_url],_to,_app_url);
        /* delete from address mapping */
        delete(address_app_mapping[app_address_mapping[_app_url]]);
        /* delete from app mapping */
        delete(app_address_mapping[_app_url]);
        /* delete from trexrole id app mapping */
        delete(trexrole_id_app_mapping[app_trexrole_id_mapping[_app_url]]);
        /* delete from app trexrole id mapping */
        delete(app_trexrole_id_mapping[_app_url]);
      }
      else
      {
        /* sending appReserved event */
        emit appReserved(_to, _app_url);
      }
      /* add new address to mapping */
      app_address_mapping[_app_url] = _to;
      address_app_mapping[_to] = _app_url;
      trexrole_id_app_mapping[_trexrole_id] = _app_url;
      app_trexrole_id_mapping[_app_url] = _trexrole_id;
  }

  /*
  function to release a app URL by Owner
  */
  function releaseAppURL(string _app_url) whenNotPaused onlyOwner public {
    require(app_address_mapping[_app_url]  != address(0x0));
    /* delete from address mapping */
    delete(address_app_mapping[app_address_mapping[_app_url]]);
    /* delete from app mapping */
    delete(app_address_mapping[_app_url]);
    /* delete from trexrole id app mapping */
    delete(trexrole_id_app_mapping[app_trexrole_id_mapping[_app_url]]);
    /* delete from app trexrole id mapping */
    delete(app_trexrole_id_mapping[_app_url]);
    /* sending appReleased event */
    emit appReleased(_app_url);
  }

  /*
    function to kill contract
  */

  function kill() onlyOwner {
    selfdestruct(owner);
  }

  /*
    transfer eth recived to owner account if any
  */
  function() payable {
    owner.transfer(msg.value);
  }

}
