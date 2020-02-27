require "./lib/gamepiece.rb"

class Knight < Gamepiece

    attr_accessor :pos, :move
    attr_reader :sym, :color, :type

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0
        @type = "knight"
        
        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2658 "
        when "black"
            @sym = " \u265e "
        end
    end

    def valid_move? from, to, white=[], black=[]
        # knights move two squares in one direction
        # and one square at 90 degrees

        first = from.split("")
        second = to.split("")

        # check whether player sets were passed in correctly
        if white.empty? || black.empty?
            return false
        end

        # calculate direction deltas
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i)
        
        if lat_move?(delta_x, delta_y) || long_move?(delta_x, delta_y)
            return true
        else
            return false
        end

        # knights are allowed to jump over other pieces
        # no #jumping method is needed
    end

    def lat_move? delta_x, delta_y
        # lateral move should be two over, one up or down
        if delta_x.abs == 2 && delta_y.abs == 1
            return true
        else
            return false
        end
    end

    def long_move? delta_x, delta_y
        # longitudinal move should be one over, two up or down
        if delta_x.abs == 1 && delta_y.abs == 2
            return true
        else
            return false
        end
    end
end