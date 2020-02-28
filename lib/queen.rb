require "./lib/gamepiece.rb"
require "./lib/finder.rb"

class Queen < Gamepiece

    include Finder

    attr_accessor :pos, :move
    attr_reader :sym, :color, :type

    def initialize(pos, color)
        @pos = pos
        @color = color
        @move = 0
        @type = "queen"

        # set symbol code depending on piece color
        case @color
        when "white"
            @sym = " \u2655 "
        when "black"
            @sym = " \u265b "
        end
    end

    def valid_move? from, to, white, black
        # queens can move any number of spaces in any one direction

        first = from.split("")
        second = to.split("")

        # check whether player sets were passed in correctly
        if white.empty? || black.empty?
            return false
        end

        # calculate deltas
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i)
        deltas = [delta_x, delta_y]

        # determine direction of movement
        direction = ""

        # check for diagonality
        if delta_x.abs == delta_y.abs
            if deltas[0] < 0 && deltas[1] < 0
                direction = "up-right"
            elsif deltas[0] > 0 && deltas[1] < 0
                direction = "up-left"
            elsif deltas[0] < 0 && deltas[1] > 0
                direction = "down-right"
            else
                direction = "down-left"
            end
            return true unless jumping?(first, second, white, black, direction)
        end

        # check for vertical move
        if delta_x == 0
            # assumes delta_y != 0 (from != to)
            if delta_y < 0
                direction = "up"
            else
                direction = "down"
            end
            return true unless jumping?(first, second, white, black, direction)
        end

        # check for horizontal move
        if delta_y == 0
            # assumes delta_x != 0 (from != to)
            if delta_x > 0
                direction = "left"
            else
                direction = "right"
            end
            return true unless jumping?(first, second, white, black, direction)
        end

        # any other moves are invalid
        return false
    end

    def message square, white, black
        piece = find_piece(square, white, black)
        puts "Cannot jump over #{piece.type} at square #{square}"
    end

    def jumping? first, second, black, white, direction
        # get deltas
        delta_x = (first[0].ord) - (second[0].ord)
        delta_y = (first[1].to_i) - (second[1].to_i)
        deltas = [delta_x, delta_y]

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
            return false # not jumping
        when "down"
            delta_y = (first[1].to_i) - (second[1].to_i)
            (delta_y.abs - 1).times do
                first[1] = (first[1].to_i - 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true
                end
            end
            return false # not jumping
        when "left"
            delta_x = (first[0].ord) - (second[0].ord)
            (delta_x.abs - 1).times do
                first[0] = (first[0].ord - 1).chr
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true
                end
            end
            return false # not jumping
        when "right"
            delta_x = (first[0].ord) - (second[0].ord)
            (delta_x.abs - 1).times do
                first[0] = (first[0].ord + 1).chr
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true
                end
            end
            return false # not jumping
        when "up-right"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord + 1).chr
                first[1] = (first[1].to_i + 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
            return false # not jumping
        when "up-left"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord - 1).chr
                first[1] = (first[1].to_i + 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
            return false # not jumping
        when "down-right"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord + 1).chr
                first[1] = (first[1].to_i - 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
            return false # not jumping
        when "down-left"
            (deltas[0].abs - 1).times do
                first[0] = (first[0].ord - 1).chr
                first[1] = (first[1].to_i - 1).to_s
                if find_piece(first.join(""), white, black)
                    message(first.join(""), white, black)
                    return true # jumping
                end
            end
            return false # not jumping
        end
    end
end