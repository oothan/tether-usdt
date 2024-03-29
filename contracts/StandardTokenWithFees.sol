// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";
import "./StandardToken.sol";

contract StandardTokenWithFees {


    /**
     * @dev additional variables for use if transaction fees ever became necessary
     */
    uint public basisPointsRate = 0;
    uint public maximumFee = 0;
    uint constant MAX_SETTABLE_BASIS_POINTS = 20;
    uint constant MAX_SETTABLE_FEE = 50;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint public _totalSupply;

    uint public constant MAX_UINT = 2 ** 256 - 1;

    function calcFee (uint _value) constant returns (bool) {
        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee)
            fee = maximumFee;
        return fee;
    }

    function transfer (address _to, uint _value)
        public
        returns (bool)
    {
        uint fee = calcFee(_value);
        uint sendAmount = _value.sub(fee);

        super.transfer(_to, sendAmount);
        if (fee >0 )
            super.transfer(owner, fee);
        return true;
    }

    function transferFrom (address _from, address _to, uint _value)
        public
        returns (bool)
    {
        require (_to != address(0));
        require (_value <= balances[_from]);
        require (_value <= allowed[_from][msg.sender]);

        uint fee = calcFee(_value);
        uint sendAmount = _value.sub(fee);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(sendAmount);

        if (allowed[_from][msg.sender] < MAX_UINT)
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, sendAmount);

        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
            emit Transfer(_from, owner, fee);
        }

        return true;
    }

    function setParams (uint newBasisPoints, uint newMaxFee)
        public
        onlyOwner
    {
        require (newBasisPoints < MAX_SETTABLE_BASIS_POINTS);
        require (newMaxFee < MAX_SETTABLE_FEE);

        basisPointsRate = newBasisPoints;
        maximumFee = newMaxFee.mul(uint(10) ** decimals);

        emit Params(basisPointsRate, maximumFee);
    }

    event Params(uint feeBasisPoints, uint maxFee);
}
