#!/bin/env gosu

// Solution for "Round 1B 2010 Problem B: Picking Up Chicks":
// http://code.google.com/codejam/contest/635101/dashboard#s=p1


uses java.io.*
uses java.lang.*
uses java.util.*

var sampleInput = new StringReader({
    "3",
    "5 3 10 5",
    "0 2 5 6 7",
    "1 1 1 1 4",
    "5 3 10 5",
    "0 2 3 5 7",
    "2 1 1 1 4",
    "5 3 10 5",
    "0 2 3 4 7",
    "2 1 1 1 4",
    ""
}.join("\n"))

var prefix = "B"

class Solver {

  function solve(numNeeded : int, barnPosition : int, timeLimit : int, positions : Integer[], velocities : Integer[]) : String {
    var endPositions = (0..|positions.length).toList().map(\ i -> positions[i] + velocities[i]*timeLimit)
    var totalSwaps : int = 0
    var slowChicksToPass : int = 0
    for (endPosition in endPositions.reverse()) {
      if (endPosition >= barnPosition) {
        totalSwaps += slowChicksToPass
        numNeeded -= 1
      } else {
        slowChicksToPass += 1
      }
      if (numNeeded <= 0) {
        return "${totalSwaps}"
      }
    }
    return "IMPOSSIBLE"
  }
}

function solveAll(reader : Reader, writer : Writer) {
  var input = new BufferedReader(reader)
  var output = new BufferedWriter(writer)
  var count = input.readLine().toInt()
  for (i in 1..count) {
    var n_k_b_t = input.readLine().split(" ").map( \ elt -> elt.toInt())
    var numNeeded = n_k_b_t[1]
    var barnPosition = n_k_b_t[2]
    var timeLimit = n_k_b_t[3]

    var positions = input.readLine().split(" ").map( \ elt -> elt.toInt())
    var velocities = input.readLine().split(" ").map( \ elt -> elt.toInt())
    var solution = new Solver().solve(numNeeded, barnPosition, timeLimit, positions, velocities)
    output.write("Case #${i}: ${solution}")
    output.newLine()
  }
  output.flush()
}

//solveAll(sampleInput, new OutputStreamWriter(System.out))

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