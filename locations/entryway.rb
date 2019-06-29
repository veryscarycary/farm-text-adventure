entryway = Item.new(
'entryway',
"It seems like a usual entryway with ample walking space and baby blue and white striped wallpaper.",
location_description: "It seems like a usual entryway with ample walking space and baby blue and white striped wallpaper."
)

wallpaper = Item.new(
'wallpaper',
"The wallpaper has a baby blue color and white stripes. Typical ranch house style.",
)

watch = Item.new(
  'watch',
  "It's an old, antique watch with a copper color to it. It seems to be working just fine.",
  # appends 'The time reads: #{TIME.current_time}' to description and use description'
  requires_time: true,
  use_redirect: :look_at,
  applicable_commands: [:take, :drop, :use],
  reveal_description: "There is a watch inside the drawer",
  location_description: "There is a watch inside the drawer.",
  is_hidden: true,
)

entry_table_drawer = Item.new(
'drawer',
"It\'s a typical drawer.",
  applicable_commands: [:open],
  state: :closed,
  state_descriptions: {
    open: {
      location: 'The table\'s drawer is open.',
      item: 'The drawer is open.'
    },
    closed: {
      location: '',
      item: 'The drawer is closed.'
    }
  },
  owns: [watch]
)

entry_table = Item.new(
'table',
"The entry table has a drawer that stretches its entire width.",
  aliases: "entry table",
  location_description: "There is a thin table with a drawer against the wall.",
  owns: [entry_table_drawer]
)

ENTRYWAY = Location.new('entryway', '
You enter the entryway of the house.
',
items: [entryway, wallpaper, entry_table],
blocked_paths: {'south' => {obstruction: 'wall'}})
