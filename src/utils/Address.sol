pragma solidity ^0.8.15;

library Address {

/// @dev Yul implementation of isContract 
    function isContract(address _account) internal view returns (bool success){
        assembly{
            let x :=0
            x:= extcodesize(_account)
            success:= gt(x,0)
        }
    }
}