classpath "../../.."

// Source for support files located at: https://github.com/mkillianey/codejam

uses codejam.SolutionRunner
uses codejam.Solver
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Integer
uses java.lang.RuntimeException
uses java.util.HashMap
uses java.util.HashSet
uses java.util.List
uses java.util.Map
uses java.util.Set

// Solution to Google Codejam 2012 Round 1C Problem A. Diamond Inheritance
// http://code.google.com/codejam/contest/1781488/dashboard#s=p0

class DiamondException extends RuntimeException {
}

function calcTransitiveSuperClassesOf(i : Integer,
                                      immediate : Map<Integer, Set<Integer>>,
                                      transitive : Map<Integer, Set<Integer>>) : Set<Integer> {
  var subClasses = transitive.get(i)
  if (subClasses == null) {
    subClasses = immediate.get(i).copy()
    for (j in immediate.get(i)) {
      for (k in calcTransitiveSuperClassesOf(j, immediate, transitive)) {
        if (!subClasses.add(k)) {
          throw new DiamondException() // already inherited
        }
      }
    }
    for (j in subClasses) {
      subClasses.add(j)
    }
    transitive.put(i, subClasses)
  }
  return subClasses
}

function solve(immediateSuperClasses : Map<Integer, Set<Integer>>) : String {
  try {
    var transitive : Map<Integer, Set<Integer>> = {}
    for (i in 1..immediateSuperClasses.size()) {
      calcTransitiveSuperClassesOf(i, immediateSuperClasses, transitive)
    }
  } catch (d : DiamondException) {
    return "Yes"
  }
  return "No"
}


var sampleInput = new StringReader({
    "3",
    "3",
    "1 2",
    "1 3",
    "0",
    "5",
    "2 2 3",
    "1 4",
    "1 5",
    "1 5",
    "0",
    "3",
    "2 2 3",
    "1 3",
    "0",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ reader : BufferedReader -> {
  var numClasses = reader.readLine().toInt()
  var immediateSubClasses : Map<Integer, Set<Integer>> = new HashMap<Integer, Set<Integer>>()
  for (i in 1..numClasses) {
    var line = reader.readLine().split(" ").map( \ elt -> elt.toInt()).toList()
    line.remove(0)
    immediateSubClasses.put(i, line.toSet())
  }
  return solve(immediateSubClasses)
})

runner.solveOneCase({"3", "1 2", "1 3", "0"})
runner.solveAll( sampleInput )
runner.pollDirectory(".", :prefix = "A")

