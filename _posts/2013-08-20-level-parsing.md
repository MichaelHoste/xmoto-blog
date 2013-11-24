---
layout: post_page
title: 4. Level parsing (.lvl files)
---

### It's time to get our hands dirty !

So, how to start a project like this ? What motivated us to create a new version of XMoto is that you can get the [3000+ levels](http://xmoto.tuxfamily.org/index.php?page=all_levels) designed for XMoto and then reuse them in the web version of the game.

To make it works, the first thing to do is to look into the bowels of a level, preferably a simple level. So we take the first level (`l1038.lvl`) and we open it in our favorite text editor: [Sublime Text](http://www.sublimetext.com).

{% highlight xml linenos %}
<?xml version="1.0" encoding="utf-8"?>
<level id="aero_training1" levelpack="aeRo's Training" levelpackNum="01">
  <info>
    <name>aeRo's Training #01</name>
    <description>Learn important tricks for xmoto here.</description>
    <author>Christian Z</author>
    <date>2007-02-11</date>
    <sky>sky1</sky>
  </info>
  <limits left="-15.000000" right="15.000000" top="7.000000" bottom="-7.000000"/>
  <block id="path2362">
    <position x="-15.075000" y="7.671768"/>
    <usetexture id="Dirt"/>
    <vertex x="3.725000" y="-12.818534" edge="GrayBricks"/>
    <vertex x="4.225000" y="-13.818534" edge="GrayBricks"/>
    <vertex x="12.225000" y="-13.818534"/>
    <vertex x="12.225000" y="-12.818534" edge="GrayBricks"/>
    <vertex x="14.225000" y="-12.818534"/>
    <vertex x="14.225000" y="-11.818534" edge="GrayBricks"/>
    <vertex x="16.225000" y="-11.818534"/>
    <vertex x="16.225000" y="-10.818534" edge="GrayBricks"/>
    <vertex x="18.225000" y="-10.818534"/>
    <vertex x="18.225000" y="-13.818534" edge="GrayBricks"/>
    <vertex x="24.725000" y="-13.818534" edge="GrayBricks"/>
    <vertex x="25.225000" y="-12.818534" edge="GrayBricks"/>
    <vertex x="25.725000" y="-12.318534"/>
    <vertex x="25.725000" y="-11.318534"/>
    <vertex x="25.225000" y="-10.818534"/>
    <vertex x="24.225000" y="-9.318534" edge="GrayBricks"/>
    <vertex x="24.725000" y="-8.318534" edge="GrayBricks"/>
    <vertex x="26.225000" y="-7.318535" edge="GrayBricks"/>
    <vertex x="30.125000" y="-6.218535"/>
    <vertex x="30.125000" y="-15.318534"/>
    <vertex x="0.025000" y="-15.318534"/>
    <vertex x="0.025000" y="-7.918534" edge="GrayBricks"/>
    <vertex x="3.225000" y="-9.318534" edge="GrayBricks"/>
  </block>
  <entity id="path2370" typeid="PlayerStart">
    <size r="0.400000"/>
    <position x="-9.850000" y="-5.946767"/>
  </entity>
  <entity id="path2372" typeid="EndOfLevel">
    <size r="0.500000"/>
    <position x="8.079999" y="-5.276767"/>
  </entity>
  <entity id="path2212" typeid="Sprite">
    <size r="0.400000"/>
    <position x="-6.875000" y="-6.271768"/>
    <param name="z" value="-1"/>
    <param name="name" value="ThisWaySignRight1"/>
  </entity>
</level>
{% endhighlight %}

[![XMoto level 1038](/img/l1038.jpg)](http://xmoto.tuxfamily.org/pages/thumbnail.php?id_level=1038)

Good news: each level is made of [XML](http://en.wikipedia.org/wiki/XML). XML is a markup language easy to read (human) and to parse (computer). There are a lot of libraries for this in every language. Because the web himself is made of XML files (HTML and XHTML especially is kind of a XML file), we can use [jQuery](http://jquery.com), the most popular JavaScript library for this specific task.

jQuery defines itself as

    A fast, small, and feature-rich JavaScript library. It makes things like HTML document traversal and manipulation, event handling, animation, and Ajax much simpler with an easy-to-use API that works across a multitude of browsers. With a combination of versatility and extensibility, jQuery has changed the way that millions of people write JavaScript.

And, as a web developer, I couldn't agree more !


### Structure of a level

When you look at the XML level file, it's not difficult to see what are the most important parts:

 * From line **3** to **10**, general informations (name, description, etc.)
 * From line **11** to **37**, "blocks" are defined by many vertices.
 * From line **38** to **51**, "entities" and you can guess, by the name, the purpose of them (PlayerStart, EndOfLevel, Sprite, ...).

Because you need to start somewhere, the first step of our game development will be to display some level blocks on the screen. For this to be completed, we need to parse the blocks from the XML file.

### XML parsing

In our case, we don't want to make HTML manipulations, but XML manipulations. More specifically we want to parse the file. "Parsing" is getting data from the file and store it into the memory of the computer. Next, we will be able to use this data to display it on the user's screen.

Don't worry, jQuery has someting just for us: [jQuery.parseXML(data)](http://api.jquery.com/jQuery.parseXML/). Their example is the following :

{% highlight javascript linenos %}
var xml    = "<rss version='2.0'><channel><title>RSS Title</title></channel></rss>";
var xmlDoc = $.parseXML( xml );
var title  = $( xmlDoc ).find( "title" );
{% endhighlight %}

On the first line, they write a simple XML string. Then they parse this string to get a nice structure in memory. On the third line, they use the `find()` method to get the value of the `<title>` tag on the XML. As you may guess, at the end, the title variable contains 'RSS Title'.

In XMoto, the XML is not stored in a string, but in a file. So we need to do things differently. The solution is to make an AJAX call to our file and then call (line 10) a parsing method when the file is loaded.

The (high level) code is the following :

{% highlight coffeescript linenos %}
class Level
  constructor: ->

  # Load a specific level in a XML pack
  load_from_file: (file_name) ->
    $.ajax({
      type:     "GET",
      url:      "/xmoto_data/Levels/#{file_name}",
      dataType: "xml",
      success:  @xml_parser
      async:    false
    })

  # Parse the level XML
  xml_parser: (xml) ->
    @xml_parse_infos(xml)
    @xml_parse_layer_offsets(xml)
    @xml_parse_limits(xml)
    @xml_parse_script(xml)
    @xml_parse_blocks(xml)
    @xml_parse_entities(xml)

# Load and file the level
level = new Level()
level.load_from_file('l1038.lvl')
{% endhighlight %}

The ```@xml_parse_*``` methods are method dedicated to parse specific informations of the file. As we want to parse blocks, this is the ```xml_parse_blocks()``` method.

{% highlight coffeescript linenos %}
xml_parse_blocks: (xml) ->

  # xml structure
  xml_blocks = $(xml).find('block')

  # where we are going to store block informations
  @blocks = []

  # we parse each blocks from the structure
  for xml_block in xml_blocks
    block =
      id: $(xml_block).attr('id')
      position:
        x: parseFloat($(xml_block).find('position').attr('x'))
        y: parseFloat($(xml_block).find('position').attr('y'))
      usetexture:
        id: $(xml_block).find('usetexture').attr('id')
      vertices: []

    # we parse each vertices of the block
    xml_vertices = $(xml_block).find('vertex')
    for xml_vertex in xml_vertices
      vertex =
        x:    parseFloat($(xml_vertex).attr('x'))
        y:    parseFloat($(xml_vertex).attr('y'))
        edge: $(xml_vertex).attr('edge')

      block.vertices.push(vertex)
    @blocks.push(block)
{% endhighlight %}

The purpose of this method is to create an internal structure (hash) with general informations about the blocks of the level : position of blocks, texture of blocks, position of vertices (a block is made of a certain number of vertices), etc.

The same parsing structure is repeated for general informations, entities, etc. And after that, every useful part of information about a level is stored in memory.

Next step would be to display that information on the screen, but first, we need to create our own [Assets Manager](/2013/11/20/assets-management.html)

### More informations

 * [xmoto_level.coffee](https://github.com/MichaelHoste/sokoban/blob/4c810698d6d8c0bbe33305ea08b59be713327285/app/assets/javascripts/game/xmoto_level.js.coffee) (source code)

