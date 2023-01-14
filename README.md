# **Magic Square**
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/softpva/magicSquare)
[![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](./README.pt-br.md)
[![es](https://img.shields.io/badge/lang-es-yellow.svg)](./README.es.md)
  

# About
> This 2D game is part of a experimental set of educational games built in godot engine using gdscript language. (like python)  
> A square divided into smaller squares each containing a number, such that the figures in each vertical, horizontal, and diagonal row add up to the same or other values.  
> Move the yellow squares so that their sums become equal to the blue squares horizontally, vertically and diagonally.
>
> [![NPM](https://img.shields.io/npm/l/react)](./LICENSE) 

# Features
> - This game is under develpment.
> - The game consists of a square divided into smaller squares each containing a number.
> - Move (drag) the yellow squares so that their sums become equal to the blue squares horizontally, vertically and diagonally.
> - Only the internal yellow squares can be moved.
> - A tap or a click returns to the previous state.
> - The whished result are in the blue squares at the upper row and at the  right column.
> - Red squares contain wrong results, green squares contain correct ones.
> - The game starts with an internal grid of 2x2 yellow squares, the grid increases in size and difficulty until it reaches a grid of 5x5 yellow squares.
> - A counter in the upper right corner records the points earned. Points vary according to level and correct or incorrect attempts.
> - At higher and very difficult levels, you can get up hints.



# Layouts
> ## A typical 2x2 internal grid start page.   
> ![initial 2x2 page](./readmeImages/start_page_2x2.gif)

> ## When you beat the first challenge above.    
> ![win 2x2 page](./readmeImages/win_2x2.gif)

> ## A typical 3x3 internal grid start page.  
> ![initial 3x3 page](./readmeImages/start_3x3.gif)

> ## Playing the step above. See hint button.  
> ![playing 3x3 page](./readmeImages/hint_3x3.gif)

> ## After press hint button. See the hint below the squares.   
> ![hint 3x3 page](./readmeImages/after_hint_3x3.gif)

> ## Congrats, you hit the challenge above.   
> ![win 3x3 page](./readmeImages/win_3x3.gif)

> ## A typical dificult 4x4 internal grid start page.  
> ![initial 4x4 page](./readmeImages/start_4x4.gif)

> ## A typical very dificult 5x5 internal grid start page.  
> ![initial 5x5 page](./readmeImages/start_5x5.gif)


# Models
> - Godot embraces object-oriented design at its core with its flexible scene system and Node hierarchy.
> - Tree of nodes (node: smallest building blocks) that you group together into scenes. 
> - Nodes communication each other by signals. 
> - A Script in GDScript language is a class that extend (inherit) a node class or you can create a new original one class.

# Tecnologies
> - Godot engine 2.1.4
>     - http://downloads.tuxfamily.org/godotengine/2.1.4/
> - GDScript (like python)

# Kick off
> - Download the engine and the game.
> - Start godot engine and import the engine.cfg in the root directory of the game.
> - Run in dev mode or compile (export) for android, ios, windows, linux, etc.

# Author
> Pedro Vitor Abreu
>
> <soft.pva@gmail.com>
>
> <https://github.com/softpva>
>






