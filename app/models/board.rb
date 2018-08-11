# frozen_string_literal: true

class Board
  ROWS = 6
  COLUMNS = 7
  PLAYER_ONE = 1
  PLAYER_TWO = 2
  EMPTY = 0

  class_attribute :board_state
  class_attribute :player_to_move

  def initialize
    @player_to_move = PLAYER_ONE
    @board_state = Array.new(ROWS, Array.new(COLUMNS, 0))
  end

  def load_game(moves)
    columns = []
    current_player = PLAYER_ONE

    (0..(COLUMNS - 1)).each do
      columns.push []
    end

    moves.each do |move|
      move = move.to_i
      raise "Invalid move #{move}" unless valid_move(move, columns[move].length)
      columns[move].unshift current_player
      current_player = current_player == PLAYER_ONE ? PLAYER_TWO : PLAYER_ONE
    end

    (0..(COLUMNS - 1)).each do |i|
      columns[i].unshift EMPTY while columns[i].length < ROWS
    end

    puts columns.to_s
    # Transpose to match what is shown on GUI board
    @board_state = columns.transpose
    puts @board_state.to_s
  end

  def valid_move(move, length)
    move >= 0 && move < COLUMNS && length < ROWS
  end

  def check_for_win
    (0..(ROWS - 1)).each do |r|
      (0..(COLUMNS - 1)).each do |c|
        player = @board_state[r][c]

        next unless player != EMPTY
        return player if c + 3 < COLUMNS &&
                         player == @board_state[r][c + 1] &&
                         player == @board_state[r][c + 2] &&
                         player == @board_state[r][c + 3]
        next unless r + 3 < ROWS
        return player if player == @board_state[r + 1][c] &&
                         player == @board_state[r + 2][c] &&
                         player == @board_state[r + 3][c]
        return player if c + 3 < COLUMNS &&
                         player == @board_state[r + 1][c + 1] &&
                         player == @board_state[r + 2][c + 2] &&
                         player == @board_state[r + 3][c + 3]
        return player if c - 3 >= 0 &&
                         player == @board_state[r + 1][c - 1] &&
                         player == @board_state[r + 2][c - 2] &&
                         player == @board_state[r + 3][c - 3]
      end
    end
    EMPTY
  end
end
