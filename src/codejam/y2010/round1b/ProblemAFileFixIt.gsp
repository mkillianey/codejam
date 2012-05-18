#!/bin/env gosu

// Solution for "Round 1B 2010 Problem A: File Fix-it":
// http://code.google.com/codejam/contest/635101/dashboard#s=p0

uses java.io.*
uses java.lang.*
uses java.util.*

var sampleInput = new StringReader({
    "1",
    "problem",
    ""
}.join("\n"))

var prefix = "A"


class Solver {

  construct() {
  }

  function solve(existing : List<String>, desired : List<String>) : String {
    var directories = new HashSet<String>()
    directories.add("/")
    print("-------------------- looking at existing directories --------------")
    for (d in existing) {
      var pieces = d.split("/").map( \ s -> "/${s}")
      var partial = ""
      for (piece in pieces) {
        partial += piece
        if (directories.add(partial)) {
          print("Existing ${partial}")
        }
      }
    }
    print("-------------------- looking at directories to create --------------")
    var count = 0
    for (d in desired) {
      var pieces = d.split("/").map( \ s -> "/${s}")
      var partial = ""
      for (piece in pieces) {
        partial += piece
        if (directories.add(partial)) {
          count++
          print("Adding ${count}:  ${partial}")
        }
      }
    }
    return "${count}"
  }
}

function solveAll(reader : Reader, writer : Writer) {
  var input = new BufferedReader(reader)
  var output = new BufferedWriter(writer)
  var count = input.readLine().toInt()
  for (i in 1..count) {
    var values = input.readLine().split(" ").map( \ elt -> elt.toInt())
    var existing = (0..|values[0]).map( \ elt -> input.readLine())
    var desired = (0..|values[1]).map( \ elt -> input.readLine())
    var solver = new Solver()
    var solution = solver.solve(existing, desired)
    output.write("Case #${i}: ${solution}")
    output.newLine()
  }
  output.flush()
}

solveAll(sampleInput, new OutputStreamWriter(System.out))

function main() {
  var workingDirectory = new File(".")
  for (file in workingDirectory.listFiles()) {
    if (!file.Name.startsWith(prefix)) {
      continue
    }
    if (!file.Name.endsWith(".in")) {
      continue
    }
    var outputFilename = file.Name.substring(0, file.Name.length - 3) + ".out"
    if (workingDirectory.getChild(outputFilename).exists()) {
      print("Input file ${file.Name} already has output file ${outputFilename}")
      continue
    } else {
      print("Solving input ${file.Name}, writing output to ${outputFilename}")
      using (var reader = new FileReader(file.Name)) {
        using (var writer = new FileWriter(outputFilename)) {
          solveAll(reader, writer)
        }
      }
    }
  }
}

main()