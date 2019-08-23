living_room = Item.new('living_room', "It's a a finely-decorated living room.");

armchair = Item.new(
'armchair',
"The armchair is made of a soft leather and has a sheen to it.",
  aliases: ['chair', 'ornate armchair'],
  applicable_commands: [:use],
  use_description: "You sit down on the chair. Wow. It's surprisingly comfy.\n\n Alright, enough of that.",
  location_description: "An ornate armchair is positioned in the center of the room.",
)

pendulum = Item.new(
'pendulum',
"It's a copper pendulum.",
)

clock = Item.new(
'clock',
"This grandfather clock looks super old but charming. It has a large copper pendulum that swings back and forth.",
  # appends 'The time reads: #{TIME.current_time}' to description and use description'
  requires_time: true,
  use_redirect: :look_at,
  aliases: ['grandfather clock'],
  applicable_commands: [:use],
  location_description: "There is a large grandfather clock up against the wall.",
  owns: [pendulum]
)

tv = Item.new(
'tv',
"It's an old CRT style tv. What a bulbous looking thing.",
  applicable_commands: [:use],
  state: :off,
  use_action: 'lambda do
    if @state == :on
      update_state(:off)

      off_output = "You turned off the #{@name}."

      putsy "#{off_output} #{@state_descriptions[@state][:trigger]}"

    elsif @state == :off
      update_state(:on)

      on_output = "You turned on the #{@name}."

      putsy "#{on_output} #{@state_descriptions[@state][:trigger]}"

    end
  end
  ',
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



LIVING_ROOM = Location.new('living room','
  You step into a finely-decorated living room.
',
items: [living_room, clock, armchair, tv],
blocked_paths: {'east' => {obstruction: 'wall'}, 'south' => {obstruction: 'wall'}, 'north' => {obstruction: 'wall'}})
