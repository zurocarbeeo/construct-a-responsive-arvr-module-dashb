pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";

contract ARVRModuleDashboard {
    using SafeMath for uint256;

    // User Structure
    struct User {
        address userAddress;
        uint256 userId;
        string name;
        uint256[] ownedModules;
    }

    // Module Structure
    struct Module {
        uint256 moduleId;
        string moduleName;
        string description;
        uint256 price;
        uint256[] compatibleDevices;
    }

    // Mapping of Users
    mapping (address => User) public users;

    // Mapping of Modules
    mapping (uint256 => Module) public modules;

    // Event emitted when a new user is registered
    event NewUser(address indexed userAddress, uint256 userId);

    // Event emitted when a new module is added
    event NewModule(uint256 moduleId, string moduleName);

    // Event emitted when a user purchases a module
    event ModulePurchased(uint256 moduleId, address indexed userAddress);

    // Function to register a new user
    function registerUser(string memory _name) public {
        users[msg.sender].userAddress = msg.sender;
        users[msg.sender].userId = uint256(keccak256(abi.encodePacked(users[msg.sender].userAddress)));
        users[msg.sender].name = _name;
        emit NewUser(msg.sender, users[msg.sender].userId);
    }

    // Function to add a new module
    function addModule(string memory _moduleName, string memory _description, uint256 _price, uint256[] memory _compatibleDevices) public {
        uint256 moduleId = uint256(keccak256(abi.encodePacked(modulesCount)));
        modules[moduleId].moduleId = moduleId;
        modules[moduleId].moduleName = _moduleName;
        modules[moduleId].description = _description;
        modules[moduleId].price = _price;
        modules[moduleId].compatibleDevices = _compatibleDevices;
        emit NewModule(moduleId, _moduleName);
    }

    // Function to purchase a module
    function purchaseModule(uint256 _moduleId) public payable {
        require(modules[_moduleId].price == msg.value, "Insufficient funds");
        users[msg.sender].ownedModules.push(_moduleId);
        emit ModulePurchased(_moduleId, msg.sender);
    }

    // Function to get a user's owned modules
    function getOwnedModules(address _userAddress) public view returns (uint256[] memory) {
        return users[_userAddress].ownedModules;
    }
}