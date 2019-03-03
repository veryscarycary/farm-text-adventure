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
      trigger: 'It quickly illuminates with a THRUMMMMM and shows a congressman standing tall behind a podium. He announces over a crowd, "If we do not resolve our nation\'s dire food shortage issues quickly, we will have a troublesome winter. Our population growth has been at critical levels for years. This year, we may be at a tipping point."',
      location: 'There is a tv playing here.',
      item: 'The tv shows a congressman standing tall behind a podium. He announces over a crowd, "If we do not resolve our nation\'s dire food shortage issues quickly, we will have a troublesome winter. Our population growth has been at critical levels for years. This year, we may be at a tipping point."'
    },
    off: {
      trigger: 'The tv switches off as quickly as it turned on, with a residual horizonal white line fading in the center of the screen.',
      location: 'A tv is sitting in the corner.',
      item: 'The tv is off.'
    }
  }
)



LIVING_ROOM = Location.new('
  You step into a finely-decorated living room.
',
items: [armchair, tv],
blocked_paths: {'east' => {obstruction: 'wall'}, 'south' => {obstruction: 'wall'}, 'north' => {obstruction: 'wall'}})