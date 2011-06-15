Javascript Growl
================

I wanted to write a chrome extension for [Google Music](http://music.google.com) and [The Hype Machine](http://hypem.com) to display alerts in [Growl](http://growl.info), this is the first step.

This is an NPAPI based browser plugin that exposes 3 functions to JS.

isGrowlInstalled
----------------
plugin.isGrowlInstalled() - self explanitory

isGrowlRunning
--------------
plugin.isGrowlRunning() - also self explanitory

alert
-----
plugin.alert("title", "message") - sends to growl with no icon.

plugin.alert("title", "message" "image url") - sends to growl and attempts to download url with a 3 second timeout displaying the image as the growl icon
