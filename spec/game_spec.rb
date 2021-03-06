require 'game'
require 'player'
require 'board'

describe Game do
let(:game){Game.new}

it "should initialize with an empty array of players" do
	game.players.should eq []
end

it "should initialize with a board" do
	game.board.should_not be_nil
end

it "should initialize with an array of possible marks, i.e. O and X" do
	game.marks.should eq ["X", "O"]
end

it "should initialize with an empty array for turns which should be accessible" do
	game.turn.should eq []
end

it "should initialize with a checker" do
	game.checker.should_not be_nil
end


it "should allow a player to be added, taking in a name as an argument, creating a new player instance which is added to @players
and which randomly selects a mark, and which is then deleted from marks" do
	game.add_player(:name)
	game.players.size.should eq 1
	game.marks.size.should eq 1
end

it "should allow a player to be added and add them to the turn array" do
	game.add_player(:name)
	game.turn.size.should eq 1
end

it "should not allow more than two players to be added" do
	game.add_player(:name)
	game.add_player(:name)
	expect{game.add_player(:name)}.to raise_error("Can't have more than two players!")
end

it "should be able to determine whose turn it is, this is the first in the array" do
	game.add_player(:name1)
	game.add_player(:name2)
	game.whose_turn.should eq :name1
 end

it "should be able to check if the game is over which involves calling winning line with checker?" do
	checker= double :checker
	game.checker = checker
	checker.should_receive(:winning_line?)
	game.game_over?	
end

it "should be able to check who the winner is" do
	checker = double :checker
	checker.should_receive(:winner).and_return("O")
	game.checker = checker
	game.players << Player.new("name1", :board, "O")
	game.winner.should eq "name1"
end

it "should be able to determine a player from his name" do
	game.players << Player.new("name1", :board, "O")
	game.player_from_name("name1").mark.should eq "O"
end


it "should allow player to place his mark on a chosen cell on the board
then be at the back of the turn queue" do
	board = double :board
	game.players << Player.new("name1", board, "O")
	game.board = board
	game.turn << "name1"
	game.turn << "name2"
	board.should_receive(:fill_cell).with(0, "O")
	checker= double :checker
	game.checker = checker
	checker.should_receive(:winning_line?).and_return(false)
	board.should_receive(:all_filled?).and_return(false)
	game.player_mark("name1", 0)
	game.whose_turn.should eq "name2"
end

it "should not allow player to place mark if not his turn" do
	board = double :board
	game.players << Player.new("name1", board, "O")
	game.board = board
	board.should_not_receive(:fill_cell).with(0, "O")
	game.turn.pop
	expect{game.player_mark("name1", 0)}.to raise_error
end

it "should not allow player to place mark if the game is over" do
	checker = double :checker
	game.checker = checker
	game.players << Player.new("name1", :board, "O")
	checker.should_receive(:winning_line?).and_return(:true)
	expect{game.player_mark("name1", 0)}.to raise_error
end

it "should indicate the game is over if all the cells are filled" do
	checker = double :checker
	game.checker = checker
	checker.should_receive(:winning_line?).and_return(false)
	board = double :board
	game.board = board
	board.should_receive(:all_filled?).and_return(true)
	game.game_over?.should be_true
end


end