// pragma solidity ^0.4.20;
pragma solidity >=0.4.0 <0.7.0;

contract ERC20Simple {
    function totalSupply() external virtual view returns (uint256) {}

    function balanceOf(address _owner) public virtual view returns (uint256) {}

    function transfer(address _to, uint256 _value)
        public
        virtual
        returns (bool)
    {}

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual returns (bool) {}

    function approve(address _spender, uint256 _value)
        public
        virtual
        returns (bool)
    {}

    function allowance(address _owner, address _spender)
        public
        virtual
        view
        returns (uint256)
    {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

contract StandardToken is ERC20Simple {
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        if (
            balances[_from] >= _value &&
            allowed[_from][msg.sender] >= _value &&
            _value > 0
        ) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function balanceOf(address _owner)
        public
        override
        view
        returns (uint256 balance)
    {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        override
        view
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 public override totalSupply;
}

contract BSEToken is StandardToken {
    fallback() external {
        //if ether is sent to this address, send it back.
        revert("Process Reverted Back");
    }

    /* Public variables of the token */
    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = "BSEToken 1.0";

    function ERC20Token() public {
        balances[msg.sender] = 1000000000000000000; // Give the creator all initial tokens (100000 for example)
        totalSupply = 100000; // Update total supply (100000 for example)
        name = "BSEToken"; // Set the name for display purposes
        decimals = 18; // Amount of decimals for display purposes
        symbol = "BSETok"; // Set the symbol for display purposes
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(
        address _spender,
        uint256 _value,
        bytes memory _extraData
    ) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        // if (!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))),msg.sender,  _value,this, _extraData)
        // )
        // {
        //     revert();
        // }

        //Above commented statements have been converted because '!' wasnt supported
        (bool successCall, ) = _spender.call(
            abi.encode(
                bytes4(
                    bytes32(
                        keccak256(
                            "receiveApproval(address,uint256,address,bytes)"
                        )
                    )
                ),
                msg.sender,
                _value,
                this,
                _extraData
            )
        );
        require(successCall, "Process reverted back");
        return true;
    }
}
