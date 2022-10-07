//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract EventContract{

struct Event{
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
}

mapping(uint=>Event) public events;
mapping(address=>mapping(uint=>uint)) public tickets;
uint public nextId;

function creatEvent(string memory name,uint _date,uint _price,uint ticketCount)external{

require(_date>block.timestamp,"You can organize event for future date");
require(ticketCount>0,"You can organize event only if you can create more than 0 tickets");
events[nextId]=Event(msg.sender,name, _date, _price,ticketCount,ticketCount);

}


function buyTicket(uint id, uint quantity) external payable{
    require(events[id].date!=0,"This event does not exit");
    require(block.timestamp<events[id].date,"Event already occur");
    Event storage _event=events[id];
    require(msg.value==(_event.price*quantity),"Ether is not enough");
    require(_event.ticketRemain>quantity,"Not enough tickets");
    _event.ticketRemain-=quantity;
    tickets[msg.sender][id]+=quantity;

}

function transferTicket(uint id, uint quantity, address to) external{
     require(events[id].date!=0,"This event does not exit");
    require(block.timestamp<events[id].date,"Event already occur");
   require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
   tickets[msg.sender][id]-=quantity;
   tickets[to][id]+=quantity;
}
    
}
