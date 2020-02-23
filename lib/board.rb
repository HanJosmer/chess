class Board

    attr_reader :board

    def initialize
        @rows = []
        (1..8).reverse_each() { |num| @rows.push(num) }

        @cols = []
        ("a".."h").each { |char| @cols.push(char) }
        
        @board = build_board()
    end

    def build_board
        board = []
        @rows.each do |row|
            concat = []
            @cols.each do |col|
                concat.push(col.to_s + row.to_s)
            end
            board.push(concat)
        end
        return board
    end

end