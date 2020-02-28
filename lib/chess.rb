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
        @turn = 1

        initialize_white() # player one
        initialize_black() # player two

        play()
    end

    # main play loop method
    def play
        begin
            loop do
                # from, to = (gets.chomp().split(", ")) # get input from player
                from = get_first()
                to = get_second(from)
                move(from, to)
                end_turn()
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

    def get_first
        begin
            update_display()
            print "\nSelect which piece to move: "
            from = gets.chomp()
            unless on_board?(from)
                raise
            end
        rescue
            print "Location is not on the board. Please try again\n"
            print "Press Enter to continue"
            gets.chomp()
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
            unless on_board?(to)
                raise
            end
        rescue Interrupt
            from = get_first()
            retry
        rescue => e
            print "Location is not on the board. Please try again\n"
            print "Press Enter to continue\n"
            gets.chomp()
            puts e
            retry
        end
        return to
    end

    def end_turn()
        if @turn == 1
            @turn = 2
        else
            @turn = 1
        end
    end

    # moves piece from one square (from) to another (to)
    # manipulates internal states of objects. return value unimportant
    def move from, to
        # check whether player selections are on board
        unless on_board?(from) && on_board?(to)
            puts "One or both selections do not exist on the board"
            return
        end

        first = find_piece(from, @white, @black)
        # check whether first square contains a piece
        if first
            second = find_piece(to, @white, @black)
            # check whether second square contains a piece
            if second
                # pieces should not be from same set
                if first.color == second.color
                    puts "#{second.color} #{second.type} already exists at #{to}"
                    return
                end
                
                # if move is valid, execute it and increment piece's move counter
                if first.valid_move?(from, to, @white, @black)
                    first.pos = to
                    first.move += 1
                    
                    # remove piece from corresponding set
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

    # redraws the display including the board and game text
    def update_display
        refresh()
        print "Player #{@turn}, it's your turn\n\n"
        draw_board()
        # print "Please type your move (separate with a comma): "
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

Chess.new()