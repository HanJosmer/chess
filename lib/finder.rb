# used for finding pieces on the board

module Finder
    
    # checks black and white sets for piece located at target square
    # returns piece object if found; nil otherwise
    def find_piece sq, white, black
        white, black = check_white(sq, white), check_black(sq, black)
        return white ? white : black ? black : nil
    end

    # performs find_match on white set
    # returns piece object if found; nil otherwise
    def check_white sq, white
        find_match(white, sq)
    end

    # performs find_match on black set
    # returns piece object if found; nil otherwise
    def check_black sq, black
        find_match(black, sq)
    end

    # searches given set for piece located at target square
    # returns piece object if found; nil otherwise
    def find_match set, sq
        set.find(ifnone = nil) { |item| item.pos == sq }
    end

end