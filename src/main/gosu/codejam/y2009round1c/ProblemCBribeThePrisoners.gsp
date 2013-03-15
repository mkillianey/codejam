classpath "../.."

// Solution for 2009 Round 1C Problem C "Bribe the Prisoners"
// http://code.google.com/codejam/contest/189252/dashboard#s=p1

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.BufferedWriter
uses java.io.Reader
uses java.io.OutputStreamWriter
uses java.io.StringReader
uses java.io.StringWriter
uses java.io.Writer
uses java.lang.Integer
uses java.lang.Math
uses java.lang.Object
uses java.math.BigDecimal
uses java.text.DecimalFormat
uses java.util.ArrayList
uses java.util.List
uses java.util.Map

// ====================================================================
// Solution
// ====================================================================

class State {
  var _first : int as First
  var _last : int as Last
  var _cells : List<Integer> as CellsToRelease

  override function equals(obj : Object) : boolean {
    return (obj typeis State) && obj._first == _first && obj._last == _last && _cells.equals(obj._cells)
  }

  override function hashCode() : int {
    return _first + _last + _cells.hashCode()
  }

  override function toString() : String {
    return "${First}-${Last}: ${CellsToRelease}"
  }
}

class Solver {

  function genStateLeftOf(state : State, cell : int, cellIndex : int) : State {
    return new State() {
        :_first = state.First,
        :_last = cell,
        :_cells = state.CellsToRelease.subList(0, cellIndex)
    }
  }

  function genStateRightOf(state : State, cell : int, cellIndex : int) : State {
    return new State() {
        :_first = cell,
        :_last = state.Last,
        :_cells = state.CellsToRelease.subList(
            cellIndex + 1, state.CellsToRelease.size())
    }
  }

  function calculateCostFor(state : State) : int {
    if (state.CellsToRelease.Empty) {
      return 0
    }
    var lowestCost = Integer.MAX_VALUE
    var costOfNextRemoval = state.Last - state.First - 2
    for (cell in state.CellsToRelease index cellIndex) {
      var leftCost = calculateCostFor(genStateLeftOf(state, cell, cellIndex))
      var rightCost = calculateCostFor(genStateRightOf(state, cell, cellIndex))
      lowestCost = Math.min(lowestCost, costOfNextRemoval + leftCost + rightCost)
    }
    return lowestCost
  }
}

class MemoizedSolver extends Solver {
  // wanted the key to be State instead of java.lang.Object, but Gosu 0.10.1 barfs on it
  var _cache : Map<java.lang.Object, Integer> = {}

  override function calculateCostFor(state : State) : int {
    if (state._cells.Empty) {
      return 0
    }
    if (_cache.containsKey(state)) {
      return _cache.get(state)
    }
    var result = super.calculateCostFor(state)
    _cache.put(state, result)
    return result
  }
}

function solve(numCells : int, cellsToRelease : List<Integer>) : String {
  cellsToRelease = new ArrayList<Integer>(cellsToRelease.sort())
  var state = new State(){ :_first = 0, :_last = numCells+1, :_cells = cellsToRelease}
  var solver = new MemoizedSolver()
  var result = solver.calculateCostFor(state)
  return "${result}"
}


var runner = SolutionRunner.from(\ reader -> {
    var numCells = reader.readLine().split(" ").map( \ item -> item.toInt() )[0]
    var cellsToRelease = reader.readLine().split(" ")
            .map( \ item -> item.toInt() ).toList()
    return solve(numCells, cellsToRelease)
  })

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
  "2",
  "8 1",
  "3",
  "20 3",
  "3 6 14",
  ""
}.join("\n"))

runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "C")
