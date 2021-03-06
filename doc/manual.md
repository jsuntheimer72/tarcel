Tarcel
======
A Tcl packaging tool.

Tarcel allows you to combine a number of files together to create a single tarcel file that can be run by tclsh, wish, or can be sourced into another Tcl script.  This makes it easy to distribute your applications as a single file.  In addition it allows you to easily create Tcl modules made up of several files including shared libraries, and then take advantage of the extra benefits that Tcl modules provide such as faster loading time.

Requirements
------------
*  Tcl 8.6
*  [configurator](https://github.com/LawrenceWoodman/configurator_tcl) v0.2+ module

Definition of Terms
-------------------
<dl>
  <dt>tarcel</dt>
  <dd>A file that has been packaged with the tarcel script.  This is pronounced to rhyme with parcel.</dd>
  <dt>.tarcel</dt>
  <dd>The file that describes how to create the <em>tarcel</em> file.  Pronounced 'dot tarcel'.</dd>
  <dt>tarcel.tcl</dt>
  <dd>The packaging tool script.</dd>
</dl>

Usage
-----
Tarcel is quite easy to use and implements just enough functionality to work for the tasks it has been put to so far.

### Creating a package ###
To create a _tarcel_ file you begin by creating a _.tarcel_ file to describe how to package the _tarcel_ file.  See below for what to put in this file.  You then use the _wrap_ command of _tarcel.tcl_ to create the package.

To create a _tarcel_ called _t.tcl_ out of _tarcel.tcl_ and its associated files using _tarcel.tarcel_ run:

    $ tclsh tarcel.tcl wrap -o t.tcl tarcel.tarcel

The <em>.tarcel</em> file may specifiy the output filename, in which case you don't need to supply `-o outputFilename`.

### Getting Information About a Package ###
To find out some information about a package use the _info_ command of _tarcel.tcl_.  For the example above, to look at _t.tcl_ run:

    $ tclsh tarcel.tcl info t.tcl

This will output something like the following:

    Information for tarcel: t.tcl
    Created with tarcel.tcl version: 0.3

      Homepage: https://github.com/LawrenceWoodman/tarcel
      Version: 0.3
      Files:
        tarcel-0.3.vfs/app/lib/commands.tcl
        tarcel-0.3.vfs/app/lib/compiler.tcl
        tarcel-0.3.vfs/app/lib/config.tcl
        tarcel-0.3.vfs/app/lib/embeddedchan.tcl
        tarcel-0.3.vfs/app/lib/parameters.tcl
        tarcel-0.3.vfs/app/lib/tar.read.tcl
        tarcel-0.3.vfs/app/lib/tar.write.tcl
        tarcel-0.3.vfs/app/lib/tararchive.read.tcl
        tarcel-0.3.vfs/app/lib/tararchive.write.tcl
        tarcel-0.3.vfs/app/lib/tvfs.tcl
        tarcel-0.3.vfs/app/lib/xplatform.tcl
        tarcel-0.3.vfs/app/tarcel.tcl
        tarcel-0.3.vfs/modules/configurator-0.2.tm


### Defining a .tarcel File ###
To begin with it is worth looking at the _tarcel.tarcel_ file supplied in the repo.  This _.tarcel_ file is used to wrap _tarcel.tcl_.

A _.tarcel_ file is a Tcl script which has the following Tcl commands available to it:

* `file` (only supports subcommands: `dirname`, `join` and `tail`)
* `foreach`
* `glob`
* `if`
* `lassign`
* `list`
* `llength`
* `lsort`
* `regexp`
* `regsub`
* `set`
* `string`

In addition it has the following commands to control packaging:
<dl>
  <dt><code>config set varName value</code></dt>
  <dd>Sets variables such as <em>version</em>, <em>hashbang</em>, <em>homepage</em>, <em>outputFilename</em> and <em>init</em>.  The latter is used to set the initialization code for the package to load the rest of the code.</dd>

  <dt><code>error msg</code></dt>
  <dd>Quit processing a <em>.tarcel</em> with an error message.</dd>

  <dt><code>fetch importPoint files</code></dt>
  <dd>Gets the specified <em>files</em> and places them all at the directory specified by <em>importPoint</em> in the package.  The relative directory structure of the files will not be preserved.</dd>

  <dt><code>import importPoint files</code></dt>
  <dd>Gets the specified <em>files</em> and places them at the directory specified by <em>importPoint</em> in the package relative to their original directory structure.</dd>

  <dt><code>find module moduleName [requirement] ...</code></dt>
  <dd>Find the location of a Tcl module.  You can also specify the version requirements for the module.</dd>

  <dt><code>get packageLoadCommands packageName [requirement] ...</code></dt>
  <dd>Returns the commands to load the package from <code>package ifneeded</code>. The result is returned as a two element list, the first element contains the load commands and the second element contains the version found.</dd>

  <dt><code>tarcel destination .tarcelFile [arg] ...</code></dt>
  <dd>Use the <em>.tarcelFile</em> file to package some other code and include the resulting <em>tarcel</em> file at destination in the calling <em>tarcel</em> file.  If you pass any further arguments, then the Tcl variable <code>args</code> will be set with these.</dd>
</dl>

Contributions
-------------
If you want to improve this program make a pull request to the [repo](https://github.com/LawrenceWoodman/tarcel) on github.  Please put any pull requests in a separate branch to ease integration and add a test to prove that it works.  If you find a bug, please report it at the tarcel project's [issues tracker](https://github.com/LawrenceWoodman/tarcel/issues) also on github.

Licence
-------
Copyright (C) 2015, Lawrence Woodman <lwoodman@vlifesystems.com>

This software is licensed under an MIT Licence.  Please see the file, LICENCE.md, for details.
