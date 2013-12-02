---
layout: post_page
title: 2. Choice of technology
---

### Current XMoto implementation

Since the original XMoto is created in C++, it has to be compiled to serveral platforms. It means that it needs to be compiled for Windows, for MacOS and for Linux. Worse than that, the compilation must be made for different versions of each platforms ([universal binary](http://en.wikipedia.org/wiki/Universal_binary) for MacOS, [different distributions of Linux](http://en.wikipedia.org/wiki/Linux_distribution#Popular_distributions), etc.).

When you have created binary files for each of those plateforms, the work is not done yet, you still have to "package" the binaries into a nice installer for Windows or MacOS, or to push the package to a Package Manager on a Linux distribution ([APT](https://wiki.debian.org/Apt) on Debian distributions, [RPM](http://www.rpm.org/) on RedHat etc.).

This is a nightmare to maintain and hours of configuration and headache for each release ! This is why there is still no MacOS version of XMoto 0.5.10 more than one year after it was released ("Waiting that somebody makes it").

![Versions of XMoto](/img/xmoto-versions.png)

(I tried to make it for the community, but I was only able to compile and use it on my computer, but not to package it. It was quite difficult, and I needed to use XCode that I don't know at all...)

### Web XMoto implementation

With the web implementation, most of these issues magically disappeared !

Once the game is created and published online, it should work on every platforms without any special compilation. The problem lies elsewhere in web development : the gamers will be using different browsers to access the game (Chrome, Internet Explorer, Safari, etc.) and we need to make the game work with all of these browsers.

![Versions of XMoto](/img/browsers.png)

The good news is that the recent versions of browsers seems to technically converge and, usually, when it works on a browser, it works on the others (sometimes there are some small differences but they are quite easy to fix).

### Continuous development

The ***GREAT advantage*** of web development is that you can do continuous development and continuous deployment ! This may be little known to non-technical people but since your application is installed in one single place (the web server), you never have to think about "releases". At any period of time, you are 100% sure that all of your users are using the last version of your game.

This implies 2 things :

 * Unlike original XMoto, you never get the situation where your users are fragmented between versions (ex. 50% of users on 0.5.2, 23% on 0.5.9 and 27% on 0.5.10).
 * When fixing a bug, you just need to execute one single command (usually ```git push...```) to force everybody to use the latest debugged version.

With this kind of development, you are encouraged to iteratively improve your application several times a day (*move fast and break things* like Facebook says). Many developers love that idea !

In the case of web commercial software, since there is no more "releases", users pay yearly or monthly fees ([Software as a Service](http://en.wikipedia.org/wiki/Software_as_a_service) or SaaS). That's exactly because of the better software development cycle and more stable business model that web applications are currently killing the traditional "destkop applications" industry.

Ever wondered why Chrome is like an OS but with web applications ? Now you can make an educated guess :-)

### Web technology

If I wrote this blog 10 years ago, the goal of this chapter would be to introduce you to Macromedia Flash ([Adobe Flash](http://www.adobe.com/products/flash.html) since 2005). Flash was a great tool for web animations but it is now slowly replaced by [HTML5](http://www.w3schools.com/html/html5_intro.asp) new features like Canvas, that support 2D and even 3D with OpenGL. These new features are directly integrated in recent browsers and don't need any plugins to work.

![HTML5](/img/html5.png)

So, I will use HTML5 to create the web version of XMoto. But what does that imply exactly ? It implies that I will be using HTML, CSS and JavaScript, like every other website.

My complete stack will be :

* HTML (+ Canvas 2D)
* CSS
* CoffeeScript
* Box2D

CoffeeScript is a high-level language that compiles to JavaScript, it's the [subject of my next article](/2013/08/19/why-i-love-coffeescript.html).

[Box2D](http://box2d.org/) is a physics engine library that was ported to JavaScript and that is very popular. This library was [used for the Angry Birds games](http://www.geek.com/games/box2d-creator-asks-rovio-for-angry-birds-credit-at-gdc-1321779/).

