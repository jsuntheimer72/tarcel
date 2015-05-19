package require Tcl 8.6
package require tcltest
package require fileutil
namespace import tcltest::*

# Add module dir to tm paths
set ThisScriptDir [file dirname [info script]]
set LibDir [file join $ThisScriptDir .. lib]
set FixturesDir [file normalize [file join $ThisScriptDir fixtures]]


source [file join $LibDir "config.tcl"]
source [file join $LibDir "compiler.tcl"]


test compile-1 {Ensure that you can access the files in the parcel from the init script} -setup {
  set startDir [pwd]
  cd $FixturesDir

  set manifest {
    set appFiles [list \
      [file join eater eater.tcl] \
      [file join eater lib foodplurals.tcl]
    ]

    import $appFiles [file join lib]

    init {
      source [file join lib eater eater.tcl]
      eat orange
    }
  }
  set config [config::parse $manifest]
  set parcel [compiler::compile $config]
  set int [interp create]
} -body {
  $int eval $parcel
} -cleanup {
  interp delete $int
  cd $startDir
} -result {I like eating oranges}


test compile-2 {Ensure can source a parcelled file} -setup {
  set startDir [pwd]
  cd $FixturesDir

  set announcerManifest {
    set files [list \
      [file join announcer announcer.tcl] \
    ]

    import $files [file join lib]

    init {
      source [file join lib announcer announcer.tcl]
    }
  }
  set eaterManifest {
    set appFiles [list \
      [file join eater eater.tcl] \
      [file join eater lib foodplurals.tcl]
    ]

    set modules [list [file join @tmpDir announcer-0.1.tm]]

    import $appFiles [file join lib]
    fetch $modules modules

    init {
      ::tcl::tm::path add modules
      {*}[package unknown] announcer
      package require announcer
      source [file join lib eater eater.tcl]
      announce [eat orange]
    }
  }
  set tmpDir [file join [::fileutil::tempdir] parcelTest_[clock milliseconds]]
  file mkdir $tmpDir
  set eaterManifest [string map [list @tmpDir $tmpDir] $eaterManifest]
  set announcerParcel [compiler::compile [config::parse $announcerManifest]]
  set fd [open [file join $tmpDir announcer-0.1.tm] w]
  puts $fd $announcerParcel
  close $fd
  set eaterParcel [compiler::compile [config::parse $eaterManifest]]
  set int [interp create]
} -body {
  $int eval $eaterParcel
} -cleanup {
  interp delete $int
  cd $startDir
} -result {ANNOUNCE: I like eating oranges}


cleanupTests