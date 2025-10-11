require_relative './piece'

class Pawn < Piece
  def initialize(color)
    super(color)
    @display_name = 'P'
  end

  def is_illegal_move?(rowFrom, colFrom, rowTo, colTo, direction)
    if rowFrom == rowTo || (colFrom - colTo).abs > 1 || (rowFrom - rowTo).abs > 2 || ((colFrom - colTo).abs == 1 && (rowFrom - rowTo).abs != 1)
      true
    else
      direction == :up ? (rowTo > rowFrom) : (rowTo < rowFrom)
    end
  end

  def capture_result(rowTo, colTo, grid)
    destination_square = grid[rowTo][colTo]
    if destination_square.nil?
      :illegal
    elsif destination_square.color == color
      :blocked
    else
      :capture
    end
  end

  def valid_move?(from, to, grid = nil, en_passant_target = nil)
    return :illegal if from == to

    colFrom = from[1]
    colTo   = to[1]
    rowFrom = from[0]
    rowTo   = to[0]

    if @color == :white
      return :illegal if is_illegal_move?(rowFrom, colFrom, rowTo, colTo, :up)

      # ✅ En passant capture
      if en_passant_target && to == en_passant_target
        captured_row = color == :white ? to[0] + 1 : to[0] - 1
        captured_piece = grid[captured_row][to[1]]
        return :illegal unless captured_piece&.is_a?(Pawn) && captured_piece.color != color

        return :ok
      end

      # Regular capture
      return capture_result(rowTo, colTo, grid) if (colFrom - colTo).abs == 1 && (rowFrom - rowTo).abs == 1

      # Regular pawn moves
      if rowFrom == 6
        if rowTo >= 4
          rowFrom -= 1
          while rowFrom >= rowTo
            return :blocked unless grid[rowFrom][colFrom].nil?

            rowFrom -= 1
          end
          :ok
        else
          :illegal
        end
      elsif (rowTo - rowFrom).abs == 1
        grid[rowTo][colTo].nil? ? :ok : :blocked
      else
        :illegal
      end

    elsif @color == :black
      return :illegal if is_illegal_move?(rowFrom, colFrom, rowTo, colTo, :down)

      # ✅ En passant capture
      if en_passant_target && to == en_passant_target
        captured_row = color == :white ? to[0] + 1 : to[0] - 1
        captured_piece = grid[captured_row][to[1]]
        return :illegal unless captured_piece&.is_a?(Pawn) && captured_piece.color != color

        return :ok
      end

      # Regular capture
      return capture_result(rowTo, colTo, grid) if (colFrom - colTo).abs == 1 && (rowFrom - rowTo).abs == 1

      # Regular pawn moves
      if rowFrom == 1
        if rowTo <= 3
          rowFrom += 1
          while rowFrom <= rowTo
            return :blocked unless grid[rowFrom][colFrom].nil?

            rowFrom += 1
          end
          :ok
        else
          :illegal
        end
      elsif rowTo - rowFrom == 1
        grid[rowTo][colTo].nil? ? :ok : :blocked
      else
        :illegal
      end
    end
  end
end
