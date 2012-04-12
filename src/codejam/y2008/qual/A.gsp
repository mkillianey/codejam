uses java.io.*
uses java.lang.*
uses java.util.*


var sampleInput = {
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
""}.join("\n")



function solve(engines : List<String>, queries : List<String>) : String {
  var switchesPerEngine = new HashMap<String, Integer>()
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

function solveAll(input : Reader) {
  var br = new BufferedReader(input)
  var numCases = br.readLine().toInt()
  for (var index in 1..numCases) {
    var numEngines = br.readLine().toInt()
    var engines : List<String> = {}
    for (var _ in 0..|numEngines) {
      engines.add(br.readLine().trim())
    }
    var numQueries = br.readLine().toInt()
    var queries : List<String>  = {}
    for (var _ in 0..|numQueries) {
      queries.add(br.readLine().trim())
    }

    print ("Case #${index}: ${solve(engines, queries)}")
  }
}

solveAll(new StringReader(sampleInput))
//solveAll(new FileReader("A-small-practice.in"))
//solveAll(new FileReader("A-large-practice.in"))
