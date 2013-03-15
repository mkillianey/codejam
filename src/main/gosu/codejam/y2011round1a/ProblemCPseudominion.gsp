classpath "../.."

// Solution for "Round 1A 2011 Problem C: Pseudominion":
// Solution for http://code.google.com/codejam/contest/1145485/dashboard#s=p2

uses codejam.SolutionRunner
uses codejam.y2011round1a.Solver

uses java.io.StringReader

// ====================================================================
// Solution
// ====================================================================

var runner = SolutionRunner.from(\ reader -> {
    var hand = (0 ..| reader.readLine().toInt()).map(\ _ -> new Solver.Card(reader.readLine()))
    var deck = (0 ..| reader.readLine().toInt()).map(\ _ -> new Solver.Card(reader.readLine()))
    var initialState = new Solver.GameState(0, 1, hand, deck)
    var solution = new Solver().solve(initialState)
    return solution as String
})

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
    "3",
    "4",
    "1 0 0",
    "1 1 1",
    "0 5 0",
    "1 2 0",
    "0",
    "2",
    "1 1 1",
    "0 6 0",
    "1",
    "0 1 3",
    "3",
    "0 0 2",
    "0 5 0",
    "2 1 1",
    "3",
    "1 1 0",
    "0 1 1",
    "2 2 0",
    ""}.join("\n"))

runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "C")
