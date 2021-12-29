// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Bank {

    //Declaration
    uint numOfCustomers;
    mapping (uint => user) customer;
    struct user {
        address customerAddress;
        uint customerBalance;
        string accountType;
    }

    //Constructor
    constructor () {
        numOfCustomers = 0;
    }
    
    //You can deposit your money by this function
    function deposit (string memory myType) external payable {
        //This will help to realize old customers
        bool oldCustomer = false;

        for (uint i = 0; i < numOfCustomers; i++) {
            if(customer[i].customerAddress == msg.sender) {
                customer[i].customerBalance += msg.value;
                oldCustomer = true;
                break;
            }
        }
        if(oldCustomer == false) {
            customer[numOfCustomers].customerAddress = msg.sender;
            customer[numOfCustomers].customerBalance = msg.value;
            customer[numOfCustomers].accountType = myType;
            numOfCustomers ++;
        }
    }

    //You can withdraw your money by this function
    function withdraw () public {
        // If we already have this customer, this will be true
        bool oldCustomer = false;

        for (uint i = 0; i < numOfCustomers; i++) {
            if(customer[i].customerAddress == msg.sender) {
                uint totalBalance = customer[i].customerBalance;
                require(totalBalance > 0,'You have already received your money!!');
                address payable tempAddress = payable(msg.sender);
                tempAddress.transfer(totalBalance);
                // We will remove the customer
                customer[i].customerBalance = 0;
                oldCustomer = true;
                break;
            }
        }
        if(oldCustomer == false) {
            require(oldCustomer == true,'You do not have any money in this Bank!');
        }
    }

    //You can access your balance by this function
    function getBalance () public view returns (uint totalBalance) {
        // If we already have this customer, this will be true
        bool oldCustomer = false;

        for (uint i = 0; i < numOfCustomers; i++) {
            if(customer[i].customerAddress == msg.sender) {
                totalBalance = customer[i].customerBalance;
                oldCustomer = true;
                break;
            }
        }
        if(oldCustomer == true) {
            return totalBalance;
        }
        else {
            require (oldCustomer == true,'You do not have an account in this bank!');
        }      
    }
}
