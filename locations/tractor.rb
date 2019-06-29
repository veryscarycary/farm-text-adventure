TRACTOR_KEY = Item.new(
  'tractor key',
  "It's the a fat metal key.",
  aliases: ['key', 'metal key' ,'fat metal key'],
  applicable_commands: [:use_on, :take],
  location_description: "There's a key sitting on the shelf.",
  reveal_description: "There's a key sitting on the shelf in the shed.",
  is_hidden: true,
)

motor_oil = Item.new(
  'oil',
  "It's the golden elixer that machines love so much.",
  aliases: ['motor oil', 'jug'],
  applicable_commands: [:use_on, :take],
  reveal_description: "There's a jug of motor oil in the shed.",
  location_description: "There's a jug of motor oil here.",
  is_hidden: true,
)

shed = Item.new(
  'shed',
  "The shed is a rusty wind-damaged old thing. There might be something useful in here.",
  applicable_commands: [:open],
  state: :closed,
  state_descriptions: {
    open: {
      location: '',
      item: 'The shed is open.'
    },
    closed: {
      location: '',
      item: "The shed is closed."
    },
  },
  owns: [motor_oil, TRACTOR_KEY],
)

engine = Item.new(
  'engine',
  "The engine is big complicated steel block. Everything looks intact, but it looks like it hasn't been run in ages.",
  applicable_commands: [],
  state: :broken,
  state_descriptions: {
    broken: {
      location: 'The dusty-looking engine is exposed.',
      item: "The engine doesn't look too healthy."
    },
    fixed: {
      location: 'The engine is looking healthy.',
      item: 'The engine is looking healthy.'
    }
  },
  use_on_receiving_actions: {
    oil: "lambda {|doing_item| self.state = :fixed; self.belongs_to.belongs_to.state = :fixed; putsy 'You pour the oil into the engine and it seems to slurp it right up. Now if I can just get this thing to start...'}",
  },
  reveal_description: "A dusty old engine sits before you. It looks like it could at least use some lubrication.",
  is_hidden: true,
)

hood = Item.new(
  'hood',
  "The hood is made of heavy old steel. They don't make 'em like they used to.",
  applicable_commands: [:open],
  state: :closed,
  state_descriptions: {
    open: {
      location: 'The tractor\'s hood is open.',
      item: 'The hood is open.'
    },
    closed: {
      location: 'The tractor\'s hood is closed.',
      item: 'The hood is closed.'
    }
  },
  owns: [engine]
)

plow = Item.new(
  'plow',
  "It has several blades fixed to its wide frame.",
)


tractor = Item.new(
  'tractor',
  "I bet this tractor makes plowing land a breeze.",
  applicable_commands: [:use],
  owns: [hood, plow],
  state: :broken,
  command_restrictions: {
    use: {
      restricted_states: [:broken],
      required_items: [TRACTOR_KEY]
    }
  },
  use_on_receiving_actions: {
    key: "lambda do |doing_item|
      if self.state == :broken
        putsy 'You put the key in the ignition and turn the key. The engine rumbles but quickly dies.';
      else
        putsy 'You put the key in the ignition and turn the key. The engine consistently rumbles. Where would you like to go now?'; GAME.player.add_following_item(self);
      end
    end
    "
  },
  state_descriptions: {
    broken: {
      location: 'It looks like the tractor has seen better days.',
      item: 'The tractor looks pretty borked. It could use some love underneath the hood.'
    },
    fixed: {
      location: 'It looks pretty healthy.',
      item: 'The tractor looks pretty healthy. It looks ready to go.'
    },
  }
)

TRACTOR = Location.new('tractor','An old tractor with a plow attached to it is parked next to a shed.',
items: [tractor, shed],
blocked_paths: {
  'south' => {obstruction: 'wall'},
  'west' => {obstruction: 'white picket fence'}
})
