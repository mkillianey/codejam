uses java.io.BufferedReader
uses java.io.BufferedWriter
uses java.io.OutputStreamWriter
uses java.io.Reader
uses java.io.StringReader
uses java.io.StringWriter
uses java.io.Writer
uses java.lang.Integer
uses java.lang.AssertionError
uses java.lang.Math
uses java.lang.System
uses java.util.List

function debug(s : block() : String) {
  // print(s()) // Uncomment for debugging messages
}

var sampleInput = {
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
}.join("\n")

var cornerCase = {
    "1",
    "5 5 5",
    "#####",
    "#.#.#",
    "#.X##",
    "#...#",
    "#####",
    ""
}.join("\n")


class Solver {
  var _grid : char[][] as readonly Grid
  var _depth : int as readonly Depth
  var _startX : int as readonly StartX
  var _startY : int as readonly StartY

  construct(grid : char[][], depth : int) {
    _grid = grid
    _depth = depth
    for (row in grid index rowIndex) {
      for (ch in row index columnIndex) {
        if (ch == 'X') {
          _startX = columnIndex
          _startY = rowIndex
        }
      }
    }
  }

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
    debug(\ -> "*** Looking from ${StartX},${StartY} in direction ${dx},${dy}")

    // Use modified Bresenham line algorithm to trace line of sight using integer math
    var xDirection : int = Integer.signum(dx)
    var yDirection : int = Integer.signum(dy)
    var xPosition : int = StartX
    var yPosition : int = StartY
    var scale : int = Math.max(Math.abs(dx), Math.abs(dy))
    var scaleIsXDirection = (scale == Math.abs(dx))

    var xOffset : int = 0
    var yOffset : int = 0
    var xTraveled: int = 0
    var yTraveled: int = 0
    var mirrorAt = \ x : int, y : int -> (Grid[y][x] == '#')

    var advanceXDirection = \ -> {
      if (xOffset * xDirection >= scale) {
        xOffset -= 2 * scale * xDirection
        if (mirrorAt(xPosition + xDirection, yPosition)) {
          debug(\ -> "Bounce against mirror at ${xPosition + xDirection}, ${yPosition}")
          xOffset = -xOffset
          dx = -dx
          xDirection = -xDirection
        } else {
          debug(\ -> "Move to ${xPosition + xDirection}, ${yPosition}")
          xPosition += xDirection
        }
      }
    }

    var advanceYDirection = \ -> {
      if (yOffset * yDirection >= scale) {
        yOffset -= 2 * scale * yDirection
        if (mirrorAt(xPosition, yPosition + yDirection)) {
          debug(\ -> "Bounce against mirror at ${xPosition}, ${yPosition + yDirection}")
          yOffset = -yOffset
          dy = -dy
          yDirection = -yDirection
        } else {
          debug(\ -> "Move to ${xPosition}, ${yPosition + yDirection}")
          yPosition += yDirection
        }
      }
    }

    while (true) {
      xOffset += dx
      yOffset += dy
      xTraveled += dx * xDirection
      yTraveled += dy * yDirection
      if ((xTraveled*xTraveled) + (yTraveled*yTraveled) > (2*scale*Depth * 2*scale*Depth)) {
        debug(\ -> "Exceeded depth without finding reflection")
        return false
      }
      if ((xOffset == 0) && (yOffset == 0) && (xPosition == StartX) && (yPosition == StartY)) {
        debug(\ -> "Found reflection!")
        return true // Back to starting position
      }
      if ((xOffset * xDirection == scale) && (yOffset * yDirection == scale)) {
        if (mirrorAt(xPosition + xDirection, yPosition + yDirection)) {
          if (!mirrorAt(xPosition + xDirection, yPosition) && !mirrorAt(xPosition, yPosition + yDirection)) {
            debug(\ -> "Light destroyed at corner of ${xPosition + xDirection},${yPosition + yDirection}")
            return false // Hit corner that destroys light
          }
        } else {
          debug(\ -> "Light passes through corner from ${xPosition},${yPosition} to ${xPosition + xDirection},${yPosition + yDirection}")
          // Passing through corner
          xOffset -= 2 * scale * xDirection
          yOffset -= 2 * scale * yDirection
          xPosition += xDirection
          yPosition += yDirection
        }
      }
      if (scaleIsXDirection) {
        advanceYDirection()
        advanceXDirection()
      } else {
        advanceXDirection()
        advanceYDirection()
      }
    }
    throw new AssertionError("This line should be unreachable")
  }
}


function solveAll(input : Reader, output : Writer) {
  var reader = new BufferedReader(input)
  var writer = new BufferedWriter(output)
  for (caseNumber in 1..reader.readLine().toInt()) {
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
    var result = new Solver(grid, depth).solve()
    print("Case #${caseNumber}: ${result}")
    writer.write("Case #${caseNumber}: ${result}")
    writer.newLine()
  }
  writer.flush()
  writer.close()
}

//solve(new BufferedReader(new InputStreamReader(System.in)), new OutputStreamWriter(System.out))
//solveAll(new StringReader(sampleInput), new OutputStreamWriter(System.out))
solveAll(new StringReader(cornerCase), new OutputStreamWriter(System.out))
//solveAll(new FileReader("D-small-practice.in"), new FileWriter("D-small-practice.out"))
//solveAll(new FileReader("D-large-practice.in"), new FileWriter("D-large-practice.out"))

