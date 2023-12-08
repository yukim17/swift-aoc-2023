# Advent of Code Swift Starter Project

[![Language](https://img.shields.io/badge/language-Swift-red.svg)](https://swift.org)

Daily programming puzzles at [Advent of Code](<https://adventofcode.com/>), by
[Eric Wastl](<http://was.tl/>).

## Usage

You can open this project by choosing File / Open and
select the parent directory. 

## Challenges

The challenges assume three files (replace 00 with the day of the challenge).

- `Sources/Data/Day00.txt`: the input data provided for the challenge
- `Sources/Day00.swift`: the code to solve the challenge
- `Tests/Day00.swift`: any unit tests that you want to include

To start a new day's challenge, make a copy of these files, updating 00 to the 
day number.

```diff
// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
-  Day00()
+  Day00(),
+  Day01(),
]
```

Then implement part 1 and 2. The `AdventOfCode.swift` file controls which challenge
is run with `swift run`. Add your new type to its `allChallenges` array. By default 
it runs the most recent challenge.

The `AdventOfCode.swift` file controls which day's challenge is run
with `swift run`. By default that runs the most recent challenge in the package.

## Templates

You can use file template for each new challenge. Copy given template into the 
folder `~/Library/Developer/Xcode/Templates` and you can find it in menu `File -> New File -> Advent Of Code File`.
