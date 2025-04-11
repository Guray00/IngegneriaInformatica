function handleSaveBoard(event) {
  event.preventDefault();

  if (!authContext.loggedIn) {
    alert("Please log in to save your board.");
    return;
  }

  const boardName = document.getElementById("boardNameInput").value;
  const repr = new Compressor(Array.from(gameCanvas.cellList)).getBuffer();

  apiContext.saveBoard(boardName, repr).then(({ data }) =>
    userDashboard.addBoard({
      name: boardName,
      repr,
      board_id: data.board_id,
      timestamp: data.timestamp,
    }),
  );
}

function handleDeleteBoard(board_id) {
  apiContext.deleteBoard(board_id);
  userDashboard.removeBoard(board_id);
}
