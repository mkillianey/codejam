uses java.io.*
uses java.lang.*
uses java.util.*


var sampleInput = {
    "3",
    "ejp mysljylc kd kxveddknmc re jsicpdrysi",
    "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd",
    "de kr kd eoya kw aej tysr re ujdr lkgc jv",
    ""}.join("\n")


var letterMap = {
    'a' -> "y",
    'o' -> "e",
    'z' -> "q"
}

function populateLetterMap() {

  var hints = {
      "ejp mysljylc kd kxveddknmc re jsicpdrysi" -> "our language is impossible to understand",
      "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd" ->  "there are twenty six factorial possibilities",
      "de kr kd eoya kw aej tysr re ujdr lkgc jv" -> "so it is okay if you want to just give up"
  }
  for (entry in hints.entrySet()) {
    var encoded = entry.Key.toCharArray().toList()
    var decoded = entry.Value.toCharArray().toList()
    for (var ch in encoded index i) {
      letterMap.put(ch, decoded[i])
    }
  }

  {
    var missingFromKeys : Character
    var missingFromValues : String
    for (var c in 'a'..'z') {
      var ch = c as Character
      print("${ch} maps to ${letterMap[ch]}")
      if (!letterMap.Keys.contains(ch)) {
        missingFromKeys = ch as Character
      }
      if (!letterMap.Values.contains(ch as String)) {
        missingFromValues = ch as String
      }
    }
    print("It looks like we were missing a translation from ${missingFromKeys} to ${missingFromValues}")
    letterMap.put(missingFromKeys, missingFromValues)
  }
}

print("Map has ${letterMap.size()} entries")

function solve(code : String) : String {

  return code.toCharArray()
      .toList()
      .map( \ ch -> {
        if (letterMap.containsKey(ch)) {
          return letterMap.get(ch)
        } else {
          return "${ch}"
       }
      })
      .join("")
}

function solveAll(input : Reader, output : Writer) {
  populateLetterMap()
  var br = new BufferedReader(input)
  var bw = new BufferedWriter(output)
  var numCases = br.readLine().toInt()
  for (var i in 1..numCases) {
    bw.write("Case #${i}: ${solve(br.readLine().trim())}")
    bw.newLine()
  }
  bw.flush()
  bw.close()
}

//solveAll(new StringReader(sampleInput))
solveAll(new FileReader("A-small-attempt0.in"), new FileWriter("A-small-attempt0.out"))
//solveAll(new FileReader("A-large-practice.in"))
