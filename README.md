Javascript Growl
================

Requires the Growl SDK for compilation, which can be obtained [here](http://growl.info/downloads_developers.php).

I wanted to write a chrome extension for [Google Music](http://music.google.com) and [The Hype Machine](http://hypem.com) to display alerts in [Growl](http://growl.info), this is the first step.

This is an NPAPI based browser plugin that exposes 4 functions (register, isInstalled, isRunning, and notify) to JS.

Usage
-----
Embed the plugin and then get the embed element, once that is done you can call the JS functions at will.

&lt;embed type="application/x-jsgrowl" id="growl" hidden="true" /&gt;

var growl = document.getElementById('growl');  
growl.register("application name");  
growl.notify("title", "message");  

register
--------
growl.register("application name");  
Registration is a mandatory step before you can call anything further.

The application name is what will show up in the growl preference pane under os x for customizing the alerts.

Register can be called with an optional url to an application icon. growl.register("my app", "http://myapp.com/myicon.png");

isInstalled
-----------
growl.isInstalled() - returns true if growl is installed.

isRunning
---------
growl.isRunning() - returns true if growl is running.

notify
-----
growl.notify("title", "message") - sends to growl with no icon.

growl.notify("title", "message" "image url") - sends to growl and attempts to download url with a 3 second timeout displaying the image as the growl icon

License
=======

(The MIT License)

Copyright (c) 2011 Nicholas Letourneau ( http://nicholasletorneau.com )

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
