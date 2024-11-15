import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import GameHistory from './GameHistory';

const CONTRACT_ADDRESS = "YOUR_SMART_CONTRACT_ADDRESS";
const ABI = [...]; // Add your contract ABI here

function App() {
  const [account, setAccount] = useState(null);
  const [choice, setChoice] = useState(null);
  const [gameHistory, setGameHistory] = useState([]);
  
  const connectWallet = async () => {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      setAccount(accounts[0]);
    } else {
      alert("Please install MetaMask!");
    }
  };

  const playGame = async (choice) => {
    if (!account) return;
    
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

    try {
      const tx = await contract.play(choice);
      await tx.wait();
      fetchGameHistory();
    } catch (error) {
      console.error("Error playing the game:", error);
    }
  };

  const fetchGameHistory = async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, provider);
    
    try {
      const history = await contract.getGameHistory(); // Assuming `getGameHistory` returns an array of games
      setGameHistory(history);
    } catch (error) {
      console.error("Error fetching game history:", error);
    }
  };

  useEffect(() => {
    if (account) fetchGameHistory();
  }, [account]);

  return (
    <div className="App">
      <h1>Rock-Paper-Scissors Game</h1>
      {account ? (
        <>
          <p>Connected as: {account}</p>
          <button onClick={() => playGame(0)}>Rock</button>
          <button onClick={() => playGame(1)}>Paper</button>
          <button onClick={() => playGame(2)}>Scissors</button>
          <GameHistory history={gameHistory} />
        </>
      ) : (
        <button onClick={connectWallet}>Connect Wallet</button>
      )}
    </div>
  );
}

export default App;
