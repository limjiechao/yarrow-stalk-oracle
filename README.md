# Yarrow Stalk Oracle in Swift Playground

This is a Swift playground implementation of the yarrow stalk oracle using the `arc4random_uniform` random number generator. 

It was originally written in Swift 3 and has been updated to Swift 4.

## How to set up

It is assumed you are on a macOS device capable of installing and running Xcode 9 and above.

Create a folder named `Shared Playground Data` in `~/Documents`.

## How to Use

Launch `hexagram_structs.playground` in Xcode 9.

```Swift
//: # Consultation
let 問題: String = ""
// Enter your question within the quotation marks, ending it with a "?".
```

1. Scroll to the bottom of the playground. You will find the lines shown above.
2. Enter your query between the quotes in the statement  `let 問題: String = ""`.
3. To activate the oracle, end your query with a "?".
4. The result will be printed in the console and saved to `~/Documents/Shared Playground Data/` as a markdown file as shown below.

```
	# Should I do this?

	2018-01-27, 19:53:11

	```
	上爻：　　八　——   ——         ——   ——
	五爻：　　九　———o———    >    ——   ——
	四爻：　　七　———————         ———————
	三爻：　　八　——   ——         ——   ——
	二爻：　　八　——   ——         ——   ——
	初爻：　　九　———o———    >    ——   ——
	```

	【17、隨】之【16、豫】。
```
