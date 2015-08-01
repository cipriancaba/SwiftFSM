# SwiftFSM

[![CI Status](http://img.shields.io/travis/cipriancaba/SwiftFSM.svg?style=flat)](https://travis-ci.org/cipriancaba/SwiftFSM)
[![Version](https://img.shields.io/cocoapods/v/SwiftFSM.svg?style=flat)](http://cocoapods.org/pods/SwiftFSM)
[![License](https://img.shields.io/cocoapods/l/SwiftFSM.svg?style=flat)](http://cocoapods.org/pods/SwiftFSM)
[![Platform](https://img.shields.io/cocoapods/p/SwiftFSM.svg?style=flat)](http://cocoapods.org/pods/SwiftFSM)

A solid yet simple fsm implementation in Swift

## Features

- [x] Type safety with Hashable enums
- [x] Simple configuration with `Enum` based States and Transitions
- [x] Type-safety for States and Transitions using Generics
- [x] Convenient state handling with closures for `onEnter` and `onExit`
- [ ] Delegate implementation for a more generic state handling
- [ ] Cocoapods and Carthage support

## Requirements

- iOS 8.0+ / Mac OS X 10.9+
- Swift
- Xcode 6.4

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

pod 'SwiftFSM'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

- [ ] Detailed instructions to be added once Carthage is supported

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate SwiftFSM into your project manually by simply copying [SwiftFSM.swift](https://github.com/cipriancaba/SwiftFSM/blob/master/Pod/Classes/SwiftFSM.swift) into your project

## Usage

### Classic turnstile example project
To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Defining a state
```swift
enum TurnstileState: String {
  case Locked = "Locked"
  case Unlocked = "Unlocked"
}
```

### Defining a transition
```swift
enum TurnstileTransition: String {
  case Push = "Push"
  case Coin = "Coin"
}
```

### Defining the actual fsm
This is the place where you need to define the `Hashable` `State` and `Transition` generics. This will help Xcode determine any compile time errors

You will need to specify the id of the fsm (in case you want to use multiple fsms and log their events)

This is the place where you can enable or disable fsm logging
```swift
let fsm = SwiftFSM<TurnstileState, TurnstileTransition>(id: "TurnstileFSM", willLog: false)
```

### Defining a state
Any state you define must be unique
You will receive a reference to the actual `SwiftFSMState` implementation when calling `fsm.addState`

This reference is needed for defining the transitions **from** that state and for mapping the state **handlers**
```swift
let locked = fsm.addState(.Locked)

// Define an inline onEnter handler
locked.onEnter = { (transition: TurnstileTransition) -> Void in
  // called when the locked state defined above is entered. You also receive the type of transition that generated the state change
}

let unlocked = fsm.addState(.Unlocked)

// Define handlers as reference
unlocked.onEnter = handleUnlocked
// Listen to onExit event
unlocked.onExit = handleUnlockedExit
```

### Defining a transition
You obviously need to define transitions between states and in SwiftFSM this comes really natural
```swift
locked.addTransition(.Push, to: .Locked)
locked.addTransition(.Coin, to: .Unlocked)

unlocked.addTransition(.Coin, to: .Unlocked)
unlocked.addTransition(.Push, to: .Locked)
```

### Starting the fsm
Once you are happy with the configuration of the fsm, you will need to start it

Please note that this will not trigger the initial onEnter callback
```swift
fsm.startFrom(.Locked)
```

### Check if a transition was successful
```swift
if let newState = fsm.transitionWith(.Coin) {
  // state change happened
} else {
  // transition was not valid
}
```

### Current state
You can access the current state of the fsm at any moment. This will return a `State`
```swift
fsm.currentState
```


## Author

Ciprian Caba, cipri@cipriancaba.com

## License

SwiftFSM is available under the MIT license. See the LICENSE file for more info.
