# farm-text-adventure

# Gameplay

The idea behind this particular story is that you're a person that wakes up in a strange place and you need to
figure out where you are and what you're supposed to do given the context clues. You need to navigate into different areas
using north/south/east/west directions and interact with things around you in order to progress in the game. Once you have
completed all of the correct tasks, the game will come to an end, or you'll eventually lose the game in some fashion.

# Installation

TODO: Confirm that these installation instructions work on a fresh build

- Gray-blocked code below should be run within the terminal

Mac

1.  ```git clone https://github.com/veryscarycary/farm-text-adventure.git```
2.  ```cd farm-text-adventure```
3.  if rbenv(or similar) are not installed, type ```gem install colorize --user-install```
    or
4.  if colorize is not the only dependency, type ```gem install bundler --user-install```. type `bundle install`.
5.  if the shell you are using doesn't have a black background, you should go to preferences to set it to black.
6.  ```ruby game.rb```

Windows

1.  Download .zip
2.  Install Ruby (https://stackify.com/install-ruby-on-windows-everything-you-need-to-get-going/)
3.  Unzip the zip file and go to the farm-text-adventure folder in the command-line
4.  if rbenv(or similar) are not installed, type ```gem install colorize --user-install```
    or
5.  if colorize is not the only dependency, type ```gem install bundler --user-install```. type ```bundle install```.
6.  if the shell you are using doesn't have a black background, you should go to preferences to set it to black.
7.  ```ruby game.rb```

Docker

1. Install Docker
2. In your shell, type and run the following:

```
docker compose build
docker compose up
```

# Development

This game was developed with the intention of being able to plug in different story lines / games with
minimal code changes to the core functionality.

## Story line Code

Each story line will be represented by location pieces that will be plugged into the the map. In the current file structure,
this can be seen in the default_map.rb file. The default_map.rb file requires the needed locations from the locations/ directory which will hold all of the story-specific locations, items, and other story code.

## Core

The core functionality is spread across a few central classes:

- Game
- GameTime
- Player
- Map
- Location
- Item

## Game

Game is responsible for driving the main game process. It initializes the game and all of its connecting pieces and reaches into the other classes when it needs to take actions.

One of the main responsibilities of Game is to take commands from the user. Commands are registered here and are directed into actions here.

## GameTime

This keeps track of the current time in the game. It is initialized early as a constant so it can be available in the global scope in any file.

## Player

Currently, there is only support for 1 player in the game. The main significance of player is that it has a private inventory that the user can access during the game. The user can add and remove items from this inventory.

## Map

Map is essentially a grid(multidimensional array) that is only concerned with managing its x and y movement.

## Location

Location has detailed information of a particular place that is within a spot on the Map. It contains descriptions and items and can set boundaries that the player cannot travel through.

## Item

Item contains all of the detailed information of a particular item, including its name, description, if it's hidden, if it contains(owns) other items, etc.
