// SPDX-License-Identifier: SimPL-2.0
pragma solidity  ^0.7.5;
 library TransferHelper {
    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }
 function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }
        
    }  
contract SafeMath {
  function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
  function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
    assert(b > 0);
    uint256 c = a / b;
    assert(a == b * c + a % b);
    return c;
  }
  function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
    uint256 c = a + b;
    assert(c>=a && c>=b);
    return c;
  }
}   
contract cctairdrop is SafeMath{
   address payable public owner; //管理员地址
   address payable public pairaddress = 0xE8377eCb0F32f0C16025d5cF360D6C9e2EA66Adf; //交易对的地址
   uint public Intervals = 14400;//间隔时间，均匀分红
   uint public last_time = 0;//上次分红时间
   uint public reward = 10e12;//一次分红的数量
   address token = 0xE8377eCb0F32f0C16025d5cF360D6C9e2EA66Adf;//token合约地址 
constructor() {
        owner = msg.sender;
    }
    
	receive() payable external {
       msg.sender.transfer(msg.value);//退回转入的qki
        airdrop();
    }
  
//设置给交易池子一次空投的数量
    function set_reward(uint new_reward) public {
        require(msg.sender == owner);
        reward = new_reward;
    }
    //设置分红的交易池的地址
     function set_new_pairaddress(address payable new_pair) public {
        require(msg.sender == owner);
        pairaddress =new_pair;
    }
   //设置管理员
    function setOwner(address payable new_owner) public {
        require(msg.sender == owner);
        owner = new_owner;
    }
    //设置分红的时间间隔
    function setIntervals(uint new_Intervals) public {
        require(msg.sender == owner);
        Intervals = new_Intervals;
    }
    //空投
    function airdrop() public {
    require(block.timestamp - last_time >= Intervals);//分红必须要有一定的时间间隔
    TransferHelper.safeTransfer(token,pairaddress, reward);    
    last_time = block.timestamp;
    }
}
