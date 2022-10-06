//SPDX-License-Identifier:GPL-3.0
pragma solidity >0.5.0 <0.9.0;
contract Lottery{
    address public manager;
    address payable[] public paritcipants;

    constructor(){
        manager=msg.sender;
    }
    receive() external payable{
        require(msg.value==1 ether );
        paritcipants.push(payable(msg.sender));
    }

function getBalance() public view returns(uint){
    require(msg.sender==manager);
    return address(this).balance;
}
function random() public view returns(uint){
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, paritcipants.length)));

}


function selectWinner() public
{
    require(msg.sender==manager);
    require(paritcipants.length>=3);
    uint r=random();
    uint index=r % paritcipants.length;
    address payable winner;
    winner=paritcipants[index];
    winner.transfer(getBalance());
    paritcipants=new address payable[](0);
}
}