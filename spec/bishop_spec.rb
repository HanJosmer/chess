#spec/bishop_spec.rb

require './lib/bishop.rb'

RSpec.describe Bishop do
    describe "#check_for_pieces" do
        # TODO
    end
    
    describe "#valid_move?" do
        it "moves diagonally" do
            bishop = Bishop.new("c1", "white")
            expect(bishop.valid_move?("c1", "a3")).to eql(true)
        end
        it "fails to move vertically" do
            bishop = Bishop.new("c1", "white")
            expect(bishop.valid_move?("c1", "c3")).not_to eql(true)
        end
        it "fails to move horizontally" do
            bishop = Bishop.new("c1", "white")
            expect(bishop.valid_move?("c1", "e1")).not_to eql(true)
        end
        it "fails to move in unequal diagonal direction" do
            bishop = Bishop.new("c1", "white")
            expect(bishop.valid_move?("c1", "f3")).not_to eql(true)
        end
    end
end