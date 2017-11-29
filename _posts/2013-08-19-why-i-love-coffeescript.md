---
layout: post_page
title: 3. Why I love CoffeeScript
---

Like I said in my [previous post](/2013/08/18/choice-of-technology.html), I will use [CoffeeScript](http://coffeescript.org/) instead of JavaScript to develop XMoto for the web. This choice may not be obvious for all of you, but I'd say it's a very good foundation for any web application.

But what exactly is CoffeeScript ?

[![CoffeeScript](/img/coffeescript.png)](http://coffeescript.org/)

### "It's just JavaScript"

Like the official documentation says: *CoffeeScript is an attempt to expose the good parts of JavaScript in a simple way*.

CoffeeScript is just "another way to write JavaScript". Indeed, your CoffeeScript code will be transformed (compiled) to JavaScript. The *generated JavaScript code* will then be interpreted by the browser. Note that JavaScript is the only language that the browser is able to execute.

CoffeeScript is compatible with every JavaScript libraries and this is very important for this project because we want to use Box2D.

### Background

For my passion for CoffeeScript to be well-understood, you need to know my programming background.

My first primary language was C, then C++. I made [some](http://pongl.xc-lan.be/) [games](http://www.youtube.com/watch?v=NOhIY6--W7s) using OpenGL with these languages so I was pretty confortable programming using curly brackets `{ }`, parentheses `( )`, variable declarations, `*.h` header files, etc.

For my studies, I needed to use Java (and I hated all those [silly patterns](http://www.fluffycat.com/Java-Design-Patterns/) that we were forced to use for small projects !). I liked static and compiled languages but my need to be fast to hack small applications made me switch to more dynamic and interpreted languages like Python and Ruby.

Programming with Ruby was an experience so nice that I made it my job, [developing web applications using Ruby on Rails](http://www.80limit.com).

When I started to develop with JavaScript, it was a burden for me to write code. The syntax was verbose like the one of C, Java, etc. I didn't want to go back to this so I looked for alternatives and I found CoffeeScript.

### Syntactic sugar

CoffeeScript comes with nice syntactic sugar that makes the syntax very clean. Like Python, the use of curly brackets `{ }` is replaced by the indentation of lines. You love it or you hate it, but for my part I like the strict convention.

Here are some examples of CoffeeScript syntax opposite to JavaScript syntax.


#### Conditions

JavaScript

```javascript
if (true) {
  alert(';)');
}
else {
  alert(':(')
}
```

CoffeeScript

```coffeescript
if true
  alert ';)'
else
  alert ':('
```

You can also use one-line conditions

```coffeescript
alert ';)' if true
```

#### Loops

JavaScript

```javascript
var array = ["Hello", "World"];
for (var i = 0; i < array.length; i++) {
    alert(array[i]);
}
```

CoffeeScript

```coffeescript
for word in ["Hello", "World"]
  alert word
```

#### Ruby-style string interpolation.

Javascript

```javascript
var author, quote, sentence;
author = "Wittgenstein";
quote = "A picture is a fact. -- " + author;
```

CoffeeScript

```coffeescript
author = "Wittgenstein"
quote  = "A picture is a fact. -- #{ author }"
```


#### Simple hash with a function in it

Javascript

```javascript
math = {
  root: Math.sqrt,
  square: square,
  cube: function(x) {
    return x * square(x);
  }
};
```

CoffeeScript

```coffeescript
math =
  root:   Math.sqrt
  square: square
  cube:   (x) -> x * square x
```

#### Classes

The most important advantage of CoffeeScript, for me, is the syntax of classes. JavaScript comes with prototypes that you can use to emulate classes. The bad part is that it increases the syntax burden.

CoffeeScript provides a very clean class structure with inheritance, constructor, etc.

```coffeescript
class Animal
  constructor: (@name) ->

  move: (meters) ->
    alert @name + " moved #{meters}m."

class Snake extends Animal
  move: ->
    alert "Slithering..."
    super 5

class Horse extends Animal
  move: ->
    alert "Galloping..."
    super 45

sam = new Snake "Sammy the Python"
tom = new Horse "Tommy the Palomino"

sam.move()
tom.move()
```

This class structure is what makes me switch to CoffeeScript for another project: [Sokoban](https://sokoban-game.com). When I converted some of my code from C to CoffeeScript, the size of the file was more 2 times smaller than the original size and nicer to read.

Here is a real CoffeeScript class that manage the creation of a Sokoban level with specfic methods to move the player and the boxes, or to roll back the movements : [CoffeeScript file](https://github.com/MichaelHoste/sokoban/blob/bc1f708af2c6d4aaf3f181ee1763a728c52a9a27/app/assets/javascripts/game/models/level_core.js.coffee).

This file is so clean in regard of a JavaScript file that, since that day, I switched and only write web applications using CoffeeScript.


### How to setup CoffeeScript

Since CoffeeScript compiles to JavaScript, you have to install a binary file on your system and execute a simple command to generate your `.js` file :

```sh
coffee -j bin/xmoto.js -wc src/*
```

It just says that it compiles each `.js` file from the `src/*` directory to `bin/xmoto.js` and join them in a single file (you can have multiple .coffee files).

the option "-w" means that coffee watches for any change you make in one of the `.coffee` files. At the moment you changed something, the new corresponding `.js` file is generated in realtime.

This way, you can code CoffeeScript on your editor and directly see the resulting web page on your browser in realtime with the last `.js` file.

### More information

 * [Official website](http://coffeescript.org)
 * [Try CoffeeScript online](http://coffeescript.org/#try:alert%20%22Hello%20CoffeeScript!%22)
 * [The Little Book on CoffeeScript](http://arcturo.github.io/library/coffeescript)
