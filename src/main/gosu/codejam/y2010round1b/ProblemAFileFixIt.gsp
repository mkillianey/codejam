#!/bin/env gosu
classpath "../.."

// Solution for "Round 1B 2010 Problem A: File Fix-it":
// http://code.google.com/codejam/contest/635101/dashboard#s=p0

uses codejam.SolutionRunner
uses java.io.StringReader
uses java.lang.String
uses java.util.HashSet
uses java.util.List

// ====================================================================
// Solution
// ====================================================================


function log(s : String) {
  // print(s)
}

function solve(existing : List<String>, desired : List<String>) : String {
  var directories = new HashSet<String>()
  directories.add("/")
  for (d in existing) {
    log("Adding directories for existing: ${existing}")
    var pieces = d.substring(1).split("/").map( \ s -> "/${s}")
    var partial = ""
    for (piece in pieces) {
      partial += piece
      if (directories.add(partial)) {
        log("Already had ${partial}")
      }
    }
  }
  var count = 0
  for (d in desired) {
    log("Adding desired directory: ${d}")
    var pieces = d.substring(1).split("/").map( \ s -> "/${s}")
    var partial = ""
    for (piece in pieces) {
      partial += piece
      if (directories.add(partial)) {
        count++
        log("Adding ${count}:  ${partial}")
      } else {
        log("Already had ${partial}")
      }
    }
  }
  return "${count}"
}

var runner = SolutionRunner.from(\ reader -> {
    var values = reader.readLine().split(" ").map( \ elt -> elt.toInt())
    var existing = (0..|values[0]).map( \ _ -> reader.readLine() )
    var desired = (0..|values[1]).map( \ _ -> reader.readLine() )
    return solve(existing, desired)
  })

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
    "3",
    "0 2",
    "/home/gcj/finals",
    "/home/gcj/quals",
    "2 1",
    "/chicken",
    "/chicken/egg",
    "/chicken",
    "1 3",
    "/a",
    "/a/b",
    "/a/c",
    "/b/b",
    ""
    }.join("\n"))

runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "A")
