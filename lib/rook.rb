require "./lib/gamepiece.rb"
require "./lib/finder.rb"

class Rook < Gamepiece

    include Finder

    attr_accessor :pos, :move
    attr_reader :sym, :color, :type

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0
        @type = "rook"

        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2656 "
        when "black"
            @sym = " \u265c "
        end
    end

    def valid_move? from, to, white=[], black=[]
        # split start and end squares into components
        first = from.split("")
        second = to.split("")

        # check whether player sets were passed in correctly
        if white.empty?() || black.empty?()
            return false
        end
        
        # rooks can only move vertically or horizontally
        # either the x-coord or the y-coord should stay the same
        if (first[0] != second[0]) && (first[1] != second[1])
            return false
        end
        
        # determine direction of movement
        direction = ""
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i)
        if delta_x == 0 && delta_y < 0
            direction = "up"
        elsif delta_x == 0 && delta_y > 0
            direction = "down"
        elsif delta_x > 0 && delta_y == 0
            direction = "left"
        else
            direction = "right"
        end

        # rooks cannot jump other pieces
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
        case direction
        when "up"
            delta_y = (first[1].to_i) - (second[1].to_i)
            (delta_y.abs - 1).times do
                first[1] = (first[1].to_i + 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true
                end
            end
        when "down"
            delta_y = (first[1].to_i) - (second[1].to_i)
            (delta_y.abs - 1).times do
                first[1] = (first[1].to_i - 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true
                end
            end
        when "left"
            delta_x = (first[0].ord) - (second[0].ord)
            (delta_x.abs - 1).times do
                first[0] = (first[0].ord - 1).chr
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true
                end
            end
        when "right"
            delta_x = (first[0].ord) - (second[0].ord)
            (delta_x.abs - 1).times do
                first[0] = (first[0].ord + 1).chr
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true
                end
            end
        end

        # if checks pass, return false (not jumping)
        return false
    end

end