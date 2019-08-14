pragma solidity ^0.5.10;

import "../lib/dss/src/lib.sol";

contract DSTokenLike {
    function mint(address,uint) external;
    function burn(address,uint) external;
}

contract PotLike {
    mapping(address => mapping (address => uint)) public can;
    function drip() external;
    function move(address, address, uint) external;
}

contract sDaiJoin is DSNote{
    PotLike public pot;
    DSTokenLike public sDai;
    constructor(address pot_, address sDai_) public {
        pot = PotLike(pot_);
        sDai = DSTokenLike(sDai_);
    }
    uint constant ONE = 10 ** 27;
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    function join(address usr, uint wad) external note {
        pot.move(msg.sender, address(this), mul(ONE, wad));
        sDai.mint(usr, wad);
    }
    function exit(address usr, uint wad) external note {
        sDai.burn(msg.sender, wad);
        pot.move(address(this), usr, mul(ONE, wad));
    }
}