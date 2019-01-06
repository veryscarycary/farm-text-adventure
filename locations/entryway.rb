entry_table = Item.new(
'table',
"The entry table has a drawer that stretches its entire width.",
  location_description: "There is an thin table with a drawer against the wall."
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
  }
)

watch = Item.new(
'watch',
"It's an old, antique watch with a copper color to it. It seems to be working just fine.",
  applicable_commands: [:open, :take, :drop],
  reveal_description: "There is a watch inside the drawer",
  location_description: "There is a watch inside the drawer.",
  is_hidden: true,
)


ENTRYWAY = Location.new('
You enter the entryway of the house. It seems like a usual entryway with ample
walking space and baby blue and white striped wallpaper.
',
items: [entry_table, entry_table_drawer, watch],
blocked_paths: {'south' => {obstruction: 'wall'}})
