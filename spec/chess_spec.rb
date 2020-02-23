#spec/chess_spec.rb

require './lib/chess.rb'

RSpec.describe Chess do
    describe "#on_board?" do
        it "returns true when square is on the board" do
            chess = Chess.new()
            expect(chess.on_board?("f3")).to eql(true)
            expect(chess.on_board?("b7")).to eql(true)
        end
        it "returns false when square is not on the board" do
            chess = Chess.new()
            expect(chess.on_board?("x3")).not_to eql(true)
            expect(chess.on_board?("b9")).not_to eql(true)
        end
    end

    describe "#find_piece" do
        # TODO
    end

    describe "#save" do
        # TODO
    end

    describe "#load" do
        # TODO
    end
end