#spec/rook_spec.rb

require './lib/rook.rb'

RSpec.describe Rook do
    describe "#check_for_pieces" do
        # TODO
    end

    describe "#valid_move?" do
        it "moves vertically" do
            rook = Rook.new("a1", "white")
            expect(rook.valid_move?("a1", "a4")).to eql(true)
        end
        it "moves horizontally" do
            rook = Rook.new("a1", "white")
            expect(rook.valid_move?("a1", "e1")).to eql(true)
        end
        it "fails to move diagonally" do
            rook = Rook.new("a1", "white")
            expect(rook.valid_move?("a1", "c3")).not_to eql(true)
        end
        it "fails to move non-vertically or -horizontally" do
            rook = Rook.new("a1", "white")
            expect(rook.valid_move?("a1", "b6")).not_to eql(true)
        end
    end
end