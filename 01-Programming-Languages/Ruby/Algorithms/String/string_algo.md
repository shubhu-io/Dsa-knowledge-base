# String Algorithms in Ruby

## Overview

Ruby's `String` class provides powerful built-in methods that make string manipulation elegant. Combined with blocks and method chaining, Ruby can implement string algorithms concisely. This file covers both idiomatic Ruby approaches and manual implementations.

## Algorithms

### Character Frequency Count

```ruby
# Time: O(n), Space: O(k) where k = unique characters
# Idiomatic Ruby using tally (Ruby 2.7+)
def char_frequency(str)
  str.downcase.gsub(' ', '').chars.tally.sort_by { |_, v| -v }.to_h
end

# Manual implementation
def char_frequency_manual(str)
  freq = Hash.new(0)
  str.downcase.chars.each do |char|
    next if char == ' '
    freq[char] += 1
  end
  freq.sort_by { |_, count| -count }.to_h
end
```

### Palindrome Check

```ruby
# Time: O(n), Space: O(n)
def palindrome?(str)
  clean = str.downcase.gsub(/[^a-z0-9]/, '')
  clean == clean.reverse
end

# Manual check (two-pointer)
def palindrome_manual?(str)
  clean = str.downcase.gsub(/[^a-z0-9]/, '')
  left = 0
  right = clean.length - 1
  while left < right
    return false if clean[left] != clean[right]
    left += 1
    right -= 1
  end
  true
end
```

### Run-Length Encoding

```ruby
# Time: O(n), Space: O(n)
def run_length_encode(str)
  return "" if str.empty?
  encoded = ""
  count = 1

  (1...str.length).each do |i|
    if str[i] == str[i - 1]
      count += 1
    else
      encoded += "#{str[i - 1]}#{count}"
      count = 1
    end
  end
  encoded += "#{str[-1]}#{count}"
  encoded
end

def run_length_decode(encoded)
  encoded.scan(/(.)(\d+)/).map { |char, count| char * count.to_i }.join
end
```

### Anagram Check

```ruby
# Time: O(n log n), Space: O(n)
def anagram?(str1, str2)
  clean = ->(s) { s.downcase.gsub(/[^a-z]/, '').chars.sort }
  clean.call(str1) == clean.call(str2)
end

# Idiomatic using tally
def anagram_idiomatic?(str1, str2)
  clean = ->(s) { s.downcase.gsub(/[^a-z]/, '').chars.tally }
  clean.call(str1) == clean.call(str2)
end
```

### Longest Common Prefix

```ruby
# Time: O(n * m), Space: O(m)
def longest_common_prefix(strings)
  return "" if strings.empty?
  prefix = strings[0]
  strings[1..].each do |str|
    prefix = prefix[0...str.length] while !str.start_with?(prefix) && !prefix.empty?
  end
  prefix
end
```

### Substring Search

```ruby
# Time: O(n*m), Space: O(1)
def find_all_occurrences(haystack, needle)
  positions = []
  offset = 0
  while (pos = haystack.index(needle, offset))
    positions << pos
    offset = pos + 1
  end
  positions
end
```

### Longest Palindromic Substring

```ruby
# Time: O(n^2), Space: O(1)
def longest_palindrome(str)
  return str if str.length < 2
  start_idx = 0
  max_len = 1

  expand = ->(left, right) {
    while left >= 0 && right < str.length && str[left] == str[right]
      left -= 1
      right += 1
    end
    [left + 1, right - left - 1]
  }

  str.length.times do |i|
    l1, len1 = expand.call(i, i)
    l2, len2 = expand.call(i, i + 1)
    if len1 > max_len
      start_idx, max_len = l1, len1
    end
    if len2 > max_len
      start_idx, max_len = l2, len2
    end
  end

  str[start_idx, max_len]
end
```

## Demo

```ruby
# Complete demo: String analysis
def analyze_string(str)
  clean = str.downcase.gsub(/[^a-z0-9]/, '')
  {
    length: str.length,
    word_count: str.split.length,
    char_frequency: str.downcase.gsub(' ', '').chars.tally.sort_by { |_, v| -v }.to_h,
    reversed: str.reverse,
    is_palindrome: clean == clean.reverse,
    contains_number: str.match?(/\d/),
    title_case: str.split.map(&:capitalize).join(' ')
  }
end

text = "Hello World from Ruby"
result = analyze_string(text)
result.each { |key, value| puts "#{key}: #{value}" }
```

## Ruby String Methods Reference

| Method | Purpose | Example |
|--------|---------|---------|
| `chars` | Split into characters | `"hello".chars` => `["h","e","l","l","o"]` |
| `tally` | Count occurrences | `"aab".chars.tally` => `{"a"=>2, "b"=>1}` |
| `reverse` | Reverse string | `"hello".reverse` => `"olleh"` |
| `gsub` | Global substitution | `"hello".gsub("l", "r")` => `"herro"` |
| `scan` | Pattern matching | `"a1b2".scan(/\d/)` => `["1","2"]` |
| `split` | Split to array | `"a,b,c".split(",")` => `["a","b","c"]` |
| `start_with?` | Check prefix | `"hello".start_with?("hel")` => `true` |
| `end_with?` | Check suffix | `"hello".end_with?("llo")` => `true` |
| `include?` | Check substring | `"hello".include?("ell")` => `true` |
| `index` | Find first occurrence | `"hello".index("ll")` => `2` |
| `tr` | Translate characters | `"hello".tr("aeiou", "12345")` => `"h2ll4"` |
| `squeeze` | Remove consecutive duplicates | `"aabbcc".squeeze` => `"abc"` |

## See Also

- [[Ruby/Algorithms/String/string_algorithms|String Algorithms (code)]]
- [[Ruby/Basics/syntax|Ruby Syntax]]
- [[Ruby/OOP/oop|Ruby OOP]]
