// Solution for 2009 Round 1C Problem A "All Your Base"
// http://code.google.com/codejam/contest/189252/dashboard#s=p0

uses java.io.*
uses java.lang.*
uses java.util.*

var sampleInput = {
    "3",
    "11001001",
    "cats",
    "zig",
    ""
}.join("\n")


function solve(symbol : String) : String {
  var chars = symbol.toCharArray()
  var uniqueChars = new LinkedHashSet<Character>(chars.toList())
  var base = Math.max(uniqueChars.size(), 2) // base must be at least 2
  var assignOrder = {1, 0}  // leftmost character can't be 0
  assignOrder.addAll((2..|base).toList())
  var charToValue : Map<Character, Integer> = {}
  for (ch in uniqueChars index i) {
    charToValue[ch] = assignOrder[i]
  }
  var result : long = 0
  for (ch in chars) {
    result = result*base + charToValue.get(ch)
  }
  return result as String
}

function solveAll(input : Reader, output : Writer) {
  var reader = new BufferedReader(input)
  var writer = new BufferedWriter(output)
  for (i in 1..reader.readLine().toInt()) {
    writer.write("Case #${i}: ${solve(reader.readLine())}")
    writer.newLine()
  }
  writer.flush()
  writer.close()
}

//solveAll(new StringReader(sampleInput), new OutputStreamWriter(System.out))
solveAll(new FileReader("A-small-practice.in"), new FileWriter("A-small-practice.out"))
solveAll(new FileReader("A-large-practice.in"), new FileWriter("A-large-practice.out"))
