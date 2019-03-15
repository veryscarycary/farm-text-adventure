require 'spec_helper'

describe 'Location' do
  context "#initialize" do
    context "@description" do
      it "should strip whitespace and carriage returns from description" do
        location = Location.new('
          A nasty place
        ')

        expect(location.description).to eql("A nasty place")
      end
    end
  end

  context "#get_items_with_location_descriptions" do
    it "should return an empty array if no items are found with location descriptions" do
      location = Location.new('house', {
        items: []
      })

      expect(location.get_items_with_location_descriptions(location.items)).to eql([])
    end

    it "should return an array if items are found with location descriptions" do
      item1 = Item.new('drawer', '', location_description: "It's an old drawer.")
      item2 = Item.new('necklace', '', location_description: "It's a shiny necklace.")

      location = Location.new('house', {
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

      location = Location.new('house', {
        items: [item1]
      })

      expect(location.get_items_with_location_descriptions(location.items)).to eql([item1, item3])
    end
  end
end
