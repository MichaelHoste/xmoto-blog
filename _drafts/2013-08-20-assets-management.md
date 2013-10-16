---
layout: post_page
title: 4. Assets management
---

The assets are the files that need to be preloaded for the game to work. These files are images, sounds, videos, that need to be in memory to avoid slow loading when they need to be used (draw, played)

In games, usually, assets need to be loaded in memory (ram) just before a level. This is why there is, most of the time, some loading time before being able to play.

In our game, we will use a very simple asset manager : PreloadJS.
PreloadJS is part of the CreateJS framework.

https://github.com/MichaelHoste/sokoban/blob/4c810698d6d8c0bbe33305ea08b59be713327285/app/assets/javascripts/game/assets.js.coffee
