# zebra


## Strings in EVM
Example:-
We are returning a string `hello` using inline assembly in the below function 

```solidity
function hello() public pure returns(string memory){
        assembly{
            mstore(0x00,0x20)
            mstore(0x20,0x5)
            mstore(0x40,0x68656c6c6f000000000000000000000000000000000000000000000000000000)
            return(0x00,0x60)
        }
    }
```

### Basic things to know before starting 
- Assembly language is used for low level access to the EVM . 
- Strings are dynamic types .
- Memory layout in solidity is as follows:-

 ```
 {
	"0x00": "0000000000000000000000000000000000000000000000000000000000000000",
	"0x20": "0000000000000000000000000000000000000000000000000000000000000000",
	"0x40": "0000000000000000000000000000000000000000000000000000000000000080"
}
 ```
 First 2 slots are reserved for hashing methods, 0x40 stores the address that points to an area that is not used a.k.a Free memory Pointer . 

Strings are dynamic types , they are stored as follows:
- First we store the pointer to the start of the dynamic data i.e offset 
- Then store the length of the string in the next slot . 
- In the next slot, we store the string in Hex format right padded . 

Example - Store "hello" 

1) If we want to start the data at 0x20, 
We will first store the pointer at 0x00 , 

```solidity
assembly{
  mstore(0x00, 0x20)
}
```

Memory : -

```
"0x00" 0000000000000000000000000000000000000000000000000000000000000020
"0x20": "0000000000000000000000000000000000000000000000000000000000000000",
"0x40": "0000000000000000000000000000000000000000000000000000000000000080"

```
2) Now we store the length of the string at the pointer we declared above: 

`hello` is of length 5 . 
In hex 5 = 0x5

```solidity
assembly{
  mstore(0x00,0x20)
  mstore(0x20,0x5)
}
```

Memory :-

```
"0x00" 0000000000000000000000000000000000000000000000000000000000000020
"0x20": "0000000000000000000000000000000000000000000000000000000000000005",
"0x40": "0000000000000000000000000000000000000000000000000000000000000080"
```

3) Next, we store the actual string in hex format in the next memory slot 

`hello` in hex -> 0x0568656c6c6f

All the values cover full 32 bytes , hence remaining values will be 0 padded upto 32 bytes. 

```solidity
assembly{
mstore(0x00,0x20)
mstore(0x20,0x5)
mstore(0x40,0x0568656c6c6f0000000000000000000000000000000000000000000000000000)
}
```
Memory :- 

```
"0x00" 0000000000000000000000000000000000000000000000000000000000000020
"0x20": "0000000000000000000000000000000000000000000000000000000000000005",
"0x40": "0568656c6c6f0000000000000000000000000000000000000000000000000000"
```

Now we return the data using the `return ` opcode 

```solidity
assembly{
mstore(0x00,0x20)
mstore(0x20,0x5)
mstore(0x40,0x0568656c6c6f0000000000000000000000000000000000000000000000000000)
return(0x00,0x60)
}
```

But if you view the result it will return only `hell` instead of `hello`
 
That is because  `hello` in hex -> `0x0568656c6c6f` , this hex code has 05 in the beginning , which implies the length of the string i.e 5 . 

Therefore , there are 2 options to return `hello` correctly 
- Either enter length in the slot 0x20 as 6 instead of 5.
- Or , remove 05 from the `0x0568656c6c6f` .


Final code is :
```solidity
function hello() public pure returns(string memory){
        assembly{
            mstore(0x00,0x20)
            mstore(0x20,0x5)
            mstore(0x40,0x68656c6c6f000000000000000000000000000000000000000000000000000000)
            return(0x00,0x60)
        }
    }
```

OR

```solidity
function hello() public pure returns(string memory){
        assembly{
            mstore(0x00,0x20)
            mstore(0x20,0x6)
            mstore(0x40,0x0568656c6c6f000000000000000000000000000000000000000000000000000000)
            return(0x00,0x60)
        }
    }
```


 
 

