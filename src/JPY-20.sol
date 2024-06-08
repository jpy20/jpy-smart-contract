// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract JPY20Token is ERC20, Ownable {
    uint256 public exchangeRate = 1;

    // This variable stores the total amount of tokens minted
    uint256 public _totalSupply = 0;
    address public _owner;

    // Mapping to track balances of each address
    mapping(address => uint256) public balances;
    mapping(address => bool) private minters;

    modifier onlyMinterOrOwner() {
        require(
            minters[_msgSender()] || _msgSender() == owner(),
            "JPY20: Caller is not the owner or minter"
        );
        _;
    }

    constructor(
        address initialOwner
    ) Ownable(initialOwner) ERC20("JPY20Token", "JPYT") {
        minters[_msgSender()] = true;
        _owner = _msgSender();
        _mint(_msgSender(), 1000000 * (10 ** uint256(decimals()))); // Initial supply
    }

    function balanceOf(
        address tokenOwner
    ) public view override returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function owner() public view override returns (address) {
        return _owner;
    }

    function mint(
        address recipient,
        uint256 amount
    ) external onlyMinterOrOwner {
        _totalSupply += amount;
        balances[recipient] += amount;
        _mint(recipient, amount);
    }
    // Function to burn tokens
    function burn(uint256 amount) external onlyMinterOrOwner {
        _totalSupply -= amount;
        balances[msg.sender] -= amount;
        _burn(msg.sender, amount);
    }

    // Function to set the exchange rate
    function setExchangeRate(uint256 newRate) external onlyMinterOrOwner {
        exchangeRate = newRate;
    }

    // Function to exchange Yen to HybridYen
    function exchangeYenToJPY20(uint256 yenAmount) external {
        uint256 hybridYenAmount = yenAmount * exchangeRate;
        _mint(msg.sender, hybridYenAmount);
    }

    function getMinterRole(address _address) public view returns (bool) {
        return minters[_address];
    }

    // Function to grant mint role
    function addMinterRole(address _address) external onlyOwner {
        minters[_address] = true;
    }

    // Function to revoke mint role
    function revokeMinterRole(address _address) external onlyOwner {
        minters[_address] = false;
    }
}
