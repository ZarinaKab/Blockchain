import React from 'react';

function GameHistory({ history }) {
  return (
    <div>
      <h2>Game History</h2>
      <ul>
        {history.map((game, index) => (
          <li key={index}>
            Player: {game.playerChoice}, Opponent: {game.opponentChoice}, Result: {game.result}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default GameHistory;
