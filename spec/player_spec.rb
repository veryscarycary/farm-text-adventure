require 'spec_helper'

describe 'Player' do
  player = nil

  before(:each) do
    player = Player.new
  end

  context "#initialize" do
    context "@inventory" do
      it "should initialize with an empty inventory" do
        expect(player.inventory).to eql([])
      end
    end
  end

  context "#add_to_inventory" do
    it "should take an item and add it to the player's inventory" do
      item = Item.new('cat')
      player.add_to_inventory(item)

      expect(player.inventory).to eql([item])
    end
  end

  context "#drop_from_inventory" do
    it "should remove an item from the player's inventory" do
      item1 = Item.new('cat')
      item2 = Item.new('dog')

      player.add_to_inventory(item1)
      player.add_to_inventory(item2)
      # we're assuming the inventory has 2 items in it here

      player.drop_from_inventory(item1)
      expect(player.inventory).to eql([item2])
    end
  end

  context "#check_inventory" do
    it "should include 'and' if there is more than one item in the inventory" do
      item1 = Item.new('cat')
      item2 = Item.new('dog')

      player.add_to_inventory(item1)
      player.add_to_inventory(item2)

      expectation = expect { player.check_inventory }
      expectation.to output(/and/).to_stdout
    end

    it "should separate inventory items with commas if there is more than one item in the inventory" do
      item1 = Item.new('cat')
      item2 = Item.new('dog')
      item3 = Item.new('catdog')

      player.add_to_inventory(item1)
      player.add_to_inventory(item2)
      player.add_to_inventory(item3)

      expectation = expect { player.check_inventory }
      expectation.to output(/cat, /).to_stdout
      expectation.to output(/dog, /).to_stdout
    end

    it "should print inventory items with the vowel-adjusted article in front of it" do
      item1 = Item.new('apple')
      item2 = Item.new('dog')
      item3 = Item.new('ostrich')

      player.add_to_inventory(item1)
      player.add_to_inventory(item2)
      player.add_to_inventory(item3)

      expectation = expect { player.check_inventory }
      expectation.to output(/an apple/).to_stdout
      expectation.to output(/a dog/).to_stdout
      expectation.to output(/an ostrich/).to_stdout
    end
  end
end
