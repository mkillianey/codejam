classpath "../.."

// Solution for Google code jam 2008 Qualification Round Problem A: Saving the Universe
// http://code.google.com/codejam/contest/32013/dashboard#s=p0

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Integer

// ====================================================================
// Solution
// ====================================================================

function solve(engines : List<String>, queries : List<String>) : String {
  var switchesPerEngine = { "example" -> 0 }
  for (var engine in engines) {
    switchesPerEngine.put(engine, 0);
  }
  while (!queries.Empty) {
    var lastQuery = queries.remove(queries.size() - 1)
    var best = switchesPerEngine.entrySet()
        .where( \ entry -> !entry.Key.equals(lastQuery))
        .min( \ e -> e.Value )
    switchesPerEngine.put(lastQuery, best + 1)
  }
  return "${switchesPerEngine.Values.min()}"
}

var runner = SolutionRunner.from( \ reader -> {
    var numEngines = reader.readLine().toInt()
    var engines : List<String> = {}
    for (var _ in 0..|numEngines) {
      engines.add(reader.readLine().trim())
    }
    var numQueries = reader.readLine().toInt()
    var queries : List<String>  = {}
    for (var _ in 0..|numQueries) {
      queries.add(reader.readLine().trim())
    }
    return solve(engines, queries)
  })

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
"2",
"5",
"Yeehaw",
"NSM",
"Dont Ask",
"B9",
"Googol",
"10",
"Yeehaw",
"Yeehaw",
"Googol",
"B9",
"Googol",
"NSM",
"B9",
"NSM",
"Dont Ask",
"Googol",
"5",
"Yeehaw",
"NSM",
"Dont Ask",
"B9",
"Googol",
"7",
"Googol",
"Dont Ask",
"NSM",
"NSM",
"Yeehaw",
"Yeehaw",
"Googol",
""}.join("\n"))

runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "A")
