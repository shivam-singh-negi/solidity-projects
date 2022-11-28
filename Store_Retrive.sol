
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Storage {

    int256 number;      // number can hold 256 bits integers

    function storeTheNumber(int256 num) public  {  //1st function to store the number 
        number = num;
    }
    function retrieveTheNumber() public view returns (int256){   // 2nd function to retrieve the number 
        return number;
    }
}
