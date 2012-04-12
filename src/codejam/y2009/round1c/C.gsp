classpath "../../../../lib/guava-11.0.2.jar"

// Solution for 2009 Round 1C Problem C "Bribe the Prisoners"
// http://code.google.com/codejam/contest/189252/dashboard#s=p1

uses java.io.*
uses java.lang.*
uses java.math.BigDecimal
uses java.text.DecimalFormat
uses java.util.*

uses com.google.common.collect.ImmutableList

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
  var _cache : Map<State, Integer> = {}

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
  cellsToRelease = ImmutableList.copyOf(cellsToRelease.sort())
  var state = new State(){ :_first = 0, :_last = numCells+1, :_cells = cellsToRelease}
  var solver = new MemoizedSolver()
  var result = solver.calculateCostFor(state)
  return "${result}"
}


function solveAll(input : Reader, output : Writer) {
  var reader = new BufferedReader(input)
  var writer = new BufferedWriter(output)
  for (i in 1..reader.readLine().toInt()) {
    var numCells = reader.readLine().split(" ").map( \ item -> item.toInt() )[0]
    var cellsToRelease = reader.readLine().split(" ")
            .map( \ item -> item.toInt() ).toList()
    print("Solving case #${i}: ${numCells}, ${cellsToRelease}")
    writer.write("Case #${i}: ${solve(numCells, cellsToRelease)}\n")
  }
  writer.flush()
  writer.close()
}

var sampleInput = {
  "2",
  "8 1",
  "3",
  "20 3",
  "3 6 14",
  ""
}.join("\n")


//solveAll(new StringReader(sampleInput), new OutputStreamWriter(System.out))
solveAll(new FileReader("C-small-practice.in"), new FileWriter("C-small-practice.out"))
solveAll(new FileReader("C-large-practice.in"), new FileWriter("C-large-practice.out"))
