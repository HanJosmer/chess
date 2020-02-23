require "./lib/gamepiece.rb"

class Queen < Gamepiece

    attr_accessor :pos, :move
    attr_reader :sym, :color

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0

        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2655 "
        when "black"
            @sym = " \u265b "
        end
    end

    def valid_move? from, to, take=false
        # queens can move any number of spaces in any one direction

        first = from.split("")
        second = to.split("")

        # calculate deltas
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i)

        # check for diagonality
        if delta_x.abs == delta_y.abs
            check_for_pieces()
            return true
        end

        # check for vertical move
        if delta_x == 0
            # assumes delta_y != 0 (from != to)
            check_for_pieces()
            return true
        end

        # check for horizontal move
        if delta_y == 0
            # assumes delta_x != 0 (from != to)
            check_for_pieces()
            return true
        end

        # any other moves are invalid
        return false
    end

    def check_for_pieces()
        # TODO
    end
end