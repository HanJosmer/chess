require "./lib/gamepiece.rb"

class Rook < Gamepiece

    attr_accessor :pos, :move
    attr_reader :sym, :color

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0

        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2656 "
        when "black"
            @sym = " \u265c "
        end
    end

    def valid_move? from, to, take=false
        # split start and end squares into components
        first = from.split("")
        second = to.split("")

        # rooks can only move vertically or horizontally
        # they can move as far as they want, but can't jump pieces
        
        # either the x-coord or the y-coord should stay the same
        if (first[0] != second[0]) && (first[1] != second[1])
            return false
        end

        unless white.empty?() || black.empty?()
            return false if jumping?(first, second, white, black)
        end

        # if move passes all checks, return true
        return true
    end

    def jumping?
        # TODO
    end
end