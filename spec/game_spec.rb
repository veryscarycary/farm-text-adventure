require 'spec_helper'

describe 'Game' do
  mockPlayer = nil
  mockMap = nil
  game = nil

  before(:each) do
    mockPlayer = instance_double('Player')
    mockMap = instance_double('Map')
    game = Game.new(mockPlayer, mockMap)
  end

  context "#initialize" do
    context "@inventory" do
      it "should initialize with a player" do
        expect(game.player).to eql(mockPlayer)
      end
    end

    context "@map" do
      it "should initialize with a map" do
        expect(game.map).to eql(mockMap)
      end
    end
  end
end
