cletus = Person.new('cletus',
"He has a long beard and wiry, white hair that's topped by a ragged farmer's hat -- almost like the kind you would see on a scarecrow.
He's crouched on the inside of a tree limb. It's a wonder he hasn't fallen yet. What a strange fellow.",
location_description: 'There is a strange man perched up on one of the branches.',
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
    action: "lambda { putsy 'hi!!!' }"
  },
})

OLD_TREE = Location.new('old tree','
',
items: [tree])
