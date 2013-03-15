classpath "../.."

// Solution for 2009 Round 1C Problem B "Center of Mass"
// http://code.google.com/codejam/contest/189252/dashboard#s=p1

uses java.io.BufferedReader
uses java.io.BufferedWriter
uses java.io.Reader
uses java.io.OutputStreamWriter
uses java.io.StringReader
uses java.io.StringWriter
uses java.io.Writer
uses java.lang.AssertionError
uses java.lang.Math
uses java.lang.String
uses java.math.BigDecimal
uses java.text.DecimalFormat
uses java.util.Collection

uses codejam.SolutionRunner

// ====================================================================
// Solution
// ====================================================================

class Fly {
  var _x : double as X
  var _y : double as Y
  var _z : double as Z
  var _dx : double as DeltaX
  var _dy : double as DeltaY
  var _dz : double as DeltaZ
  construct(s : String) {
    var v = s.split(" ").map(\ x -> x.toDouble())
    _x = v[0]
    _y = v[1]
    _z = v[2]
    _dx = v[3]
    _dy = v[4]
    _dz = v[5]
  }
}

function averageDistanceAt(t : double, flies : Fly[]) : double {
  var cx = flies.sum(\ fly : Fly -> fly.X + (t * fly.DeltaX))
  var cy = flies.sum(\ fly : Fly -> fly.Y + (t * fly.DeltaY))
  var cz = flies.sum(\ fly : Fly -> fly.Z + (t * fly.DeltaZ))
  return Math.sqrt((cx * cx) + (cy * cy) + (cz * cz)) / (flies.length as double)
}

function solve(flies : Fly[]) : String {
  var lo = 0.0
  var hi = (1 << 50) as double
  while (true) {
    var mid = (lo + hi) / 2.0
    if (hi - lo < 0.000000001) {
      var df = new DecimalFormat("0.00000000")
      var time = df.format(mid)
      var distance = df.format(averageDistanceAt(mid, flies))
      var result = "${distance} ${time}"
      return result
    }
    if (averageDistanceAt(lo, flies) <= averageDistanceAt(mid, flies)) {
      hi = (mid + hi) / 2.0
    } else if (averageDistanceAt(hi, flies) <= averageDistanceAt(mid, flies)) {
      lo = (mid + lo) / 2.0
    } else {
      lo = (mid + 2.0 * lo) / 3.0
      hi = (mid + 2.0 * hi) / 3.0
    }
  }
  throw new AssertionError("Shouldn't get to this line")
}

var runner = SolutionRunner.from(\ reader -> {
  var numFlies = reader.readLine().toInt()
  var flies = new Fly[numFlies]
  flies.eachWithIndex(\ _, i -> { flies[i] = new Fly(reader.readLine()) } )
  return solve(flies)
})

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
    "3",
    "3",
    "3 0 -4 0 0 3",
    "-3 -2 -1 3 0 0",
    "-3 -1 2 0 3 0",
    "3",
    "-5 0 0 1 0 0",
    "-7 0 0 1 0 0",
    "-6 3 0 1 0 0",
    "4",
    "1 2 3 1 2 3",
    "3 2 1 3 2 1",
    "1 0 0 0 0 -1",
    "0 10 0 0 -10 -1",
    ""
}.join("\n"))

runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "B")
