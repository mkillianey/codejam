classpath "../.."

uses codejam.SolutionRunner
uses java.io.StringReader
uses java.lang.Math

// http://code.google.com/codejam/contest/1460488/dashboard#s=p2
// Google Code Jam 2012 Qualification Round Problem C. Recycled Numbers

// ====================================================================
// Solution
// ====================================================================

function solve(first : int, last : int) : String {
  var numberLength = "${first}".length()
  var powerOfTen = Math.pow(10, numberLength - 1) as int
  var pairsFound = 0
  var i = first
  while (i < last) {
    var j = i
    while (true) {
      var shifted : int = (j / 10)
      var lastDigit : int = j - (shifted * 10)
      j = lastDigit * powerOfTen + shifted
      if (i == j) {
        break
      }
      if ((first <= i) && (i < j) && (j <= last)) {
        // found a match...make sure it isn't a duplicate
        pairsFound++
      }
    }
    i++
  }
  return pairsFound as String
}

var runner = SolutionRunner.from( \ reader -> {
  var line = reader.readLine().split(" ")
  var first = line[0].toInt()
  var last = line[1].toInt()
  return solve(first, last)
})

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
    "4",
    "1 9",
    "10 40",
    "100 500",
    "1111 2222",
    ""
  }.join("\n"))


runner.solveOneCase({"1000000 2000000"})
runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(".", :prefix = "C")
