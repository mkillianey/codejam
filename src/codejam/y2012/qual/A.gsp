classpath "../../.."

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Character
uses java.lang.Character

// http://code.google.com/codejam/contest/1460488/dashboard#s=p0
// Google Code Jam 2012 Qualification Round Problem A: Speaking in Tongues

var letterMap = {
    'a' -> 'y',
    'o' -> 'e',
    'z' -> 'q'
}

{
  // populate letterMap
  var hints = {
      "ejp mysljylc kd kxveddknmc re jsicpdrysi" -> "our language is impossible to understand",
      "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd" -> "there are twenty six factorial possibilities",
      "de kr kd eoya kw aej tysr re ujdr lkgc jv" -> "so it is okay if you want to just give up"
  }
  for (entry in hints.entrySet()) {
    var encoded = entry.Key.toCharArray()
    var decoded = entry.Value.toCharArray()
    encoded.toList().eachWithIndex( \ ch, i -> letterMap.put(ch, decoded[i]))
  }
  var missingFromKeys = ('a'..'z').map( \ ch -> ch as Character).toSet().disjunction(letterMap.Keys).first()
  var missingFromValues = ('a'..'z').map( \ ch -> ch as Character).toSet().disjunction(letterMap.Values).first()
  letterMap.put(missingFromKeys, missingFromValues)
}

var sampleInput = new StringReader({
    "4",
    "ejp mysljylc kd kxveddknmc re jsicpdrysi",
    "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd",
    "de kr kd eoya kw aej tysr re ujdr lkgc jv",
    "zjkq dbet",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ reader -> {
  var chars = reader.readLine().toCharArray().toList()
  return chars.map( \ ch ->letterMap.containsKey(ch) ? letterMap.get(ch) : ch ).join("")
})

runner.solveOneCase({"Hello World"})
runner.solveAll( sampleInput )
runner.pollDirectory(".", :prefix = "A")


