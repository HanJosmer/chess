#spec/pawn_spec.rb

require './lib/pawn.rb'

RSpec.describe Pawn do
    describe "#check_for_pieces" do
        # TODO
    end
    
    describe "#valid_move?" do
        it "moves forward one [empty] square" do
            pawn = Pawn.new("b2", "white")
            expect(pawn.valid_move?("b2", "b3", false)).to eql(true)
        end
        it "fails to move sideways" do
            pawn = Pawn.new("b2", "white")
            expect(pawn.valid_move?("b2", "c2", false)).not_to eql(true)
        end
        it "moves forward two [empty] squares on first turn" do
            pawn = Pawn.new("b2", "white")
            expect(pawn.valid_move?("b2", "b4", false)).to eql(true)
        end
        it "fails to move two [empty] squares if not first turn" do
            pawn = Pawn.new("b4", "white")
            pawn.move += 1
            expect(pawn.valid_move?("b4", "b6", false)).not_to eql(true)
        end
        it "moves diagonally one square when attacking" do
            pawn = Pawn.new("b2", "white")
            expect(pawn.valid_move?("b2", "c3", true)).to eql(true)
        end
        it "fails to move diagonally when not attacking" do
            pawn = Pawn.new("b2", "white")
            expect(pawn.valid_move?("b2", "c3", false)).not_to eql(true)
        end
        it "fails to move forward when attacking" do
            pawn = Pawn.new("b2", "white")
            expect(pawn.valid_move?("b2", "b3", true)).not_to eql(true)
        end
        it "fails to move backward" do
            pawn = Pawn.new("b2", "white")
            expect(pawn.valid_move?("b2", "b1", false)).not_to eql(true)
        end
    end
end