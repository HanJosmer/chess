#spec/queen_spec.rb

require './lib/queen.rb'

RSpec.describe Queen do
    describe "#check_for_pieces" do
        # TODO
    end

    describe "#valid_move?" do
        it "moves vertically" do
            queen = Queen.new("d1", "white")
            expect(queen.valid_move?("d1", "d4")).to eql(true)
        end
        it "moves horizontally" do
            queen = Queen.new("d1", "white")
            expect(queen.valid_move?("d1", "f1")).to eql(true)
        end
        it "moves diagonally" do
            queen = Queen.new("d1", "white")
            expect(queen.valid_move?("d1", "g4")).to eql(true)
        end
        it "fails to move like a knight" do
            queen = Queen.new("d1", "white")
            expect(queen.valid_move?("d1", "f2")).not_to eql(true)
        end
    end
end