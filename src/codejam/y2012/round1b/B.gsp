classpath "../../.."

// Source for BaseSolver is at:
// https://github.com/mkillianey/codejam/blob/f86a21b9d8eb8a8c7ae3fa77db5e2714e68d0cf8/src/codejam/BaseSolver.gs
uses codejam.BaseSolver
uses java.io.*
uses java.lang.*
uses java.util.*

// Solution to Google Codejam 2012 Round 1B Problem B.

class Solver extends BaseSolver {

  override function solveOneCase(reader : BufferedReader) : String {
    var problem = reader.readLine()
    var solution = "Solution for ${problem}"    // solution goes here.
    return solution
  }

}

var sampleInput = new StringReader({
    "3",
    "1",
    "2",
    "3",
    ""}.join("\n"))

var solver = new Solver()

//solver.tryOneCase({"1 2 3"})
solver.solveAll( sampleInput )
//solver.pollDirectory(".", :prefix = "B")


