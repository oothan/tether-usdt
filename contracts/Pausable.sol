// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";

/**
 *  @title Pausable
 *  @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable {

    event Pause();
    event Unpause();

    bool public paused = false;

    /**
     *  @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused () {
        require (!paused);
        _;
    }

    /**
     *  @dev Modifier to make a function callable only when the contract is paused.
     */
    function whenPaused () {
        require (paused);
        _;
    }

    /**
     *  @dev called by the owner to pause, triggers stopped state
     */
    function pause () onlyOwner whenNotPaused public {
        paused = true;
        emit Pause();
    }

    /**
     *  @dev called by the owner to unpause, return to normal state.
     */
    function unpause () onlyOwner whenPaused public {
        paused = false;
        emit Unpause();
    }
}
