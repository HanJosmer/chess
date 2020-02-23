require "./lib/gamepiece.rb"

class King < Gamepiece

    attr_accessor :pos, :move
    attr_reader :sym, :color

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0

        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2654 "
        when "black"
            @sym = " \u265a "
        end
    end

    def valid_move? from, to, take=false
        # kings can move one square in any direction

        first = from.split("")
        second = to.split("")

        # individual delta must not exceed 1
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i)
        # total delta must not exceed 2
        total_delta = (delta_x.abs) + (delta_y.abs)
        
        if total_delta.between?(1,2) && (delta_x.abs < 2) && (delta_y.abs < 2)
            check_for_pieces() # check for any pieces in the way
            return true            
        else
            return false
        end
    end

    def check_for_pieces()
        # TODO
    end
end