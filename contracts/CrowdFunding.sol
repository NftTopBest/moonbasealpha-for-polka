// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

contract CrowdFunding {
    address immutable owner;

    constructor() {
        owner = msg.sender;
    }

    struct Campaign {
        address payable receiver;
        uint256 numFunders;
        uint256 fundingGoal;
        uint256 totalVoteUp;
        uint256 totalVoteDown;
        uint256 totalAmount;
    }

    struct Funder {
        address addr;
        uint256 amount;
        uint256 voteType;
    }

    uint256 public numCampagins;
    mapping(uint256 => Campaign) campaigns;
    mapping(uint256 => Funder[]) funders;
    mapping(address => uint256) public voteUpCount;
    mapping(address => uint256) public voteDownCount;

    Campaign[] public campaignsArray;
    mapping(uint256 => mapping(address => uint256)) public isVoteUpParticipate;
    mapping(uint256 => mapping(address => uint256))
        public isVoteDownParticipate;

    event CampaignLog(uint256 campaignID, address receiver, uint256 goal);
    event VoteLog(uint256 campaignID, address sender);

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    function newCampaign(address payable receiver, uint256 goal)
        external
        isOwner
        returns (uint256 campaignID)
    {
        campaignID = numCampagins++;
        Campaign storage c = campaigns[campaignID];
        c.receiver = receiver;
        c.fundingGoal = goal;
        c.totalVoteUp = 0;
        c.totalVoteDown = 0;
        c.totalAmount = 0;

        campaignsArray.push(c);
        emit CampaignLog(campaignID, receiver, goal);
    }

    // modifier judgeParticipate(uint campaignID, uint voteType) {
    //     if(voteType == 0){
    //         require(isVoteUpParticipate[campaignID][msg.sender] == false);
    //     }
    //     if(voteType == 1){
    //         require(isVoteDownParticipate[campaignID][msg.sender] == false);
    //     }
    //     _;
    // }

    function vote(address voteForAddress, uint256 voteType) external payable {
        if (voteType == 0) {
            voteUpCount[voteForAddress] += 1;
        }
        if (voteType == 1) {
            voteDownCount[voteForAddress] += 1;
        }
    }

    function bid(uint256 campaignID, uint256 voteType) external payable {
        Campaign storage c = campaigns[campaignID];
        c.totalAmount += msg.value;
        c.numFunders += 1;

        funders[campaignID].push(
            Funder({addr: msg.sender, voteType: voteType, amount: msg.value})
        );
        if (voteType == 0) {
            isVoteUpParticipate[campaignID][msg.sender] += 1;
            c.totalVoteUp += 1;
        }
        if (voteType == 1) {
            isVoteDownParticipate[campaignID][msg.sender] += 1;
            c.totalVoteDown += 1;
        }
        campaignsArray[campaignID] = c;
        emit VoteLog(campaignID, msg.sender);
    }

    function withdraw(uint256 campaignID) external returns (bool reached) {
        Campaign storage c = campaigns[campaignID];

        if (c.totalAmount < c.fundingGoal) {
            return false;
        }

        uint256 amount = c.totalAmount;
        c.totalAmount = 0;
        c.receiver.transfer(amount);
    }
}
