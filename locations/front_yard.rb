house = Item.new(
'house',
"It's a southern-style house -- kind of like the one in Little House on the Prairie.",
)


mailbox = Item.new(
'mailbox',
"It's an old-style mailbox with the red lever sticking up.",
  applicable_commands: [:open],
  state: :closed,
  state_descriptions: {
    open: {
      location: 'You are standing near an open mailbox.',
      item: 'The mailbox is open.'
    },
    closed: {
      location: 'You are standing near a mailbox.',
      item: 'The mailbox is closed.'
    }
  }
)

letter = Item.new(
'letter',
"The letter is signed and dated by somebody. It looks pretty official.",
  read_description: "The letterhead of the message reads 'Perry Ford Bank'
in large block font. The letter reads, 'It has come to our
attention that you have been delinquent on your property loan
payment for more than 6 months. Pursuant to UCC code 018B,
we have the authority to foreclose your property if we do
not find evidence of active farming activities taking
place at your address. Our investigation will take place
on October 15, 2018 at 6PM.'",
  applicable_commands: [:take, :drop, :read],
  reveal_description: "There is a letter inside the mailbox.",
  location_description: "There is a letter inside the mailbox.",
  is_hidden: true,
)



FRONT_YARD = Location.new('
There is a quaint, southern-style house in front of you toward the south.
',
description_2: 'It looks like this mailbox might have been sent some mail.',
items: [house, mailbox, letter],
blocked_paths: {
  'west' => {obstruction: 'white picket fence'},
  'east' => {obstruction: 'white picket fence'},
  'north' => {obstruction: 'locked gate'}}
)
