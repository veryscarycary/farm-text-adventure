tree = Item.new(
'tree',
"It is a tall, old tree. It's bark is thick and rough with patches that can be gripped easily.",
location_description: 'You see an old tree that looks like it has been through multiple human lifetimes.',
aliases: ['old tree'],
applicable_commands: [],
custom_commands: {
  climb: {
    aliases: ['climb the tree', 'climb tree'],
    location_description: 'CLIMB the tree?',
    action: "lambda { putsy 'hi!!!' }"
  },
})


OLD_TREE = Location.new('old tree','
',
items: [tree])
