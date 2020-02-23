require "./lib/gamepiece"
require "./lib/finder.rb"

class Bishop < Gamepiece

    include Finder

    attr_accessor :pos, :move
    attr_reader :sym, :color

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0

        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2657 "
        when "black"
            @sym = " \u265d "
        end
    end

    def valid_move? from, to, white=[], black=[]
        # split x and y coordinates of start and end squares
        first = from.split("")
        second = to.split("")
        
        # bishops can move diagonally however far they choose
        # they cannot 'jump' pieces, even their own

        deltas = get_deltas(first, second)

        # check for diagonality. change in x should equal change in y
        if deltas[0].abs != deltas[1].abs
            return false
        end

        # do not check for intermediary pieces if either set is empty
        unless white.empty?() || black.empty?()
            return false if jumping?(first, second, white, black)
        end
        
        # if move passes all checks, return true
        return true
    end

    def jumping? first, second, white, black
        deltas = get_deltas(first, second)
        (deltas[0].abs - 1).times do
            first[0] += 1; first[1] += 1
            if find_piece(first.join(""))
                return true
            end
        end
        # if checks pass, return true
        return true
    end

    def get_deltas first, second
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i) 
        return [delta_x, delta_y]
    end
end