require 'spec_helper'

describe 'Game' do
  mockLocation = nil
  mockPlayer = nil
  mockMap = nil
  game = nil

  before(:each) do
    mockLocation = instance_double('Location', :remove_item => nil)
    mockMap = instance_double('Map', :current_location => mockLocation)
    mockPlayer = instance_double('Player', :add_to_inventory => nil)
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

  context "#take_item" do
      map = nil
      player = nil

      before(:each) do
        map = game.instance_variable_get(:@map)
        player = game.instance_variable_get(:@player)

        allow(map).to receive(:current_location) { mockLocation }
        allow(player).to receive(:add_to_inventory)
      end

      after(:each) do
        Game.any_instance.unstub(:_check_for_item)
      end

      it "should put it into player's inventory" do
        item = Item.new('rock', '', { applicable_commands: [:take, :drop] })
        Game.any_instance.stub(:_check_for_item).and_return(item)

        game.take_item(item.name)

        expect(player).to have_received(:add_to_inventory).with(item)
      end

      it "should remove item from location if the item doesn't belong to another item" do
        item = Item.new('rock', '', { applicable_commands: [:take, :drop] })
        Game.any_instance.stub(:_check_for_item).and_return(item)

        game.take_item(item.name)

        expect(map).to have_received(:current_location)
        expect(mockLocation).to have_received(:remove_item).with(item)
      end
  end
end
