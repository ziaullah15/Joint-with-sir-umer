// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor() ERC20("MyToken", "MTK") {}

        struct minterInfo{
        uint256[] time;
        uint256[] ammount;
    }

    uint256 timeDuration = 10;

    mapping (address => minterInfo) timeLocked;

    function mint(uint256 amount) public {
        require(amount > 0,"please enter some amount");
        _mint(address(this), (amount *30)/100);
        _mint(msg.sender, (amount*70)/100);
        minterInfo storage dt = timeLocked[msg.sender];
        dt.time.push(block.timestamp + timeDuration);
        dt.ammount.push((amount *30)/100);
        
    }

    function withDraw(uint index) public {
        minterInfo storage dt = timeLocked[msg.sender];
        require(dt.ammount[index] > 0,"you havent balance");
        require(dt.time[index] < block.timestamp,"your time is not over yet");
        IERC20 tKn = IERC20(address(this));
        tKn.transfer(msg.sender, dt.ammount[index]);
        dt.ammount[index] = 0;
    }

    function getData(address add)
        public
        view
        returns (
            uint256[] memory,
            uint256[] memory
        )
    {
        return (
            timeLocked[add].ammount,
            timeLocked[add].time
        );
    }
}
