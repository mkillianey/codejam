classpath "../../.."

// Solution for 2009 Round 1C Problem A "All Your Base"
// http://code.google.com/codejam/contest/189252/dashboard#s=p0

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Character
uses java.lang.Integer
uses java.lang.Math
uses java.util.LinkedHashSet
uses java.util.Map

var sampleInput = new StringReader({
    "3",
    "11001001",
    "cats",
    "zig",
    ""
}.join("\n"))


function solve(symbol : String) : String {
  var chars = symbol.toCharArray()
  var uniqueChars = new LinkedHashSet<Character>(chars.toList()).toList()
  var base = Math.max(uniqueChars.size(), 2) // base must be at least 2
  var charToValue : Map<Character, Integer> = {}
  for (ch in uniqueChars index i) {
    charToValue[ch] = i
  }
  // can't start with 0, so first character is 1, second character is 0
  charToValue[uniqueChars[0]] = 1
  if (uniqueChars.size() > 1) {
    charToValue[uniqueChars[1]] = 0 //
  }
  var result : long = 0
  for (ch in chars) {
    result = result*base + charToValue.get(ch)
  }
  return result as String
}

var runner = SolutionRunner.from( \ reader -> {
  var symbol = reader.readLine().trim()
  return solve(symbol)
})

runner.solveAll(sampleInput)
runner.pollDirectory(:prefix = "A")
