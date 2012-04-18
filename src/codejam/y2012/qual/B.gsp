uses java.io.*
uses java.lang.*
uses java.util.*


var sampleInput = {
    "4",
    "3 1 5 15 13 11",
    "3 0 8 23 22 21",
    "2 1 1 8 0",
    "6 2 8 29 20 8 18 18 21",
    ""}.join("\n")




var bestToMinScoreWithoutSurprise = {
    0 -> 0, // 0,0,0
    1 -> 1, // 0,0,1
    2 -> 4, // 1,1,2
    3 -> 7, // 2,2,3
    4 -> 10, // 3,3,4
    5 -> 13,
    6 -> 16,
    7 -> 19,
    8 -> 22,
    9 -> 25,
    10 -> 28
}
var bestToMinScoreWithSurprise = {
    0 -> 0, // 0,0,0
    1 -> 1, // 0,0,1
    2 -> 2, // 0,0,2
    3 -> 5, // 1,1,3
    4 -> 8,  // 2,2,4
    5 -> 11, // 3,3,5
    6 -> 14, // 4,4,6
    7 -> 17, // 5,5,7
    8 -> 20, // 6,6,8
    9 -> 23, // 7,7,9
    10 -> 26 // 8,8,10
}

function solve(maxSurprises : int, best : int, scores : List<Integer>) : String {
  var minScoreWithoutSurprise = bestToMinScoreWithoutSurprise[best]
  var minScoreWithSurprise = bestToMinScoreWithSurprise[best]

  var beatWithoutSurprise = scores.countWhere( \ n -> n >= minScoreWithoutSurprise)
  var beatWithSurprise = scores.countWhere( \ n -> n < minScoreWithoutSurprise && n >= minScoreWithSurprise)
  return "${beatWithoutSurprise + Math.min(maxSurprises, beatWithSurprise)}"
}

function solveAll(input : Reader, output : Writer) {
  var br = new BufferedReader(input)
  var bw = new BufferedWriter(output)
  var numCases = br.readLine().toInt()
  for (var i in 1..numCases) {
    var values = br.readLine().split(" ").map( \ e -> e.toInt()).toList()
    var n = values[0]
    var s = values[1]
    var p = values[2]
    var scores = values.subList(3, values.size())
    if (scores.size() != n) {
      throw new AssertionError("Misunderstood the problem...expected ${n} scores, got ${scores.size()} : ${scores}!")
    }
    bw.write("Case #${i}: ${solve(s, p, scores)}")
    bw.newLine()
  }
  bw.flush()
  bw.close()
}

//solveAll(new StringReader(sampleInput), new OutputStreamWriter(System.out))
//solveAll(new FileReader("B-small-attempt0.in"), new FileWriter("B-small-attempt0.out"))
solveAll(new FileReader("B-large.in"), new FileWriter("B-large.out"))
