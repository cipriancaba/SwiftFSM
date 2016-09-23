//
//  TurnstileState.swift
//  SwiftFSM
//
//  Created by Ciprian Caba on 01/08/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

enum TurnstileState: String {
  case Locked = "Locked"
  case Unlocked = "Unlocked"
}

extension TurnstileState: CustomStringConvertible {
  var description: String {
    get {
      switch self {
      case .Locked:
        return "Locked"
      case .Unlocked:
        return "Unlocked"
      }
    }
  }
}
