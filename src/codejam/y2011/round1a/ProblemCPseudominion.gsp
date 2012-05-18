// Solution for "Round 1A 2011 Problem C: Pseudominion":
// Solution for http://code.google.com/codejam/contest/1145485/dashboard#s=p2

uses java.io.BufferedInputStream
uses java.io.BufferedReader
uses java.io.FileReader
uses java.io.FileWriter
uses java.io.InputStreamReader
uses java.io.OutputStreamWriter
uses java.io.Reader
uses java.io.StringReader
uses java.io.Writer
uses java.lang.Integer
uses java.lang.Math
uses java.lang.System
uses java.util.ArrayList
uses java.util.Collections
uses java.util.Comparator
uses java.util.List
uses java.util.HashMap


class Card {
  var _c : int as DrawCards
  var _s : int as IncreaseScore
  var _t : int as MoreTurns
  construct (s : String) {
    var items = s.split(" ")
    _c = Integer.parseInt(items[0])
    _s = Integer.parseInt(items[1])
    _t = Integer.parseInt(items[2])
  }
  override function equals(other : Object) : boolean {
    return other typeis Card
        && _c == other._c
        && _s == other._s
        && _t == other._t
  }
  override function hashCode() : int {
    return _c + _s + _t
  }
}

class GameState {
  var _score : int as Score
  var _turns : int as Turns
  var _hand : List<Card> as Hand
  var _deck : List<Card> as Deck
  construct(score : int, turns : int, hand : List<Card>, deck : List<Card>) {
    _score = score
    _turns = turns
    _hand = hand
    Collections.sort(hand, new Comparator<Card>() {
      override function compare(c1 : Card, c2 : Card) : int {
        if (c1._t != c2._t) { return c2._t - c1._t } // more turns is earlier
        if (c1._c != c2._c) { return c2._c - c1._c } // more cards is earlier
        if (c1._s != c2._s) { return c2._s - c1._s } // higher score is earlier
        return 0
      }})
    _deck = deck
  }
  function play(card : Card) : GameState {
    var newHand = new ArrayList<Card>(Hand)
    newHand.remove(card)
    var newDeck = Deck
    if (card.DrawCards > 0 && !Deck.Empty) {
      var numCardsToDraw = Math.min(card.DrawCards, Deck.size())
      newHand.addAll(Deck.subList(0, numCardsToDraw))
      newDeck = Deck.subList(numCardsToDraw, Deck.size())
    }
    return new GameState(Score + card.IncreaseScore, Turns - 1 + card.MoreTurns, newHand, newDeck)
  }
  override function hashCode() : int {
    return _score + _turns + _hand.hashCode() + _deck.hashCode()
  }
  override function equals(other : Object) : boolean {
    if (other typeis GameState) {
      return _score == other._score
          && _turns == other._turns
          && _hand.equals(other._hand)
          && _deck.size() == other._deck.size()
    }
    return false
  }
}

class Solver {
  function solve(state : GameState) : Integer {
    if (state.Turns == 0 || state.Hand.Empty) {
      return state.Score
    }
    for (var card in state.Hand) {
      if (card.MoreTurns > 0) {
        return solve(state.play(card)) // can always play cards that give more turns
      }
    }
    var highScore = state.Score
    var exploredCards : List<Card> = {}
    for (var card in state.Hand) {
      if (exploredCards.hasMatch( \ exploredCard ->
          exploredCard.IncreaseScore >= card.IncreaseScore && exploredCard.DrawCards >= card.DrawCards)) {
        continue
      }
      var attempt = solve(state.play(card))
      highScore = Math.max(highScore, attempt)
      exploredCards.add(card)
    }
    return highScore
  }
}

class MemoizedSolver extends Solver {
  var _cache = new HashMap<GameState, Integer>()
  override function solve(state : GameState) : Integer {
    if (state.Turns == 0 || state.Hand.Empty) {
      return state.Score  // avoid filling up the cache with trivial computations
    }
    var solution = _cache.get(state)
    if (solution != null) {
      return solution
    }
    solution = super.solve(state)
    _cache.put(state, solution)
    return solution
  }
}

function solve(reader : Reader, writer : Writer) {
  var br = new BufferedReader(reader)
  for (var index in 1..Integer.parseInt(br.readLine())) {
    var hand : List<Card> = {}
    for (var _ in 0..|Integer.parseInt(br.readLine())) {
      hand.add(new Card(br.readLine()))
    }
    var deck: List<Card> = {}
    for (var _ in 0..|Integer.parseInt(br.readLine())) {
      deck.add(new Card(br.readLine()))
    }
    var initialState = new GameState(0, 1, hand, deck)
    writer.write("Case #${index}: ${new MemoizedSolver().solve(initialState)}\n")
  }
  writer.flush()
}

var sampleInput1 = { "2",
    "4", "1 0 0", "1 1 1", "0 5 0", "1 2 0",
    "0",
    "2", "1 1 1", "0 6 0",
    "1", "0 1 3",
    ""
}.join("\n")

var sampleInput2 = { "1",
    "3", "0 0 2", "0 5 0", "2 1 1",
    "3", "1 1 0", "0 1 1", "2 2 0",
    ""
}.join("\n")


//solve(new BufferedReader(new InputStreamReader(System.in)), new OutputStreamWriter(System.out))
solve(new StringReader(sampleInput1), new OutputStreamWriter(System.out))
solve(new StringReader(sampleInput2), new OutputStreamWriter(System.out))
//solve(new FileReader("C-small-practice.in"), new FileWriter("C-small-practice.out"))
//solve(new FileReader("C-large-practice.in"), new FileWriter("C-large-practice.out"))
