//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract WDToken is ERC20, Ownable {
    using SafeMath for uint256;
    uint256 tokensOneEthCanBuy = 1000;   
    address[] internal _stakeholders;
    // map stakes for each stakeholder
    mapping(address => uint256) internal stakes;
    // map accumulated rewards for each stakeholder
    mapping(address => uint256) internal rewards;
    // map reward time for each stakeholder
    mapping(address => uint256) public rewardTimer;

    event Buy(address indexed addr, bool value);
    event ModifyPrice(uint256 value);
    event Stake(address addr, uint256 stake);
    event Reward(address addr, uint256 reward, bool value);
    // event _Transfer(address indexed from, address indexed to, uint256 value);

    constructor() ERC20("WDToken", "WDT") {
        _mint(msg.sender, 1000 * 10**18);        
    }   

    // check if an address is a stakeholder
    function isStakeholder(address _address) public view returns(bool, uint256) {
        for (uint256 s = 0; s < _stakeholders.length; s += 1){
            if (_address == _stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    // token owner can modify token buy price
    function modifyTokenBuyPrice(uint256 _tokensOneEthCanBuy) external onlyOwner {
        tokensOneEthCanBuy = _tokensOneEthCanBuy;
        emit ModifyPrice(tokensOneEthCanBuy);
    }

    // site visitors can buy tokens
    function buyToken(address receiver) public payable {
        require(msg.value > 0, "You don't have enough Ether in your account");
        uint amount = msg.value * tokensOneEthCanBuy;
        _mint(receiver, amount);
        emit Buy(receiver, true);
    }

    // add a stakeholder
    function addStakeholder(address _stakeholder) public {
       (bool _isStakeholder, ) = isStakeholder(_stakeholder);
       if(!_isStakeholder) _stakeholders.push(_stakeholder);
    }

    // remove a stakeholder
    function removeStakeholder(address _stakeholder) public {
       (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
       if(_isStakeholder) {
           _stakeholders[s] = _stakeholders[_stakeholders.length - 1];
           _stakeholders.pop();
       }
    }

    // retrieve the stake for a stakeholder; return uint256 The amount of wei staked.
    function stakeOf(address _stakeholder) public view returns(uint256) {
       return stakes[_stakeholder];
    }
      // stakeholder can create a stake
    function createStake(uint256 _stake) public {
       _burn(msg.sender, _stake);
       require(balanceOf(msg.sender) > 0, "You don't have ExTokens yet, Start by buying ExTokens");
       if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
       stakes[msg.sender] = stakes[msg.sender].add(_stake);
        rewardTimer[msg.sender] = block.timestamp;
        emit Stake(msg.sender, _stake);
    }

    // stakeholder can claim rewards
    function claimReward() public {
        // if (block.timestamp >= rewardTimer[msg.sender] + 7 days) {
        if (block.timestamp >= rewardTimer[msg.sender] + 60 seconds) {
            // require(isStakeholder(msg.sender), "You don't have a stake yet, Start by buying ExTokens");
            uint256 reward = (stakes[msg.sender] * 1) / 100;
            rewardTimer[msg.sender] = block.timestamp;
            emit Reward(msg.sender, reward, true);
        } else {
            emit Reward(msg.sender, 0, false);
        }
    }

}