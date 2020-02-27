require "./lib/gamepiece"
require "./lib/finder.rb"

class Bishop < Gamepiece

    include Finder

    attr_accessor :pos, :move
    attr_reader :sym, :color, :type

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0
        @type = "bishop"

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
        
        # check whether player sets were passed in correctly
        if white.empty? || black.empty?
            return false
        end

        # bishops can move diagonally however far they choose
        # they cannot 'jump' pieces, even their own

        deltas = get_deltas(first, second)

        # check for diagonality. change in x should equal change in y
        if deltas[0].abs != deltas[1].abs
            return false
        end

        # determine movement direction
        direction = ""
        if deltas[0] < 0 && deltas[1] < 0
            direction = "up-right"
        elsif deltas[0] > 0 && deltas[1] < 0
            direction = "up-left"
        elsif deltas[0] < 0 && deltas[1] > 0
            direction = "down-right"
        else
            direction = "down-left"
        end

        # bishops may not jump over over pieces
        if jumping?(first, second, white, black, direction)
            return false
        end
        
        # if move passes all checks, return true
        return true
    end

    def message square, white, black
        piece = find_piece(square, white, black)
        puts "Cannot jump over #{piece.type} at square #{square}"
    end


    def jumping? first, second, white, black, direction
        deltas = get_deltas(first, second)
        # directional quandrants: one, two, three, four
        case direction
        when "up-right"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord + 1).chr
                first[1] = (first[1].to_i + 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
        when "up-left"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord - 1).chr
                first[1] = (first[1].to_i + 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
        when "down-right"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord + 1).chr
                first[1] = (first[1].to_i - 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
        when "down-left"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord - 1).chr
                first[1] = (first[1].to_i - 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
        end

        # if checks pass, return false (not jumping)
        return false
    end

    def get_deltas first, second
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i) 
        return [delta_x, delta_y]
    end
end