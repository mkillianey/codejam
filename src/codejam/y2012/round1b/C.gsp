classpath "../../.."

// Source for support files located at: https://github.com/mkillianey/codejam

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Long
uses java.util.HashSet
uses java.util.List
uses java.util.Set

// Solution to Google Codejam 2012 Round 1B Problem C.

function findDuplicateSum(sumSoFar : long, startIndex : int, values : List<Long>, sumsSeen : Set<Long>, limit : long) : List<Long> {
  if (startIndex >= values.size()) {
    return null
  }
  var value = values.get(startIndex)
  var sumWithIndex : Long = sumSoFar + value
  if (sumWithIndex > limit) {
    return null // We're getting too large
  }
  if (sumsSeen.add(sumWithIndex)) {
    // print("Adding ${value} to get ${sumWithIndex}")
  } else {
    // print("Went to add ${sumWithIndex}, but it was already there")
    return { value }
  }
  var withoutValue = findDuplicateSum(sumSoFar, startIndex+1, values, sumsSeen, limit)
  if (withoutValue != null) {
    return withoutValue
  }
  var withValue = findDuplicateSum(sumWithIndex, startIndex+1, values, sumsSeen, limit)
  if (withValue != null) {
    withValue.add(value)
    return withValue
  }
  return null
}

function solve(reader : BufferedReader) : String {
  var problem = reader.readLine()
  var values = problem.split(" ").map(\ item -> item.toLong()).toList()
  values.remove(0) // first item is the length
  values.sort()
  var limit = values.sum() / 2
  var valuesUsed = findDuplicateSum(0, 0, values, new HashSet<Long>(), limit)
  if (valuesUsed == null) {
    return "\nImpossible"
  }
  var seedForRerun : Set<Long> = new HashSet<Long>()
  seedForRerun.add(valuesUsed.sum())
  var otherValuesUsed = findDuplicateSum(0, 0, values, seedForRerun, limit)
  return "\n" + valuesUsed.join(" ") + "\n" + otherValuesUsed.join(" ")
}

var sampleInput = new StringReader({
    "2",
    "20 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20",
    "20 120 266 858 1243 1657 1771 2328 2490 2665 2894 3117 4210 4454 4943 5690 6170 7048 7125 9512 9600",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ x -> solve(x))

//for (i in 0..10) {
//  var r = new Random()
//  var numbers = (1..20).map( \ elt -> 1 + r.nextInt(Integer.MAX_VALUE - 10))
//  runner.solveOneCase({"${numbers.size()} " + numbers.join(" ")})
//}
//var powersOfTwo = (1..20).map( \ elt -> 1L << elt)
//runner.solveOneCase({"${powersOfTwo.size()} " + powersOfTwo.join(" ")})

runner.solveAll( sampleInput )
runner.pollDirectory(".", :prefix = "C")


