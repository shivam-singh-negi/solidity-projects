//SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
mapping(address=>uint) public contributers;
address public manager;
uint public minimumContribution;
uint public target;
uint public raisedAmount;
uint public deadline;
uint public noOfContributors;

struct Request{
    string description;
    address payable recipient;
    uint value;
    bool completed;
    uint noOfVoters;
    mapping(address=>bool) voters;

}

mapping(uint=>Request) public request;
uint public numRequest;


constructor(uint _target, uint _deadline){
    target=_target;
    deadline=block.timestamp+_deadline; // 10 sec+ 36000
    minimumContribution=100 wei;
    manager=msg.sender;
}

function sendEth() public payable{
    require(block.timestamp < deadline,"Deadline has passed");
    require(msg.value >=minimumContribution,"Minimum Contribution is not met");
    if(contributers[msg.sender]==0){
        noOfContributors++;
    }
    contributers[msg.sender]+=msg.value;
    raisedAmount+=msg.value;
}

function getContractBalance() public view returns(uint){
    return address(this).balance;
}
function refund() public{
    require(block.timestamp>deadline && raisedAmount>target,"Your are not eligible for refund");
    require(contributers[msg.sender]>0);
    address payable user=payable(msg.sender);
    user.transfer(contributers[msg.sender]);
    contributers[msg.sender]=0;
}




modifier onlyManger(){
    require(msg.sender==manager,"Only manager can call this function");
 _;
}

function creatRequest(string memory _description, address payable _recipient, uint _value) public onlyManger{

    Request storage newReq=request[numRequest];
    numRequest++;
    newReq.description=_description;
    newReq.recipient=_recipient;
    newReq.value=_value;
    newReq.completed=false;
    newReq.noOfVoters=0;


}


function voteRequest(uint _requestNo) public{
require(contributers[msg.sender]>0,"You must be a contributor");
Request storage thisRequest=request[_requestNo];
require(thisRequest.voters[msg.sender]==false,"You have already voted");
thisRequest.voters[msg.sender]=true;
thisRequest.noOfVoters++;

}


function makePayment(uint _requestNo) public onlyManger{
require(raisedAmount>=target);
Request storage thisRequest=request[_requestNo];
require(thisRequest.completed==false,"the request has been completed");
require(thisRequest.noOfVoters>noOfContributors/2,"majority does not support");
thisRequest.recipient.transfer(thisRequest.value);
thisRequest.completed=true;



}


}