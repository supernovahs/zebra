pragma solidity ^0.8.13;

/// @notice  Returns string using low level yul call 
/// @author Zebra 
library  StringInYul{

/*//////////////////////////////////////////////////////////////
                    Return String using Assembly 
    //////////////////////////////////////////////////////////////*/
function hello() public pure returns(string memory){
        assembly{
            mstore(0x00,0x20)
            mstore(0x20,0x5)
            mstore(0x40,0x68656c6c6f000000000000000000000000000000000000000000000000000000)
            return(0x00,0x60)
        }
    }

}