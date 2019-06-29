require 'spec_helper'

describe 'Item' do
  context "#initialize" do
    context "@name" do
      it "should strip whitespace and carriage returns from name" do
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

    context "@owns" do
      it "should be empty array by default" do
        item = Item.new('item', "Some item.")

        expect(item.owns).to eql([])
      end

      it "should set each owned item's belongs_to property to owner item" do
        owned_item = Item.new('owned', '')
        owner = Item.new('item', "Some item.", owns: [owned_item])

        expect(owned_item.belongs_to).to eql(owner)
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

  context "#invoke_use_action" do
    it "should invoke the item's use_action and return true if it has one" do
      item = Item.new('item', "Some item.", {
        use_action: "lambda { return 10 }"
      })

      result = item.invoke_use_action

      expect(result).to eql(true)
    end

    it "should not invoke the item's use_action and return false if it doesn't have one" do
      item = Item.new('item', "Some item.")

      result = item.invoke_use_action

      expect(result).to eql(false)
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

  context "#command_restricted?" do
    item = Item.new('gate', 'It\'s a gate', {
      state: :locked,
      command_restrictions: {
        open: {
          restricted_states: [:locked],
        }
      }
    })

    it "should return true if command is restricted and the item is in a restricted state" do
      item.state = :locked
      expect(item.command_restricted?(:open)).to eql(true)
    end

    it "should return false if command is restricted but item is not in a restricted state" do
      item.state = :some_other_state
      expect(item.command_restricted?(:open)).to eql(false)
    end

    it "should return false if command is not restricted" do
      item = Item.new('gate', 'It\'s a gate', {
        state: :locked,
      })
      expect(item.command_restricted?(:open)).to eql(false)
    end
  end

  context "#find_nested_item" do
    item1 = Item.new('hello', '')
    item2 = Item.new('hilo', '')
    item3 = Item.new('hello', '')
    item4 = Item.new('hi', '')
    item5 = Item.new('hell', '')
    item6 = Item.new('hi', '')
    itemA = Item.new('A', '')
    itemB = Item.new('Same', '')
    itemC = Item.new('Same', '')
    itemHidden = Item.new('Hidden', '', is_hidden: true)
    item1.owns << item2
    item1.owns << item3
    item2.owns << item4
    item4.owns << item5
    item4.owns << item6
    itemA.owns << itemB
    itemB.owns << itemC

    it "should return nil if it cannot find an item nested within it" do
      # item1 !<< itemB
      name = 'A'

      expect(item1.find_nested_item(name)).to eql(nil)
    end

    it "should return an item nested multiple levels within it" do
      # item1 << item2 << item4
      name = 'hi'

      expect(item1.find_nested_item(name)).to eql(item4)
    end

    it "should return itself if it has a matching name" do
      # item1 == item1
      name = 'hello'

      expect(item1.find_nested_item(name)).to eql(item1)
    end

    it "should return first (and assumed only) instance of item matching name" do
      # itemA << itemB << itemC
      name = 'Same'

      expect(itemA.find_nested_item(name)).to eql(itemB)
    end

    it "should not return an instance of item matching name if item is hidden" do
      name = 'Hidden'

      expect(itemHidden.find_nested_item(name)).to eql(nil)
    end
  end

  context "#get_flattened_nested_items" do
    item1 = Item.new('hello', '')
    item2 = Item.new('hilo', '')
    item3 = Item.new('hello', '')
    item4 = Item.new('hi', '')
    item5 = Item.new('hell', '')
    item6 = Item.new('hi', '')
    itemA = Item.new('A', '')
    itemB = Item.new('Same', '')
    itemC = Item.new('Same', '')
    item1.owns << item2
    item1.owns << item3
    item2.owns << item4
    item4.owns << item5
    item4.owns << item6
    itemA.owns << itemB
    itemB.owns << itemC

    it "should return an array with itself if it cannot find an item nested within it" do
      expect(itemC.get_flattened_nested_items).to eql([itemC])
    end

    it "should return itself and all nested owned items" do
      expect(item1.get_flattened_nested_items).to eql([item1, item2, item4, item5, item6, item3])
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
