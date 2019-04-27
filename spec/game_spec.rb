require 'spec_helper'

describe 'Game' do
  mockItem = nil
  mockOwnerItem = nil
  mockLocation = nil
  mockPlayer = nil
  mockMap = nil
  game = nil

  before(:each) do
    mockLocation = instance_double('Location', :remove_item => nil, :add_item => nil)
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
        mockOwnerItem = instance_double('Item', :name => 'box', :applicable_commands => [:take, :drop], :owns => [mockItem] )

        allow(mockItem).to receive(:belongs_to)
        allow(mockItem).to receive(:belongs_to=)
        allow(mockItem).to receive(:get_flattened_nested_items).and_return([mockItem])
        allow(mockOwnerItem).to receive(:remove_owned_item)

        map = game.instance_variable_get(:@map)
        player = game.instance_variable_get(:@player)

        allow(map).to receive(:current_location) { mockLocation }
        allow(player).to receive(:add_to_inventory)
      end

      after(:each) do
        mockItem = nil
        mockOwnerItem = nil
        Game.any_instance.unstub(:_check_for_item)
        # Item.any_instance.unstub(:get_flattened_nested_items)
      end

      it "should put item into player's inventory" do
        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.take_item(mockItem.name)

        expect(player).to have_received(:add_to_inventory).with(mockItem).once
      end

      it "should remove item from location if the item doesn't belong to another item" do
        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.take_item(mockItem.name)

        expect(map).to have_received(:current_location)
        expect(mockLocation).to have_received(:remove_item).with(mockItem)
      end

      it "should remove item from it's owner item if it's a nested item" do
        allow(mockItem).to receive(:belongs_to).and_return(mockOwnerItem)

        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.take_item(mockItem.name)

        expect(map).not_to have_received(:current_location)
        expect(mockLocation).not_to have_received(:remove_item).with(mockItem)
        expect(mockOwnerItem).to have_received(:remove_owned_item).with(mockItem)
        expect(mockItem).to have_received(:belongs_to=).with(nil)
      end
  end

  context "#drop_item" do
      map = nil
      player = nil

      before(:each) do
        # Item.any_instance.stub(:get_flattened_nested_items).and_return([])
        mockItem = instance_double('Item', :name => 'rock', :applicable_commands => [:take, :drop], :owns => [] )
        mockOwnerItem = instance_double('Item', :name => 'box', :applicable_commands => [:take, :drop], :owns => [mockItem] )

        map = game.instance_variable_get(:@map)
        player = game.instance_variable_get(:@player)

        allow(map).to receive(:current_location) { mockLocation }
        allow(player).to receive(:drop_from_inventory).and_return(mockItem)
        allow(mockItem).to receive(:belongs_to)
        allow(mockItem).to receive(:belongs_to=)
        allow(mockItem).to receive(:update_location_description_due_to_drop)
        allow(mockItem).to receive(:get_flattened_nested_items).and_return([mockItem])
        allow(mockOwnerItem).to receive(:remove_owned_item)
      end

      after(:each) do
        mockItem = nil
        mockOwnerItem = nil
        Game.any_instance.unstub(:_check_for_item)
        # Item.any_instance.unstub(:get_flattened_nested_items)
      end

      it "should remove an item from player's inventory" do
        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.drop_item(mockItem.name)

        expect(player).to have_received(:drop_from_inventory).with(mockItem).once
      end

      it "should remove ownership, if it's a nested item" do
        allow(mockItem).to receive(:belongs_to).and_return(mockOwnerItem)

        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.drop_item(mockItem.name)

        expect(mockItem).to have_received(:belongs_to=).with(nil)
      end

      it "should remove item from it's owner item if it's a nested item" do
        allow(mockItem).to receive(:belongs_to).and_return(mockOwnerItem)

        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.drop_item(mockItem.name)

        expect(mockOwnerItem).to have_received(:remove_owned_item).with(mockItem)
      end

      it "should add item to location" do
        Game.any_instance.stub(:_check_for_item).and_return(mockItem)

        game.drop_item(mockItem.name)

        expect(map).to have_received(:current_location)
        expect(mockLocation).to have_received(:add_item).with(mockItem)
      end
  end
end
