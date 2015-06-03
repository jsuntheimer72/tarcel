package require Tcl 8.6
package require tcltest
namespace import tcltest::*

set ThisScriptDir [file dirname [info script]]
set LibDir [file join $ThisScriptDir .. lib]
set FixturesDir [file normalize [file join $ThisScriptDir fixtures]]


source [file join $ThisScriptDir "test_helpers.tcl"]
source [file join $LibDir "tar.tcl"]
source [file join $LibDir "tararchive.tcl"]
source [file join $LibDir "embeddedchan.tcl"]
source [file join $LibDir "config.tcl"]
source [file join $LibDir "compiler.tcl"]


test info-1 {Ensure lists files in tarcel} -setup {
  set startDir [pwd]
  cd $FixturesDir

  set manifest {
    set appFiles [list \
      [file join eater eater.tcl] \
      [file join eater lib foodplurals.tcl]
    ]
    set modules [list \
      [find module configurator]
    ]

    import $appFiles [file join lib]
    fetch $modules modules

    init {
      source [file join lib eater eater.tcl]
      eat orange
    }
  }

  set infoScript {
    set ThisDir [file dirname [info script]]
    set LibDir [file join $ThisDir .. lib]
    source [file join $LibDir tar.tcl]
    set tarball [::tarcel::tar::extractTarballFromFile @tempFilename]
    eval [::tarcel::tar::getFile $tarball lib/commands.tcl]
    ::tarcel::commands::info $tarball
  }

  set config [Config new]
  set tarcel [compiler::compile [$config parse $manifest]]
  set tempFilename [TestHelpers::writeToTempFile $tarcel]
  cd $startDir
  set infoScript [
    string map [list @tempFilename $tempFilename] $infoScript
  ]
  set int [interp create]
  $int eval info script [info script]
} -body {
  $int eval $infoScript
} -cleanup {
  interp delete $int
  cd $startDir
} -result [
  dict create filenames [
    list config/info \
         config/init.tcl \
         lib/commands.tcl \
         lib/embeddedchan.tcl \
         lib/launcher.tcl \
         lib/tar.tcl \
         lib/tararchive.tcl \
         lib/tvfs.tcl \
         main.tar
  ]
]


test info-2 {Ensure lists homepage set in tarcel} -setup {
  set startDir [pwd]
  cd $FixturesDir

  set manifest {
    set appFiles [list \
      [file join eater eater.tcl] \
      [file join eater lib foodplurals.tcl]
    ]
    config set homepage "http://example.com/tarcel"
    import $appFiles [file join lib]

    init {
      source [file join lib eater eater.tcl]
      eat orange
    }
  }

  set infoScript {
    set ThisDir [file dirname [info script]]
    set LibDir [file join $ThisDir .. lib]
    source [file join $LibDir tar.tcl]
    set tarball [::tarcel::tar::extractTarballFromFile @tempFilename]
    eval [::tarcel::tar::getFile $tarball lib/commands.tcl]
    ::tarcel::commands::info $tarball
  }

  set config [Config new]
  set tarcel [compiler::compile [$config parse $manifest]]
  set tempFilename [TestHelpers::writeToTempFile $tarcel]
  cd $startDir
  set infoScript [
    string map [list @tempFilename $tempFilename] $infoScript
  ]
  set int [interp create]
  $int eval info script [info script]
} -body {
  dict get [$int eval $infoScript] homepage
} -cleanup {
  interp delete $int
  cd $startDir
} -result {http://example.com/tarcel}


test info-3 {Ensure lists version set in tarcel} -setup {
  set startDir [pwd]
  cd $FixturesDir

  set manifest {
    set appFiles [list \
      [file join eater eater.tcl] \
      [file join eater lib foodplurals.tcl]
    ]
    config set version 0.1
    import $appFiles [file join lib]

    init {
      source [file join lib eater eater.tcl]
      eat orange
    }
  }

  set infoScript {
    set ThisDir [file dirname [info script]]
    set LibDir [file join $ThisDir .. lib]
    source [file join $LibDir tar.tcl]
    set tarball [::tarcel::tar::extractTarballFromFile @tempFilename]
    eval [::tarcel::tar::getFile $tarball lib/commands.tcl]
    ::tarcel::commands::info $tarball
  }

  set config [Config new]
  set tarcel [compiler::compile [$config parse $manifest]]
  set tempFilename [TestHelpers::writeToTempFile $tarcel]
  cd $startDir
  set infoScript [
    string map [list @tempFilename $tempFilename] $infoScript
  ]
  set int [interp create]
  $int eval info script [info script]
} -body {
  dict get [$int eval $infoScript] version
} -cleanup {
  interp delete $int
  cd $startDir
} -result {0.1}


cleanupTests