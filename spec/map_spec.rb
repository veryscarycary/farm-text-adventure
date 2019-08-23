require 'spec_helper'

describe 'Map' do
  context "#initialize" do
    context "@grid" do
      it "should automatically match blocked_paths with surrounding locations" do
        loc1 = Location.new('', '', {
          blocked_paths: {'south' => {obstruction: 'wall'}}
        })
        loc2 = Location.new('', '')
        loc3 = Location.new('', '')
        loc4 = Location.new('', '', {
          blocked_paths: {'west' => {obstruction: 'wall'}, 'north' => {obstruction: 'gate'}}
        })
        map = Map.new([
          [loc1, loc2],
          [loc3, loc4],
        ], 0, 0);

        expect(loc3.blocked_paths['north']).to eql({obstruction: 'wall'})
        expect(loc3.blocked_paths['east']).to eql({obstruction: 'wall'})
        expect(loc2.blocked_paths['south']).to eql({obstruction: 'gate'})
        expect(loc2.blocked_paths['west']).to eql(nil)
      end

      it "should not automatically match blocked_path if other side has an obstruction already " do
        loc1 = Location.new('', '', {
          blocked_paths: {'east' => {obstruction: 'wall'}}
        })
        loc2 = Location.new('', '', {
          blocked_paths: {'west' => {obstruction: 'something already'}}
        })
        map = Map.new([
          [loc1, loc2],
        ], 0, 0);

        expect(loc1.blocked_paths['east']).to eql({obstruction: 'wall'})
        expect(loc2.blocked_paths['west']).to eql({obstruction: 'something already'})
      end

      it "should not automatically add the default map bound obstruction to the edge locations" do
        loc1 = Location.new('', '', {
          blocked_paths: {'east' => {obstruction: 'wall'}}
        })
        loc2 = Location.new('', '', {
          blocked_paths: {'west' => {obstruction: 'something already'}}
        })
        map = Map.new([
          [loc1, loc2],
        ], 0, 0);

        # chain link fence is the current hardcoded obstruction
        expect(loc1.items.find {|item| item.name == 'chain link fence' && item.aliases.include?('fence')}).not_to be_nil
        expect(loc2.items.find {|item| item.name == 'chain link fence' && item.aliases.include?('fence')}).not_to be_nil
      end
    end
  end
end

describe 'Location' do
  context "#initialize" do
    context "@description" do
      it "should strip whitespace and carriage returns from description" do
        location = Location.new('','
          A nasty place
        ')

        expect(location.description).to eql("A nasty place")
      end

      it "should not automatically add the location's blocked paths/obstructions as items in the location" do
        location = Location.new('','A nasty place',
          blocked_paths: {'west' => {obstruction: 'wall'}, 'north' => {obstruction: 'dog'}, 'south' => {obstruction: 'big horse'}}
        )
        
        expect(location.items.find {|item| item.name == 'wall'}).not_to be_nil
        expect(location.items.find {|item| item.name == 'dog' && item.aliases.include?('dog')}).not_to be_nil
        expect(location.items.find {|item| item.name == 'big horse' && item.aliases.include?('horse')}).not_to be_nil
      end
    end
  end

  context "#add_item" do
    it "should add an item to the current location" do
      mockItem = instance_double('Item', :name => 'rock', :applicable_commands => [:take, :drop], :owns => [] )

      location = Location.new('','house', {
        items: []
      })

      location.add_item(mockItem)

      expect(location.items).to eql([mockItem])
    end
  end

  context "#get_items_with_location_descriptions" do
    it "should return an empty array if no items are found with location descriptions" do
      location = Location.new('', 'house', {
        items: []
      })

      expect(location.get_items_with_location_descriptions(location.items)).to eql([])
    end

    it "should return an array if items are found with location descriptions" do
      item1 = Item.new('drawer', '', location_description: "It's an old drawer.")
      item2 = Item.new('necklace', '', location_description: "It's a shiny necklace.")

      location = Location.new('', 'house', {
        items: [item1, item2]
      })

      expect(location.get_items_with_location_descriptions(location.items)).to eql([item1, item2])
    end

    it "should return an array of items with descriptions EVEN IF nested deeply" do
      item1 = Item.new('drawer', '', location_description: "It's an old drawer.")
      item2 = Item.new('necklace box', '')
      item3 = Item.new('necklace', '', location_description: "It's a shiny necklace.")
      item1.owns << item2
      item2.owns << item3

      location = Location.new('', 'house', {
        items: [item1]
      })

      expect(location.get_items_with_location_descriptions(location.items)).to eql([item1, item3])
    end
  end
end
