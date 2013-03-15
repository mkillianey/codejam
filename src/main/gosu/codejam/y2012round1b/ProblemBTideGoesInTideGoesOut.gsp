classpath "../.."

// Source for SolutionRunner is at:
// https://github.com/mkillianey/codejam/blob/f86a21b9d8eb8a8c7ae3fa77db5e2714e68d0cf8/src/codejam/SolutionRunner.gs
uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.*
uses java.util.*

// Solution to Google Codejam 2012 Round 1B Problem B.

var PERSON_HEIGHT = 50.0d

class Cell {
  var _ceiling : double as Ceiling
  var _floor : double as Floor
  var _waterHeight : double as WaterHeight
  var _time : double as BestTime = Double.MAX_VALUE
  var _neighbors : List<Cell> as Neighbors

  function canMoveAtTime(other : Cell) : boolean {
    if (other.Ceiling - Floor < PERSON_HEIGHT) {
      return false
    }
    if (Ceiling - other.Floor < PERSON_HEIGHT) {
      return false
    }
    if (other.Ceiling - other.Floor < PERSON_HEIGHT) {
      return false
    }
    return true
  }
}


function solve(reader : BufferedReader) : String {
  var header = reader.readLine().split(" ").map( \ elt -> elt.toInt() )
  var waterHeight = header[0]
  var numRows = header[1]
  var numColumns = header[2]
  var grid : Cell[][] = new Cell[numRows][numColumns]
  for (i in 0..|numRows) {
    var line = reader.readLine().split(" ").map( \ elt -> elt.toInt())
    for (j in 0..|numColumns) {
      grid[i][j] = new Cell() { :Ceiling = line[j]}
    }
  }
  for (i in 0..|numRows) {
    var line = reader.readLine().split(" ").map( \ elt -> elt.toInt())
    for (j in 0..|numColumns) {
      grid[i][j].Floor = line[j]
    }
  }
  var solution = "Solution for ${header}"    // solution goes here.
  return solution
}

var sampleInput = new StringReader({
    "3",
    "1",
    "2",
    "3",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ x -> solve(x))

runner.solveOneCase({"1 2 3"})
runner.solveAll( sampleInput )
//runner.pollDirectory(".", :prefix = "B")
