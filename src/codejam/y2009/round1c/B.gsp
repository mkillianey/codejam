// Solution for 2009 Round 1C Problem B "Center of Mass"
// http://code.google.com/codejam/contest/189252/dashboard#s=p1

uses java.io.*
uses java.lang.*
uses java.math.BigDecimal
uses java.text.DecimalFormat
uses java.util.*


class Fly {
  var x : double
  var y : double
  var z : double
  var dx : double
  var dy : double
  var dz : double
  construct (s : String) {
    var values = s.split(" ").map( \ elt ->elt.toDouble())
    x = values[0]
    y = values[1]
    z = values[2]
    dx = values[3]
    dy = values[4]
    dz = values[5]
  }
}

function averageDistanceAt(t : double, flies : List<Fly>) : double {
  var cx = flies.sum( \ fly -> (fly.x + (t * fly.dx)) )
  var cy = flies.sum( \ fly -> (fly.y + (t * fly.dy)) )
  var cz = flies.sum( \ fly -> (fly.z + (t * fly.dz)) )
  return Math.sqrt((cx * cx) + (cy * cy) + (cz * cz))
      / (flies.size() as double)
}

function solve(final flies : List<Fly>) : String {
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

function solveAll(input : Reader, output : Writer) {
  var reader = new BufferedReader(input)
  var writer = new BufferedWriter(output)
  for (i in 1..reader.readLine().toInt()) {
    var numFlies = reader.readLine().toInt()
    var flies = (0..|numFlies).map( \ _ -> new Fly(reader.readLine()))
    print("Solve case #${i} for ${flies.size()} flies")
    writer.write("Case #${i}: ${solve(flies)}\n")
  }
  writer.flush()
  writer.close()
}

var sampleInput = {
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
}.join("\n")


//solveAll(new StringReader(sampleInput), new OutputStreamWriter(System.out))
//solveAll(new FileReader("B-small-practice.in"), new FileWriter("B-small-practice.out"))
solveAll(new FileReader("B-large-practice.in"), new FileWriter("B-large-practice.out"))
