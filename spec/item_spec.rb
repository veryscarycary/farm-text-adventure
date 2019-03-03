require 'spec_helper'

describe 'Item' do
  context "#initialize" do
    context "@name" do
      it "should strip whitespace and carriage returns from description" do
        item = Item.new('
          item name
        ', "Some item.")

        expect(item.name).to eql("item name")
      end
    end

    context "@description" do
      it "should strip whitespace and carriage returns from description" do
        item = Item.new('item', "
          Some item.
        ")

        expect(item.description).to eql("Some item.")
      end

      it "should condense all spaces to just single spaces" do
        item = Item.new('item', "
          Some item.  It's shiny.
        ")

        expect(item.description).to eql("Some item. It's shiny.")
      end
    end

    context "@location_description" do
      it "should use state_descriptions[:state][:location] if no location description is provided" do
        item = Item.new('item', "Some item.", {
          state_descriptions: {
            open: {
              location: "State-specific location description."
            }
          },
          state: :open
        })

        expect(item.description).to eql("Some item.")
      end
    end

    context "@is_hidden" do
      it "should be false by default" do
        item = Item.new('item', "Some item.")

        expect(item.is_hidden).to eql(false)
      end
    end

    context "@can_take" do
      it "should be true by default" do
        item = Item.new('item', "Some item.")

        expect(item.can_take).to eql(true)
      end
    end
  end

  context "#update_location_description_due_to_state" do
    item = Item.new('item', "Some item.", {
      state_descriptions: {
        open: {
          location: "Open here."
        },
        closed: {
          location: "Closed here."
        },
      },
      state: :open
    })

    it "should set location_decription to new matching state location description" do
      item.state = :closed
      item.update_location_description_due_to_state

      expect(item.location_description).to eql('Closed here.')
    end
  end

  context "#has_name?" do
    item = Item.new('machete', 'It\'s a sharp blade', {aliases: ['rusty machete', 'macheetah']})

    it "should return true if provided name matches item\'s name" do
      name = 'machete'

      expect(item.has_name?(name)).to eql(true)
    end

    it "should return true if the provided name matches one of item\'s aliases" do
      name = 'rusty machete'

      expect(item.has_name?(name)).to eql(true)
    end

    it "should return false if the provided name does not match item\'s name or aliases" do
      name = 'machachacha'

      expect(item.has_name?(name)).to eql(false)
    end
  end
end
