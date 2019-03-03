require 'spec_helper'

describe 'Item' do
  context "#initialize" do
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
