require 'spec_helper'

describe 'Game' do
  mockItem = nil
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
        # Item.any_instance.stub(:get_flattened_nested_items).and_return([])
        mockItem = instance_double('Item', :name => 'rock', :applicable_commands => [:take, :drop], :owns => [] )

        map = game.instance_variable_get(:@map)
        player = game.instance_variable_get(:@player)

        allow(map).to receive(:current_location) { mockLocation }
        allow(player).to receive(:add_to_inventory)
        allow(mockItem).to receive(:belongs_to)
        allow(mockItem).to receive(:get_flattened_nested_items).and_return([])
      end

      after(:each) do
        mockItem = nil
        mockOwnerItem = nil
        Game.any_instance.unstub(:_check_for_item)
        # Item.any_instance.unstub(:get_flattened_nested_items)
      end

      it "should put it into player's inventory" do
        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.take_item(mockItem.name)

        expect(player).to have_received(:add_to_inventory).with(mockItem)
      end

      it "should remove item from location if the item doesn't belong to another item" do
        # item = Item.new('rock', '', { applicable_commands: [:take, :drop] })
        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.take_item(mockItem.name)

        expect(map).to have_received(:current_location)
        expect(mockLocation).to have_received(:remove_item).with(mockItem)
      end

      it "should remove item from it's owner item if it's a nested item" do
        # I needed a real Item here because I don't know how to set a stub method on a double after it's already been
        # declared, which I need to do here to get the items to link to each other
        mockItem = Item.new('rock', '', { applicable_commands: [:take, :drop], belongs_to: nil })
        mockOwnerItem = Item.new('box', '', { applicable_commands: [:take, :drop], owns: [mockItem] })
        mockItem.belongs_to = mockOwnerItem

        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.take_item(mockItem.name)

        expect(map).not_to have_received(:current_location)
        expect(mockLocation).not_to have_received(:remove_item).with(mockItem)
      end
  end
end
