package require Tcl 8.6
package require tcltest
package require fileutil
namespace import tcltest::*

set ThisScriptDir [file dirname [info script]]
set LibDir [file join $ThisScriptDir .. lib]
set FixturesDir [file normalize [file join $ThisScriptDir fixtures]]


source [file join $ThisScriptDir "test_helpers.tcl"]
source [file join $LibDir "tararchive.tcl"]
source [file join $LibDir "config.tcl"]
source [file join $LibDir "compiler.tcl"]


test parse-tarcel-1 {Ensure that tarcel will use a tarcel manifesto to tarcel files relative to the manifest file and add it to the tarcel} -setup {
  set startDir [pwd]
  cd $FixturesDir

  set manifest {
    tarcel [file join eater eater.tarcel] modules

    init {
      source [file join modules eater-0.1.tm]
      eat orange
    }
  }
  set config [Config new]
  set tarcel [compiler::compile [$config parse $manifest]]
  set tempFilename [TestHelpers::writeToTempFile $tarcel]
  set int [interp create]
} -body {
  $int eval source $tempFilename
} -cleanup {
  interp delete $int
  cd $startDir
} -result {I like eating oranges}


test parse-tarcel-2 {Ensure that when using tarcel to create a tarcel that the resulting file doesn't include all the setup code} -setup {
  set startDir [pwd]
  cd $FixturesDir

  set manifest {
    tarcel [file join eater eater.tarcel] modules

    init {
      source [file join modules eater-0.1.tm]
      eat orange
    }
  }
  set config [Config new]
  set configSettings [$config parse $manifest]
  set archive [dict get $configSettings archive]
  set eaterScript [$archive read [file join modules eater-0.1.tm]]
} -body {
  set firstLine [lindex [split $eaterScript "\n"] 0]
  set namespaceCount [regexp -all "namespace" $eaterScript]
  set ooClassCount [regexp -all "oo::class" $eaterScript]
  set procCount [regexp -all "proc" $eaterScript]
  set methodCount [regexp -all "method" $eaterScript]
  list $firstLine $namespaceCount $ooClassCount $procCount $methodCount
} -cleanup {
  cd $startDir
} -result [list "::tarcel::launcher::eval \{" 0 0 2 0]


cleanupTests
