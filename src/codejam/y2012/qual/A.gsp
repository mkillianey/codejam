classpath "../.."

uses codejam.BaseSolver
uses java.io.*
uses java.lang.*
uses java.util.*


class Solver extends BaseSolver {

  var letterMap = {
      'a' -> "y",
      'o' -> "e",
      'z' -> "q"
  }

  construct() {
    var hints = {
        "ejp mysljylc kd kxveddknmc re jsicpdrysi" ->"our language is impossible to understand",
        "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd" ->"there are twenty six factorial possibilities",
        "de kr kd eoya kw aej tysr re ujdr lkgc jv" ->"so it is okay if you want to just give up"
    }
    for (entry in hints.entrySet()) {
      var encoded = entry.Key.toCharArray().toList()
      var decoded = entry.Value.toCharArray().toList()
      for (var ch in encoded index i) {
        letterMap.put(ch, decoded[i])
      }
    }
    var missingFromKeys : Character
    var missingFromValues : String
    for (var c in 'a'..'z') {
      var ch = c as Character
      if (!letterMap.Keys.contains(ch)) {
        missingFromKeys = ch as Character
      }
      if (!letterMap.Values.contains(ch as String)) {
        missingFromValues = ch as String
      }
    }
    letterMap.put(missingFromKeys, missingFromValues)
  }

  override function solveOneCase(reader : BufferedReader) : String {
    var chars = reader.readLine().toCharArray().toList()
    return chars.map( \ ch ->letterMap.containsKey(ch) ? letterMap.get(ch) : "${ch}" ).join("")
  }
  
}

var sampleInput = new StringReader({
    "3",
    "ejp mysljylc kd kxveddknmc re jsicpdrysi",
    "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd",
    "de kr kd eoya kw aej tysr re ujdr lkgc jv",
    ""}.join("\n"))

var solver = new Solver()

solver.tryOneCase({"Hello World"})

solver.solveAll( sampleInput )
solver.pollDirectory(".", :prefix = "A")


