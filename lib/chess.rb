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
        @turn = "white"

        initialize_white() # player one
        initialize_black() # player two

        play()
    end

    # main play loop method
    def play
        begin
            loop do
                update_display()
                from = get_first()
                to = get_second(from)
                begin
                    move(from, to)
                rescue InvalidMoveError => e
                    e.message(from, to)
                    to = get_second(from)
                    retry
                end
                # check for win conditions
                if checkmate?()
                    congratulate()
                    return
                else
                    end_turn()
                end
            end
        rescue Interrupt => e
            print "\nAre you sure you want to quit the game?\n"
            print "(yes/no): "
            choice = gets.chomp
            if choice == "yes"
                # ask player about saving here
                return
            else
                retry
            end
        ensure
            puts "Thanks for playing!"
        end
    end

    # called after player makes move
    def checkmate?
        case @turn
        when "white"
            king = find_king(@black)
            king_square = king.pos
            # does not currently check whether move is on board
            # does not currently check whether another piece is in the way
            moves = possible_moves(king)
            # for every possible move, if the king is still in check it is checkmate
            checkmate = moves.all? do |move|
                king.pos = move
                check?()
            end
            if checkmate
                return true
            else
                king.pos = king_square
                return false
            end
        when "black"
            king = find_king(@white)
            king_square = king.pos
            # does not currently check whether move is on board
            # does not currently check whether another piece is in the way
            moves = possible_moves(king)
            # for every possible move, if the king is still in check it is checkmate
            checkmate = moves.all? do |move|
                king.pos = move
                check?()
            end
            if checkmate
                return true
            else
                king.pos = king_square
                return false
            end
        end
    end

    def possible_moves king
        sq = king.pos.split("")
        moves = []
        moves.push([sq[0], (sq[1].to_i + 1).to_s]).join("") # up
        moves.push([sq[0], (sq[1].to_i - 1).to_s]).join("") # down
        moves.push([(sq[0].ord - 1).chr, sq[1]].join("")) # left
        moves.push([(sq[0].ord + 1).chr, sq[1]].join("")) # right
        moves.push([sq[0].ord - 1).chr, (sq[1].to_i + 1).to_s].join("")) # up-left
        moves.push([sq[0].ord + 1).chr, (sq[1].to_i + 1).to_s].join("")) # up-right
        moves.push([sq[0].ord - 1).chr, (sq[1].to_i - 1).to_s].join("")) # down-left
        moves.push([sq[0].ord + 1).chr, (sq[1].to_i - 1).to_s].join("")) # down-right

        # identify which moves are valid
        valid_moves = moves.select do |move|
            king.valid_move?(king.pos, move, @white, @black)
        end

    def congratulate
        # TODO
    end

    def check?
        case @turn
        when "white"
            king_square = find_king(@white).pos
            @black.any? do |piece|
                piece.valid_move?(piece.pos, king_square, @white, @black)
            end
        when "black"
            king_square = find_king(@black).pos
            @white.any? do |piece|
                piece.valid_move?(piece.pos, king_square, @white, @black)
            end
        end
    end

    def find_king set
        set.find { |item| item.type == "king" }
    end

    def get_first
        begin
            update_display()
            print "\nSelect which piece to move: "
            from = gets.chomp()
            if !on_board?(from)
                raise OffBoardError
            end
            piece = find_piece(from, @white, @black)
            if !piece
                raise NoPieceFoundError
            end
            if @turn != piece.color
                raise WrongSetError
            end
        rescue OffBoardError => e
            e.message()
            retry
        rescue NoPieceFoundError => e
            e.message(from)
            retry
        rescue WrongSetError => e
            e.message()
            retry
        end
        return from
    end

    def get_second from
        begin
            update_display()
            first = find_piece(from, @white, @black)
            print "\nSelect where to move #{first.type} at #{from}: "
            to = gets.chomp()
            if !on_board?(to)
                raise OffBoardError
            end
            piece = find_piece(to, @white, @black)
            if piece && piece.color == @turn
                raise SameSetError
            end
        rescue Interrupt
            from = get_first()
            retry
        rescue OffBoardError => e
            e.message()
            retry
        rescue SameSetError => e
            e.message(find_piece(to, @white, @black))
            retry
        end
        return to
    end

    def end_turn()
        if @turn == "white"
            @turn = "black"
        else
            @turn = "white"
        end
    end

    # moves piece from one square (from) to another (to)
    # manipulates internal states of objects. return value unimportant
    def move from, to
        # get piece
        piece = find_piece(from, @white, @black)
        # if move is valid, execute it and increment piece's move counter
        if piece.valid_move?(from, to, @white, @black)
            
            # check for piece at destination square.  remove it first if so
            second = find_piece(to, @white, @black)
            if second
                # remove piece from corresponding set
                case second.color
                when "white"
                    @white.delete(second)
                when "black"
                    @black.delete(second)
                end 
            end
            
            # move piece to new location
            piece.pos = to
            piece.move += 1
        else
            raise InvalidMoveError
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

    # redraws the display including the board and game text
    def update_display
        refresh()
        print "<<<<<<<<<<black>>>>>>>>>>\n"
        draw_board()
        print "<<<<<<<<<<white>>>>>>>>>>\n\n"
        if check?()
            print "You have been checked, #{@turn}. Protect your king\n"
        else
            print "It's your turn, #{@turn}\n"
        end
    end

    # draws the board to the console
    def draw_board
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

class OffBoardError < StandardError
    def message
        print "Location is not on the board. Please try again\n"
        print "Press Enter to continue"
        gets.chomp()
    end
end

class NoPieceFoundError < StandardError
    def message square
        print "No piece found at #{square}. Please try again\n"
        print "Press Enter to continue"
        gets.chomp()
    end
end

class SameSetError < StandardError
    def message piece
        print "Cannot attack own #{piece.type} at #{piece.pos}. Please try again\n"
        print "Press Enter to continue"
        gets.chomp()
    end
end

class WrongSetError < StandardError
    def message
        print "You may not move your opponent's pieces. Please try again\n"
        print "Press Enter to continue"
        gets.chomp()
    end
end

class InvalidMoveError < StandardError
    def message from, to
        print "Invalid move from #{from} to #{to}\n"
        print "Press Enter to continue"
        gets.chomp()
    end
end

Chess.new()