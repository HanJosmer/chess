#spec/king_spec.rb

require './lib/king.rb'

RSpec.describe King do
    describe "#check_for_pieces.rb" do
        # TODO
    end

    describe "#valid_move?" do
        it "moves one square vertically" do
            king = King.new("e1", "white")
            expect(king.valid_move?("e1", "e2")).to eql(true)
        end
        it "fails to move more than one square vertically" do
            king = King.new("e1", "white")
            expect(king.valid_move?("e1", "e4")).not_to eql(true)
        end
        it "moves one square horizontally" do
            king = King.new("e1", "white")
            expect(king.valid_move?("e1", "d1")).to eql(true)
        end
        it "fails to move more than one square horizontally" do
            king = King.new("e1", "white")
            expect(king.valid_move?("e1", "b1")).not_to eql(true)
        end
        it "moves one square diagonally" do
            king = King.new("e1", "white")
            expect(king.valid_move?("e1", "f2")).to eql(true)
        end
        it "fails to move more than one square diagonally" do
            king = King.new("e1", "white")
            expect(king.valid_move?("e1", "g3")).not_to eql(true)
        end
        it "fails to move like a knight" do
            king = King.new("e1", "white")
            expect(king.valid_move?("e1", "d3")).not_to eql(true)
        end
    end
end