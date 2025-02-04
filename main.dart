import 'dart:io';
import 'dart:math';

enum GameMode { humanVsHuman, humanVsComputer }

void main() {
  while (true) {
    GameMode gameMode = getGameMode();
    playGame(gameMode);
    stdout.write('Хотите сыграть еще раз? (Да/Нет): ');
    String playAgain = stdin.readLineSync()!.toLowerCase();
    if (playAgain != 'Да') {
      break;
    }
  }
}

GameMode getGameMode() {
    while (true){
        stdout.write("Выберите режим игры:\n1. Человек против человека\n2. Человек против компьютера\n(1/2): ");
       String? input = stdin.readLineSync();
       if(input == null){
         continue;
       }
       if (input == '1'){
           return GameMode.humanVsHuman;
       } else if(input == '2'){
          return GameMode.humanVsComputer;
       } else {
         print("Некорректный ввод, попробуйте еще раз.");
       }
    }

}


void playGame(GameMode gameMode) {
  int boardSize = getBoardSize();
  List<List<String>> board = createBoard(boardSize);
  String currentPlayer = (Random().nextBool() ? 'X' : 'O');


  bool gameOver = false;

  while (!gameOver) {
    printBoard(board);
    if (gameMode == GameMode.humanVsHuman || currentPlayer == 'X') {
          print("${currentPlayer} ход. Введите строку и столбец (например, 1 2):");
        String? input = stdin.readLineSync();
        if (input == null) {
          continue;
        }
          try {
            List<String> parts = input.split(' ');
            int row = int.parse(parts[0]) - 1;
            int col = int.parse(parts[1]) - 1;

            if (row < 0 || row >= boardSize || col < 0 || col >= boardSize || board[row][col] != '.') {
                  print("Некорректный ход, попробуйте еще раз.");
                  continue;
                }

            board[row][col] = currentPlayer;
          } catch (e) {
            print("Некорректный ввод. Пожалуйста, введите строку и столбец как '1 2'");
            continue;
          }
    } else {
        print("Ход компьютера:");
      List<int> move = getComputerMove(board, boardSize);
      board[move[0]][move[1]] = currentPlayer;

    }


    gameOver = checkWin(board, currentPlayer, boardSize);
     if (!gameOver) {
       gameOver = isBoardFull(board, boardSize);
     }


    if (gameOver) {
        printBoard(board);
        if (checkWin(board, currentPlayer, boardSize)){
          print("$currentPlayer победил!");
        } else {
          print("Ничья!");
        }
      break;
    }
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
  }
}

List<int> getComputerMove(List<List<String>> board, int boardSize) {
  List<List<int>> availableMoves = [];
  for (int i = 0; i < boardSize; i++){
    for (int j = 0; j < boardSize; j++){
      if (board[i][j] == '.'){
          availableMoves.add([i, j]);
      }
    }
  }
  if (availableMoves.isNotEmpty){
    return availableMoves[Random().nextInt(availableMoves.length)];
  }
    return [-1,-1];
}

int getBoardSize() {
  while (true) {
    stdout.write('Введите размер доски (3-9): ');
    String? input = stdin.readLineSync();
      if(input == null){
        continue;
      }
    try {
      int size = int.parse(input);
      if (size >= 3 && size <= 9) {
        return size;
      } else {
        print('Некорректный размер, попробуйте еще раз');
      }
    } catch (e) {
      print('Некорректный ввод, введите число');
    }
  }
}

List<List<String>> createBoard(int size) {
  return List.generate(size, (_) => List.filled(size, '.'));
}

void printBoard(List<List<String>> board) {
  int size = board.length;
  stdout.write('  ');
  for (int i = 1; i <= size; i++) {
    stdout.write('$i ');
  }
  stdout.write('\n');

  for (int i = 0; i < size; i++) {
    stdout.write('${i + 1} ');
    for (int j = 0; j < size; j++) {
      stdout.write('${board[i][j]} ');
    }
    stdout.write('\n');
  }
}

bool checkWin(List<List<String>> board, String player, int boardSize) {
 
  for (int i = 0; i < boardSize; i++) {
    if (board[i].every((cell) => cell == player)) {
      return true;
    }
  }

 
  for (int j = 0; j < boardSize; j++) {
    bool win = true;
    for (int i = 0; i < boardSize; i++) {
      if (board[i][j] != player) {
        win = false;
        break;
      }
    }
    if (win) {
      return true;
    }
  }

 
  bool diag1Win = true;
  bool diag2Win = true;
  for (int i = 0; i < boardSize; i++) {
    if (board[i][i] != player) {
      diag1Win = false;
    }
    if (board[i][boardSize - 1 - i] != player) {
      diag2Win = false;
    }
  }
  return diag1Win || diag2Win;
}

bool isBoardFull(List<List<String>> board, int boardSize) {
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      if (board[i][j] == '.') {
        return false;
      }
    }
  }
  return true;
}