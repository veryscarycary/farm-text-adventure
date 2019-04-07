bed = Item.new('bucket',
"It's an old rusty bucket.",
  location_description: "There is a bucket sitting against one of the stalls.",
  applicable_commands: [:take, :drop]
)

BARN = Location.new('
You arrive at what looks like a very dilapidated barn. It\'s clear that it
hasn\'t been used in ages. There are a few old horse stalls here but no sign of horses.
',
items: [bed])


