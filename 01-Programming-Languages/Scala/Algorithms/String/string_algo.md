# String Algorithms in Scala

## Overview

Scala provides rich string manipulation through `String` (Java's String), `StringOps`, and pattern matching. The functional style with higher-order methods and for-comprehensions makes string algorithms elegant and concise.

## Algorithms

### Character Frequency Count

```scala
// Time: O(n), Space: O(k) where k = unique characters
def charFrequency(str: String): Map[Char, Int] =
  str.toLowerCase
    .filter(_ != ' ')
    .groupBy(identity)
    .view
    .mapValues(_.length)
    .toMap
```

### Palindrome Check

```scala
// Time: O(n), Space: O(n)
def isPalindrome(str: String): Boolean = {
  val clean = str.toLowerCase.filter(_.isLetterOrDigit)
  clean == clean.reverse
}

// Manual two-pointer
def isPalindromeManual(str: String): Boolean = {
  val clean = str.toLowerCase.filter(_.isLetterOrDigit)
  @annotation.tailrec
  def check(left: Int, right: Int): Boolean =
    if (left >= right) true
    else if (clean(left) != clean(right)) false
    else check(left + 1, right - 1)
  check(0, clean.length - 1)
}
```

### Run-Length Encoding

```scala
// Time: O(n), Space: O(n)
def runLengthEncode(str: String): String = {
  if (str.isEmpty) return ""
  str.foldLeft(List.empty[(Char, Int)]) { (acc, c) =>
    acc match {
      case (prev, count) :: tail if prev == c => (prev, count + 1) :: tail
      case _ => (c, 1) :: acc
    }
  }.reverse.map { case (c, n) => s"$c$n" }.mkString
}

def runLengthDecode(encoded: String): String =
  """([a-zA-Z])(\d+)""".r.findAllMatchIn(encoded)
    .map(m => m.group(1) * m.group(2).toInt)
    .mkString
```

### Anagram Check

```scala
// Time: O(n log n), Space: O(n)
def isAnagram(s1: String, s2: String): Boolean = {
  val clean = (s: String) => s.toLowerCase.filter(_.isLetter).sorted
  clean(s1) == clean(s2)
}

// Idiomatic using groupBy
def isAnagramIdiomatic(s1: String, s2: String): Boolean = {
  val count = (s: String) =>
    s.toLowerCase.filter(_.isLetter).groupBy(identity).view.mapValues(_.length)
  count(s1) == count(s2)
}
```

### Longest Common Prefix

```scala
// Time: O(n * m), Space: O(m)
def longestCommonPrefix(strings: Array[String]): String =
  strings.reduce { (prefix, str) =>
    prefix.zip(str).takeWhile { case (a, b) => a == b }.map(_._1).mkString
  }
```

### Substring Search

```scala
// Time: O(n*m), Space: O(1)
def findAllOccurrences(haystack: String, needle: String): List[Int] = {
  @annotation.tailrec
  def search(offset: Int, acc: List[Int]): List[Int] = {
    val idx = haystack.indexOf(needle, offset)
    if (idx == -1) acc.reverse
    else search(idx + 1, idx :: acc)
  }
  search(0, Nil)
}
```

### Longest Palindromic Substring

```scala
// Time: O(n^2), Space: O(1)
def longestPalindrome(str: String): String = {
  if (str.length < 2) return str
  var start = 0
  var maxLen = 1

  def expand(left: Int, right: Int): (Int, Int) = {
    @annotation.tailrec
    def loop(l: Int, r: Int): (Int, Int) =
      if (l >= 0 && r < str.length && str(l) == str(r)) loop(l - 1, r + 1)
      else (l + 1, r - l - 1)
    loop(left, right)
  }

  str.indices.foreach { i =>
    val (l1, len1) = expand(i, i)
    val (l2, len2) = expand(i, i + 1)
    if (len1 > maxLen) { start = l1; maxLen = len1 }
    if (len2 > maxLen) { start = l2; maxLen = len2 }
  }

  str.substring(start, start + maxLen)
}
```

### Pattern Matching Tokenizer

```scala
// Time: O(n), Space: O(n)
sealed trait Token
case class Word(text: String) extends Token
case class Number(value: Double) extends Token
case object Space extends Token
case class Punctuation(char: Char) extends Token

def tokenize(str: String): List[Token] = {
  def parse(remaining: String): List[Token] = remaining match {
    case "" => Nil
    case s if s.startsWith(" ") => Space :: parse(s.tail)
    case s if s.head.isDigit =>
      val num = s.takeWhile(c => c.isDigit || c == '.')
      Number(num.toDouble) :: parse(remaining.drop(num.length))
    case s if s.head.isLetter =>
      val word = s.takeWhile(_.isLetter)
      Word(word) :: parse(remaining.drop(word.length))
    case c :: _ => Punctuation(c) :: parse(remaining.tail)
  }
  parse(str)
}
```

## Demo

```scala
object StringAnalyzer {
  def analyze(str: String): Map[String, Any] = Map(
    "length" -> str.length,
    "wordCount" -> str.split("\\s+").length,
    "charFrequency" -> str.toLowerCase.filter(_ != ' ')
      .groupBy(identity).view.mapValues(_.length).toMap,
    "reversed" -> str.reverse,
    "isPalindrome" -> str.toLowerCase.filter(_.isLetterOrDigit) ==
                      str.toLowerCase.filter(_.isLetterOrDigit).reverse,
    "containsNumber" -> str.exists(_.isDigit),
    "titleCase" -> str.split("\\s+").map(_.capitalize).mkString(" ")
  )

  def main(args: Array[String]): Unit = {
    val text = "Hello World from Scala"
    analyze(text).foreach { case (key, value) => println(s"$key: $value") }
  }
}
```

## See Also

- [[Scala/Algorithms/String/string_algorithms|String Algorithms (code)]]
- [[Scala/Basics/syntax|Scala Syntax]]
- [[Scala/OOP/oop|Scala OOP]]
