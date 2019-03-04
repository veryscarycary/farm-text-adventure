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

  context "#use" do
    item = Item.new('item', "Some item.", {
      state_descriptions: {
        on: {
          location: "On here."
        },
        off: {
          location: "Off here."
        },
      },
      state: :on
    })

    it "should call toggle_on_off if state is on" do
      Item.any_instance.stub(:toggle_on_off)
      item.use

      expect(item).to have_received(:toggle_on_off)
      Item.any_instance.unstub(:toggle_on_off)
    end

    it "should call toggle_on_off if state is off" do
      item.state = :off
      Item.any_instance.stub(:toggle_on_off)
      item.use

      expect(item).to have_received(:toggle_on_off)
      Item.any_instance.unstub(:toggle_on_off)
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

  context "#toggle_on_off" do
    it "should error if state is neither on or off" do
      item = Item.new('item', "Some item.", {
        state_descriptions: {
          raging: {
            location: "IT'S RAGING RIGHT NOW"
          }
        },
        state: :raging
        })
      expect { item.toggle_on_off }.to raise_error
    end

    it "should turn item off if on" do
      item = Item.new('item', "Some item.", {
        state_descriptions: {
          on: {
            location: "on"
          },
          off: {
            location: "off"
          },
        },
        state: :on
      })

      item.toggle_on_off

      expect(item.state).to eql(:off)
    end

    it "should turn item on if off" do
      item = Item.new('item', "Some item.", {
        state_descriptions: {
          on: {
            location: "on"
          },
          off: {
            location: "off"
          },
        },
        state: :off
      })

      item.toggle_on_off

      expect(item.state).to eql(:on)
    end
  end
end
