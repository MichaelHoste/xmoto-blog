---
layout: post_page
title: 5. Assets management
---

### What are game assets ?

When a developer creates a game, he focuses a lot on the code. But he also has to deal with specific files that make the game more beautiful and pleasant to play with : images, sounds, videos, etc. Usually these files are created by artists and integrated into the game by programmers.

Those files are called "assets" and before a user can play with a game, the assets need to be loaded into the computer's memory (RAM). If you don't load these files in memory, multiple accesses to the hard drive will drastically slow your game down.

But in order to reduce the loading time and keeping the memory low, it's advised to load only the minimum set of files required by the current level. Usually the loading is hidden behind a loading screen when the player start a level, and after that, the game go smooth.

[![Loading Screen](/img/loading_screen.jpg)](http://www.popcap.com/plants-vs-zombies)

There are some exceptions in sandbox games where the world is huge like GTA. In these games, assets are loaded in real-time depending on the objects around you (assets streaming).

XMoto, in comparison, is a small game with only a handful of assets : each level has a background and sky texture, some sprites (static or animated), some sounds and the textures of the moto and rider parts. To efficiently deal with these files, we will create an Assets Manager whose job is to collect and load all the files needed to display a specific level.

### Game Loop

To understand the following explanations on asset management, we must introduce the concept of "game loop". The main loop of a game is the sequence of operations the game must do on each frame. Since a smooth game run at about 60 frames per second, the main loop is computed 60 times per second by your computer.

The simplified version of the game loop is the following :

```coffeescript
update = ->
  level.input()
  level.physics()
  level.display()

game_loop = setInterval(update, 1000 / 60)
```

the ```update()``` function is defined by 3 other functions :

 * ```level.input()``` : watch if the player presses a key or moves the mouse.
 * ```level.physics()``` : depending on inputs and the physics laws (gravity etc.), the new positions of the game objects are computed.
 * ```level.display()``` : the screen is refreshed with the new object positions.

```setInterval(update, 1000 / 60)``` just tells your browser to execute the ```update()``` function 60 times per second. No need to say that these functions must be really fast and optimized (less than 16ms) since they are called so many times...

> **Note** : this game loop is very naive because the game doesn't work well if the computer is not powerful enough to loop at the speed of 60 frames per second. We'll see later how we can improve that.

To be sure the main loop is not executed before the assets are in memory, we only launch the game main loop after they are loaded.

This goes like this :

```coffeescript
level = new Level()
level.load_from_file(name)

# Load assets for this level before doing anything else
level.assets.load( ->
  update = ->
    level.input()
    level.physics()
    level.display()

  game_loop = setInterval(update, 1000 / 60)
)
```

The line ```level.assets.load( ->``` just say "load the assets, and then, when they are loaded, execute the following functions". In our example, "the following functions" are our main loop.

### PreloadJS

But how exactly works the assets loading ?

We choose to use [PreloadJS](http://www.createjs.com/#!/PreloadJS) that is part of the [CreateJS](http://www.createjs.com) framework. PreloadJS purpose is to create [AJAX](http://en.wikipedia.org/wiki/Ajax_(programming) calls to get some files and store then into the memory. When those files are loaded, a callback is executed (a callback is a function like the ```->``` symbol of CoffeeScript) and the rest of the game can be executed.

[![CreateJS](/img/createjs.jpg)](http://www.createjs.com)

[![PreloadJS](/img/preloadjs.png)](http://www.createjs.com/#!/PreloadJS)

Just like our ```level.assets.load()``` that, when all the assets are loaded, call the function passed as argument (```-> input();physics();display();```).

The code where PreloadJS is used lies in the ```Assets.coffee``` file. Here is a simplified version of it :

```coffeescript
class window.Assets

  constructor: ->
    @queue = new createjs.LoadQueue()
    @list     = [] # complete list of assets
    @textures = [] # texture list
    @anims    = [] # anim lists

  # Load a batch of textures in this format [{ id: "", src: ""}, {...}]
  load: (items, callback) ->
    for item in items
      @list.push(item.id)

    @queue.addEventListener("complete", callback)
    @queue.loadManifest(items)

  # Load textures for a specific level
  load_for_level: (xmoto_level, callback) ->
    # Sky (Textures)
    @list    .push(xmoto_level.infos.sky.name)
    @textures.push(xmoto_level.infos.sky.name)

    # Blocks (Textures)
    for block in xmoto_level.blocks
      @list    .push(block.usetexture.id)
      @textures.push(block.usetexture.id)

    # Sprites (Anims)
    for entity in xmoto_level.entities
      if entity.type_id == 'Sprite'
        for param in entity.params
          if param.name == 'name'
            @list .push(param.value)
            @anims.push(param.value)

    # Format list for loading
    items = []
    for item in @textures
      items.push(
        id:  item
        src: "/xmoto_data/Textures/Textures/#{item}.jpg"
      )
    for item in @anims
      items.push(
        id:  item
        src: "/xmoto_data/Textures/Anims/#{item}.png"
      )

    @queue.addEventListener("complete", callback)
    @queue.loadManifest(items)

  # Get an asset by its name ("id")
  get: (name) ->
    @queue.getResult(name)
```

Some tips to understand this code :

 * ```@queue.addEventListener("complete", callback)``` tells that when the assets loading is complete, call the ```callback``` method. This is the method we passed as parameter.
 * ```@queue.loadManifest(items)``` loads all the assets of the ```items``` array.

### Tell the asset manager to load an asset

### Ask the asset manager the link to an asset

### More informations

 * [Documentation of PreloadJS](http://www.createjs.com/Docs/PreloadJS/modules/PreloadJS.html)
 * [Documentation of LoadQueue Class of PreloadJS](http://www.createjs.com/Docs/PreloadJS/classes/LoadQueue.html) (very complete)
