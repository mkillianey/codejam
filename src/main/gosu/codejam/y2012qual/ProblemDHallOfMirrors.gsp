classpath "../.."

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.AssertionError
uses java.lang.Integer
uses java.lang.Math
uses java.lang.System

// http://code.google.com/codejam/contest/1460488/dashboard#s=p3
// Google Code Jam 2012 Qualification Round Problem D. Hall of Mirrors

// ====================================================================
// Solution
// ====================================================================

function debug(s : block() : String) {
  // print(s()) // Uncomment for debugging messages
}

class Solver {
  var _grid : char[][] as Grid
  var _depth : int as Depth
  var _start : int[] as Start

  function solve() : String {
    var count = 0
    var isExpressedInLeastTerms = \ x : int, y : int -> {
      x = Math.abs(x)
      y = Math.abs(y)
      while (x > 1 && y > 1) {
        if (x > y) {
          x = x-y
        } else {
          y = y-x
        }
      }
      return x == 1 || y == 1
    }
    for (dx in -Depth..Depth) {
      for (dy in -Depth..Depth) {
        if ((dx*dx + dy*dy <= Depth*Depth)
            && isExpressedInLeastTerms(dx, dy)
            && canSeeReflectionLooking(dx, dy)) {
          count += 1
        }
      }
    }
    return "${count}"
  }

  function canSeeReflectionLooking(dx : int, dy : int) : boolean {
    var delta : int[] = { dx, dy }
    debug(\ -> "*** Looking from ${Start} in direction ${delta}")

    // Use modified Bresenham line algorithm to trace line of sight using integer math
    var direction : int[] = { Integer.signum(delta[0]), Integer.signum(delta[1]) }
    var position : int[] = { Start[0], Start[1] }
    var scale : int = Math.max(Math.abs(dx), Math.abs(dy))
    var firstDirectionToProcess = (scale == Math.abs(dx)) ? 1 : 0
    var secondDirectionToProcess = 1 - firstDirectionToProcess

    var offset : int[] = {0, 0}
    var traveled: int[] = {0, 0}
    var mirrorAt = \ x : int, y : int -> (Grid[x][y] == '#')

    var advanceDirection = \ i : int -> {
      if (offset[i] * direction[i] >= scale) {
        offset[i] -= 2 * scale * direction[i]
        var nextSpace : int[] = { position[0], position[1] }
        nextSpace[i] += direction[i]
        if (mirrorAt(nextSpace[0], nextSpace[1])) {
          debug(\ -> "Bounce against mirror at ${nextSpace}")
          offset[i] = -offset[i]
          delta[i] = -delta[i]
          direction[i] = -direction[i]
        } else {
          debug(\ -> "Move to ${nextSpace}")
          position[i] += direction[i]
        }
      }
    }

    while (true) {
      offset[0] += delta[0]
      offset[1] += delta[1]
      traveled[0] += delta[0] * direction[0]
      traveled[1] += delta[1] * direction[1]
      if ((traveled[0]*traveled[0]) + (traveled[1]*traveled[1]) > (2*scale*Depth * 2*scale*Depth)) {
        debug(\ -> "Exceeded depth without finding reflection")
        return false
      }
      if ((offset[0] == 0) && (offset[1] == 0) && (position[0] == Start[0]) && (position[1] == Start[1])) {
        debug(\ -> "Found reflection!")
        return true // Back to starting position
      }
      if ((offset[0] * direction[0] == scale) && (offset[1] * direction[1] == scale)) {
        var nextSpace : int[] = { position[0] + direction[0], position[1] + direction[1] }
        if (mirrorAt(nextSpace[0], nextSpace[1])) {
          if (!mirrorAt(nextSpace[0], position[1]) && !mirrorAt(position[0], nextSpace[1])) {
            debug(\ -> "Light destroyed at corner of ${nextSpace}")
            return false // Hit corner that destroys light
          }
        } else {
          debug(\ -> "Light passes through corner from ${position} to ${nextSpace}")
          // Passing through corner
          offset[0] -= 2 * scale * direction[0]
          offset[1] -= 2 * scale * direction[1]
          position[0] += direction[0]
          position[1] += direction[1]
        }
      }
      advanceDirection(firstDirectionToProcess)
      advanceDirection(secondDirectionToProcess)
    }
    throw new AssertionError("This line should be unreachable")
  }
}

var runner = SolutionRunner.from(\ reader -> {
    var values = reader.readLine().split(" ").map( \ s -> s.toInt() )
    var h = values[0]
    var w = values[1]
    var depth = values[2]
    var grid = new char[h][w]
    for (row in 0..|h) {
      for (ch in reader.readLine().trim().toCharArray() index col) {
        grid[row][col] = ch
      }
    }
    var start : int[] = {0, 0}
    for (row in grid index rowIndex) {
      for (ch in row index columnIndex) {
        if (ch == 'X') {
          start = {rowIndex, columnIndex}
        }
      }
    }
    var solver = new Solver() { :Grid = grid, :Depth = depth, :Start = start }
    return solver.solve()
  })

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
    "6",
    "3 3 1",
    "###",
    "#X#",
    "###",
    "3 3 2",
    "###",
    "#X#",
    "###",
    "4 3 8",
    "###",
    "#X#",
    "#.#",
    "###",
    "7 7 4",
    "#######",
    "#.....#",
    "#.....#",
    "#..X..#",
    "#....##",
    "#.....#",
    "#######",
    "5 6 3",
    "######",
    "#..X.#",
    "#.#..#",
    "#...##",
    "######",
    "5 6 10",
    "######",
    "#..X.#",
    "#.#..#",
    "#...##",
    "######",
    ""
}.join("\n"))

var cornerCase = new StringReader({
    "1",
    "5 5 5",
    "#####",
    "#.#.#",
    "#.X##",
    "#...#",
    "#####",
    ""
}.join("\n"))


runner.solveAll(sampleInput)
runner.solveAll(cornerCase)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "D")

