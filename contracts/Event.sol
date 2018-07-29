pragma solidity ^0.4.24;

import './Ownable.sol';
import "./Locations.sol";

contract Event is Ownable{

    using Locations for Locations.Location;

    string public name;
    // js: new Date(date).getTime()/1000 == date
    // js: new Date().getTime()/1000 == now
    //uint48[] dates;
    Locations.Location[] public locations;

    event LocationAdded(address indexed event_, uint indexed locationID);

    constructor(address _owner, string _name) public Ownable() {
        owner = _owner;
        name = _name;
    }

    function addLocation(string _name, uint disponibility,
        uint price) onlyOwner public {

        uint ID = locations.length;
        locations.push(Locations.Location(_name, disponibility, price));
        emit LocationAdded(address(this), ID);
    }

}


