armchair = Item.new(
'armchair',
"The armchair is made of a soft leather and has a sheen to it.",
  applicable_commands: [:use],
  location_description: "An ornate armchair is positioned in the center of the room.",
)

tv = Item.new(
'tv',
"It's an old CRT style tv. What a bulbous looking thing.",
  applicable_commands: [:use],
  state: :off,
  state_descriptions: {
    on: {
      location: 'There is a tv playing here.',
      item: 'The tv is on.'
    },
    off: {
      location: 'A tv is sitting in the corner.',
      item: 'The tv is off.'
    }
  }
)



LIVING_ROOM = Location.new('
  You step into a finely-decorated living room.
',
items: [armchair, tv],
blocked_paths: {'east' => {obstruction: 'wall'}, 'south' => {obstruction: 'wall'}})
