// SPDX-License-Identifier: MIT
pragma solidity >0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract VotingTokenV2 is ERC20 {
    mapping (address => uint256) public depositOf;
    constructor() ERC20("Vietnam","VN") {
        
    }

    function deposit() public payable {
        depositOf[msg.sender] = msg.value; // native token deposited to contract
        // 0.1 e = 1000 token
        uint256 receivedToken = (msg.value * 1000) / (0.1 * 10**18);
        _mint(msg.sender, receivedToken);
    }
}