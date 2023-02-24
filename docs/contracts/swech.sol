// SPDX-License-Identifier: Unlicensed
// (C) Sam, 543#3017, Guru Network, 2022-9999
// Lockless Protocol: Receipt Token
/*

Create a farm & vault for your own projects for free with ftm.guru

            Contact us at:
    https://discord.gg/QpyfMarNrV
        https://t.me/FTM1337

    -  LITE  FARMLANDS  -
    - KOMPOUND PROTOCOL -
    - GRANARY & WORKERS -
    https://ftm.guru/GRAIN

    Yield Compounding Service
    Created by Guru Network

    Community Mediums:
        https://discord.com/invite/QpyfMarNrV
        https://medium.com/@ftm1337
        https://twitter.com/ftm1337
        https://twitter.com/kucino
        https://t.me/ftm1337

    Other Products:
        Kucino - The First and Most used Casino of KCC
        fmc.guru - FantomMarketCap : On-Chain Data Aggregator
        ELITE - ftm.guru is an indie growth-hacker for Fantom
        Lockless Protocol - Liquid Staking for Cosmos-SDK chains
        Kompound Protocol - The only immutable yield-compounder
*/
pragma solidity ^0.7.0;

contract LocklessReceipt {
    string public name;
    string public symbol;

    uint8 public decimals = 18;
    uint  public totalSupply;

    address public locker;
    address public manager;

    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);

    mapping (address => uint) public  balanceOf;
    mapping (address => mapping (address => uint)) public  allowance;

    constructor(address l, address m, string memory n, string memory s) {
        locker = l;
        manager = m;
        name = n;
        symbol = s;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        locker.call{value:msg.value}("");
        balanceOf[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Transfer(address(0), msg.sender, msg.value);
    }

    function burn(uint b) public {
    	require( balanceOf[msg.sender] >= b, "Insufficient!")
        balanceOf[msg.sender] -= b;
        totalSupply -= b;
        emit Transfer(msg.sender, address(0), b);
    }

    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad, "Insufficient!");

        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }

    function setLocker(address l) external {
    	require(msg.sender==manager, "Not a manager!");
    	locker = l;
    }

    function setManager(address m) external {
    	require(msg.sender==manager, "Not a manager!");
    	manager = m;
    }
}
