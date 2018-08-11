# frozen_string_literal: true

class ConnectFourController < ApplicationController
  def index; end

  def check
    @board = Board.new
    @moves = params[:moves].split(',')
    @board.load_game(@moves)
    @winner = @board.check_for_win
    @res = ''
    if @winner == Board::EMPTY
      @res = 'Tie' if @moves.length == 42
    else
      @res = "Player #{@winner} Wins!"
    end

    respond_to do |format|
      format.html
      format.json { render json: { res: @res } }
    end
  end
end
