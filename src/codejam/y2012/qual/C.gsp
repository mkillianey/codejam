uses java.io.*
uses java.lang.*
uses java.util.*




function solve(first : int, last : int) : String {
  var numDigitsToRotate = Math.log10(last) as int
  var powerOfTen = Math.pow(10, numDigitsToRotate) as int
  var pairsFound = 0
  var rotations = new int[numDigitsToRotate]
  var i = first
  while (i < last) {
    var j = i
    var shift = 0
    while (shift < numDigitsToRotate) {
      var shifted = (j / 10)
      var lastDigit = j - (shifted * 10)
      j = lastDigit * powerOfTen + shifted
      rotations[shift] = j
      if ((first <= i) && (i < j) && (j <= last)) {
        // found a match...make sure it isn't a duplicate
        var previousShift = 0
        var duplicate = false
        while (previousShift < shift) {
          if (j == rotations[previousShift]) {
            duplicate = true
            break
          }
          previousShift++
        }
        if (!duplicate) {
          pairsFound++
        }
      }
      shift++
    }
    i++
  }
  return "${pairsFound}"
}

function solveAll(input : Reader, output : Writer) {
  var br = new BufferedReader(input)
  var bw = new BufferedWriter(output)
  var numCases = br.readLine().toInt()
  for (var i in 1..numCases) {
    var values = br.readLine().split(" ").map( \ e -> e.toInt())
    bw.write("Case #${i}: ${solve(values[0], values[1])}")
    bw.newLine()
    bw.flush()
  }
  bw.flush()
  bw.close()
}


var sampleInput = {
    "4",
    "1 9",
    "10 40",
    "100 500",
    "1111 2222",
    ""
  }.join("\n")

//for (i in 1..100) {
//  var rotate = Math.log10(i) as int
//  print("${i}: ${rotate} ${Math.pow(10,rotate) as int}")
//}

//solveAll(new StringReader(sampleInput), new OutputStreamWriter(System.out))
solveAll(new FileReader("C-small-attempt0.in"), new FileWriter("C-small-attempt0.out"))
// solveAll(new FileReader("C-large.in"), new FileWriter("C-large.out"))
