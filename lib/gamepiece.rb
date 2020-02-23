class Gamepiece
    
    def initialize
        @x_pos = nil
        @y_pos = nil
    end

    def self.build_piece type
        case type
        when "pawn"
            return Pawn.new()
        when "rook"
            return Rook.new()
        when "bishop"
            return Bishop.new()
        when "queen"
            return Queen.new()
        when "king"
            return King.new()
        end
    end

    def move
        # TODO
    end

    def inheritance_test
        puts "This method was inherited from Gamepiece"
    end

end