require "./lib/board.rb"
require "./lib/gamepiece.rb"
require "./lib/pawn.rb"
require "./lib/rook.rb"
require "./lib/knight.rb"
require "./lib/bishop.rb"
require "./lib/queen.rb"
require "./lib/king.rb"
require "./lib/finder.rb"

class Chess

    include Finder

    attr_accessor :board, :white, :black

    def initialize
        @board = Board.new()
        @alph_map = ["1", "2", "3", "4", "5", "6", "7", "8"].reverse()

        initialize_white()
        initialize_black()

        # play()
        draw_board()
    end

    # main play loop method
    def play
        loop do
            draw_board()
            print "Player one, it's your move: "
            from, to = (gets.chomp().split(", "))
            move(from, to)
        end
    end

    # moves piece from one square (from) to another (to)
    # manipulates internal states of objects. return value unimportant
    def move from, to
        # check whether first square contains a piece
        first = find_piece(from, @white, @black)
        if first && on_board?(to)
            # check whether second square contains a piece
            second = find_piece(to, @white, @black)
            if second
                # if move is valid, execute it and increment piece's move counter
                if first.valid_move?(from, to, @white, @black)
                    first.pos = to
                    first.move += 1
                    
                    # remove taken piece from corresponding set
                    case second.color
                    when "white"
                        @white.delete(second)
                    when "black"
                        @black.delete(second)
                    end
                    draw_board()
                else
                    puts "Invalid move from #{from} to #{to}"
                end
            else
                # if move is valid, execute it and increment piece's move counter
                if first.valid_move?(from, to, @white, @black)
                    first.pos = to
                    first.move += 1
                    draw_board()
                else
                    puts "Invalid move from #{from} to #{to}"
                end
            end
        else
            puts "No piece exists at square #{from}"
        end
    end

    # checks whether square is on the board
    def on_board? square
        coord = square.split("")
        if coord[0].ord < 97 || coord[0].ord > 104
            return false
        end
        if coord[1].to_i < 1 || coord[1].to_i > 8
            return false
        end
        # if coordinate checks pass, square is on board
        return true
    end

    # initializes pieces on white side of board
    def initialize_white
        @white = []
        @white.push(Rook.new("a1", "white"))
        @white.push(Knight.new("b1", "white"))
        @white.push(Bishop.new("c1", "white"))
        @white.push(Queen.new("d1", "white"))
        @white.push(King.new("e4", "white"))
        @white.push(Bishop.new("f1", "white"))
        @white.push(Knight.new("g1", "white"))
        @white.push(Rook.new("h1", "white"))
        @white.push(Pawn.new("a2", "white"))
        @white.push(Pawn.new("b2", "white"))
        @white.push(Pawn.new("c5", "white"))
        @white.push(Pawn.new("d2", "white"))
        @white.push(Pawn.new("e2", "white"))
        @white.push(Pawn.new("f2", "white"))
        @white.push(Pawn.new("g2", "white"))
        @white.push(Pawn.new("h2", "white"))
    end

    # initializes pieces on black side of board
    def initialize_black
        @black = []
        @black.push(Rook.new("a8", "black"))
        @black.push(Knight.new("b8", "black"))
        @black.push(Bishop.new("c8", "black"))
        @black.push(Queen.new("d8", "black"))
        @black.push(King.new("e8", "black"))
        @black.push(Bishop.new("f8", "black"))
        @black.push(Knight.new("g8", "black"))
        @black.push(Rook.new("h8", "black"))
        @black.push(Pawn.new("a7", "black"))
        @black.push(Pawn.new("b6", "black"))
        @black.push(Pawn.new("c7", "black"))
        @black.push(Pawn.new("d7", "black"))
        @black.push(Pawn.new("e7", "black"))
        @black.push(Pawn.new("f7", "black"))
        @black.push(Pawn.new("g7", "black"))
        @black.push(Pawn.new("h7", "black"))
    end

    # draws the board to the console
    def draw_board
        # refresh console before redrawing board. for better UI
        refresh()
        @board.board.each_with_index do |row, index|
            print @alph_map[index]
            row.each do |col|
                assigned = false
                # check white for piece
                # -- refactor using check_white
                if !assigned 
                    @white.each do |piece|
                        if piece.pos == col
                            print piece.sym.encode('utf-8')
                            assigned = true
                            break
                        end
                    end
                end
                # check black for piece
                # -- refactor using check_black
                if !assigned
                    @black.each do |piece|
                        if piece.pos == col
                            print piece.sym
                            assigned = true
                            break
                        end
                    end
                end
                print " \u25A1 " unless assigned
            end
            print "\n"
        end
        print "  A  B  C  D  E  F  G  H \n"
        return
    end

    # clears the console
    def refresh
        system("clear")
    end
end

# Chess.new().draw_board()