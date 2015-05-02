# Chess

Chess is a classic strategy board game built with Ruby classes in collaboration with [Christina Zabalza]. It utilizes inheritance to minimize redundant code. You will need to have Ruby installed on your computer to play the game. Follow the instructions below to run the code.

[Christina Zabalza]: https://github.com/czabalza

## Demo Instructions

1. Install Ruby by following the instructions for your operating system on the Ruby Programming Language website: [Installing Ruby][install-ruby]
[install-ruby]: https://www.ruby-lang.org/en/documentation/installation/
2. In your command line, download this repository on your computer using the following command:
```git clone https://github.com/vincentshieh/Chess.git```
3. Navigate into the Chess folder: ```cd Chess```

4. Open up IRB (Interactive Ruby): ```irb```

5. Require the Ruby game file: ```require './game'```

6. Load the seed game: ```Game.load```

7. Move the black queen to a checkmate position: ```d8, h4```

The following screenshots summarize the demo instructions:
![demo1]
![demo2]
![demo3]

[demo1]: ./screenshots/demo1.png
[demo2]: ./screenshots/demo2.png
[demo3]: ./screenshots/demo3.png

## Code Highlights
* The Rook, Bishop, and Queen classes inherit from the SlidingPiece class, which uses the following method to return an array of valid move positions for one sliding direction:
```ruby
def valid_moves_in_dir(delta)
  valid_moves = []
  multiplier = 1
  current_move = [pos[0] + multiplier * delta[0],
                  pos[1] + multiplier * delta[1]]

  until edge_of_board?(current_move) ||
    (blocked?(current_move) && board[current_move].color == color)
    valid_moves << current_move
    break if blocked?(current_move)

    multiplier += 1
    current_move = [pos[0] + multiplier * delta[0],
                    pos[1] + multiplier * delta[1]]
  end

  valid_moves
end
```
We continue to move away from the current position of the piece in the direction of ```delta``` until we reach the edge of the board or get blocked by another piece. A blocked position is added to our list of valid moves if the piece occupying that position is of the opposite color.

To construct an array containing all valid moves for any sliding piece, we call ```valid_moves_in_dir``` for each direction a piece can move in and concatenate all of those arrays:
```ruby
def moves
  all_moves = []

  move_dirs.each do |dir|
    all_moves += valid_moves_in_dir(dir)
  end

  all_moves
end
```
