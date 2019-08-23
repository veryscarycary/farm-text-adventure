field = Item.new('field',
"It's an expansive, open field.",
)

sun = Item.new('sun',
"AGH! Didn't your mother tell you to never look directly into the sun?",
)

skin = Item.new('skin',
"It's my skin. Wow, I'm pretty pale. I feel like I haven't been outdoors in ages.",
)

FIELD = Location.new('field','
You find yourself in an open field. The sun
is shining very brightly and you feel a faint breeze on your skin.
There is a fence to the south.',
  items: [field, sun, skin],
  blocked_paths: {'south' => {obstruction: 'white picket fence'}}
)
