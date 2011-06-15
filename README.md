Javascript Growl
================

Requires the Growl SDK for compilation, which can be obtained [here](http://growl.info/downloads_developers.php).

I wanted to write a chrome extension for [Google Music](http://music.google.com) and [The Hype Machine](http://hypem.com) to display alerts in [Growl](http://growl.info), this is the first step.

This is an NPAPI based browser plugin that exposes 3 functions (isInstalled, isRunning, and notify) to JS.

Usage
-----
Embed the plugin and then get the embed object, once that is done you can call the JS functions at will.

&lt;embed type="application/x-growl-plugin" id="growl" hidden="true" /&gt;

var growl = document.getElementById('growl');


isInstalled
----------------
growl.isInstalled() - returns true if growl is installed.

isRunning
--------------
growl.isRunning() - returns true if growl is running.

notify
-----
growl.notify("title", "message") - sends to growl with no icon.

growl.notify("title", "message" "image url") - sends to growl and attempts to download url with a 3 second timeout displaying the image as the growl icon
