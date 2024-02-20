// SPDX-License-Identifier: MIT
pragma solidity >0.8.9;

contract VotingToken {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint256 public decimals;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint256) public depositOf;

    event Transfer(address, address, uint256);
    event Approve(address, address, uint256);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initSupply
    ) {
        name = _name;
        symbol = _symbol;
        balanceOf[msg.sender] = _initSupply;
        totalSupply += _initSupply;
    }

    function deposit() public payable {
        depositOf[msg.sender] = msg.value; // native token deposited to contract
        // 0.1 e = 1000 token
        uint256 receivedToken = (msg.value * 1000) / (0.1 * 10**18);
        balanceOf[msg.sender] = receivedToken;
    }

    function canTransfer(address _to, uint256 _value) external returns (bool) {
        transfer(msg.sender, _to, _value);
        return true;
    }

    function transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(_to != address(0), "Dead address");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    // GH token rút ra từ balance của mình
    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        emit Approve(msg.sender, _spender, _value);
        return success;
    }

    // Ủy quyền ng khác chuyển token thay vì mình
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(
            allowance[_from][msg.sender] >= _value,
            "Insufficient allowance"
        );
        allowance[_from][msg.sender] -= _value;
        transfer(_from, _to, _value);
        return true;
    }
}
