sombrero = tree = Item.new(
'sombrero',
"It is a wide felt sombrero. Perfect for blocking out the sun's harmful rays.",
can_take: false)

cletus = Person.new('cletus',
"He has a long beard and wiry white hair that's topped by a ragged felt sombrero.
He's crouched on the inside of a tree limb. It's a wonder he hasn't fallen yet. What a strange fellow.",
location_description: 'There is a strange man perched up on one of the branches.',
reveal_description: 'There is a strange man perched up on one of the branches.',
response: "OH BOY, IT'S HOTTER THAN HELL OUT HERE. I got wicked high off of some peyote and when I came to my senses, I was all the way up in this here tree.
Funny thing is.. I'm afraid of heights. Otherwise, I'd be under some shelter somewhere. If I only had something to cool me down...",
owns: [sombrero],
use_on_receiving_action: "lambda do |doing_item|
  GAME.player.drop_from_inventory(doing_item)

  putsy 'OH MY LORD I FEEL SO COOL. THANK YOU'
end
",
aliases: ['strange man', 'man'],
applicable_commands: [],
is_hidden: true)

tree = Item.new(
'tree',
"It is a tall, old tree. It's bark is thick and rough with patches that can be gripped easily.",
location_description: 'You see an old tree that looks like it has been through multiple human lifetimes.',
aliases: ['old tree'],
applicable_commands: [],
owns: [cletus],
custom_commands: {
  climb: {
    aliases: ['climb the tree', 'climb tree'],
    is_hidden: true,
    location_description: 'CLIMB the tree?',
    action: "lambda { putsy 'CLIMBING FUNCTIONALITY ISNT FLUSHED OUT YET. Hint: look at the tree instead :)' }"
  },
},
will_reveal_owned_items_when_looked_at: true)

OLD_TREE = Location.new('old tree','
',
items: [tree])
