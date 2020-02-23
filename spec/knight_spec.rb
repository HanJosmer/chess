#spec/knight_spec.rb

require './lib/knight.rb'

RSpec.describe Knight do
    describe "#check_for_pieces" do
        # TODO
    end

    describe "#valid_move?" do
        it "moves like a knight" do
            knight = Knight.new("b1", "white")
            expect(knight.valid_move?("b1", "d2")).to eql(true)
        end
        it "fails to move vertically" do
            knight = Knight.new("b1", "white")
            expect(knight.valid_move?("b1", "b4")).not_to eql(true)
        end
        it "fails to move horizontally" do
            knight = Knight.new("b1", "white")
            expect(knight.valid_move?("b1", "e1")).not_to eql(true)
        end
        it "fails to move diagonally" do
            knight = Knight.new("b1", "white")
            expect(knight.valid_move?("b1", "d3")).not_to eql(true)
        end
    end
end