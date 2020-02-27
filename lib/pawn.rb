require "./lib/gamepiece.rb"
require "./lib/finder.rb"

class Pawn < Gamepiece
    
    include Finder
    
    attr_accessor :pos, :move
    attr_reader :sym, :color, :type

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0
        @type = "pawn"

        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2659 "
        when "black"
            @sym = " \u265f "
        end
    end

    def message square, white, black
        piece = find_piece(square, white, black)
        puts "Cannot jump over #{piece.type} at square #{square}"
    end

    # need to account for whether piece is white or black
    # direction matters, only for pawns
    def valid_move? from, to, white=[], black=[]
        # split x and y coordinates of start and end squares
        first = from.split("")
        second = to.split("")

        if take == true
            take_piece(first, second)
        elsif move == 0
            first_move(first, second)
        else
            reg_move(first, second)
        end
        # implicitly returns validity of move -- true or false
    end

    def reg_move first, second
        # pawns can only move in one direction (y) unless overtaking another piece
        # if x-position changes, move is invalid
        if first[0] != second[0]
            return false
        end
        # pawns can only move one square if it's not their first turn
        # or they're not overtaking another piece
        if (first[1].to_i - second[1].to_i).abs != 1
            return false
        end
        case @color
        when "white"
            # if piece is white, it can only move upwards one square
            if (first[1].to_i - second[1].to_i) != -1
                return false
            end
        when "black"
            # if piece is black, it can only move downwards one square
            if (first[1].to_i - second[1].to_i) != 1
                return false
            end
        else
            return false
        end
        # if move passes all checks, return true
        return true
    end

    def first_move first, second
        # pawns can only move in one direction (y) unless overtaking another piece
        # if x-position changes, move is invalid
        if first[0] != second[0]
            return false
        end
        # if it's their first turn and they are not overtaking another piece
        # pawns may move forward two square as opposed to one
        # -- if player decides not to move two squares or overtake, treat as regular move
        if (first[1].to_i - second[1].to_i).abs != 2
            return reg_move(first, second)
        end
        # player chooses to move pawn two squares
        case @color
        when "white"
            # if piece is white, it can only move upwardswards two squares
            if (first[1].to_i - second[1].to_i) != -2
                return false
            end
        when "black"
            # if piece is black, it can only move downwards two squares
            if (first[1].to_i - second[1].to_i) != 2
                return false
            end
        end
        # if move passes all checks, return true
        return true
    end

    def take_piece first, second
        # for pawns to take a piece, they must move diagonally
        # check horizontal distance between squares is one
        if (first[0].ord - second[0].ord).abs != 1
            return false
        end
        # check horizontal distance w/ respect to color
        case @color
        when "white"
            # white can only move up one square
            if (first[1].to_i - second[1].to_i) != -1
                return false
            end
        when "black"
            # black can only move down one square
            if (first[1].to_i - second[1].to_i) != 1
                return false
            end
        end
        #if move passes all checks, return true
        return true
    end
end