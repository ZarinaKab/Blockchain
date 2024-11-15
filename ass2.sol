// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


contract RockPaperScissors {
    address public owner;
    uint public constant BET_AMOUNT = 100000000000000; //wei 10^14
    event GameResult(address indexed player, uint betAmount, Choice playerChoice, Choice houseChoice, bool playerWon);
    event LogMessage(string message);


    enum Choice { Rock, Paper, Scissors } // Enum to represent player choices


    constructor() {
        owner = msg.sender;
    }


    // Function for the owner to deposit funds into the contract
    function depositFunds() external payable {
        require(msg.value >= BET_AMOUNT, "Deposit amount must be greater than or equal 100000000000000 wei");
    }


    // Function for players to participate in the game
    function play(Choice _playerChoice) external payable {
        require(msg.value == BET_AMOUNT, "You need 0.0001 tBNB which equal to 100000000000000 wei to play");


        // Generate house's choice
        Choice houseChoice = getHouseChoice();


        // Determine the winner
        (bool playerWon, string memory resultMessage) = determineWinner(_playerChoice, houseChoice);


        // Handle payout
        if (playerWon) {
            payable(msg.sender).transfer(BET_AMOUNT * 2); // Player wins double
        }


        // Log the game result
        emit GameResult(msg.sender, msg.value, _playerChoice, houseChoice, playerWon);


        // Log the result message
        emit LogMessage(resultMessage);
    }


    // Internal function to generate the house's choice randomly
    function getHouseChoice() internal view returns (Choice) {
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, block.number)));
        return Choice(random % 3); // 0 = Rock, 1 = Paper, 2 = Scissors
    }


    // Function to determine the winner
    function determineWinner(Choice playerChoice, Choice houseChoice) internal pure returns (bool, string memory) {
        if (playerChoice == houseChoice) {
            return (false, "It's a draw");
        } else if (
            (playerChoice == Choice.Rock && houseChoice == Choice.Scissors) ||
            (playerChoice == Choice.Scissors && houseChoice == Choice.Paper) ||
            (playerChoice == Choice.Paper && houseChoice == Choice.Rock)
        ) {
            return (true, "Player Win!");
        }
        return (false, "Player loses ;)");
    }


    // Function for the owner to withdraw funds from the contract
    function withdrawFunds(uint amount) external {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        require(amount <= address(this).balance, "Withdrawal amount exceeds balance");


        payable(owner).transfer(amount);
    }


    // Function to get the balance of the contract
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}


