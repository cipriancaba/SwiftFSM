//
//  TurnstileTransition.swift
//  SwiftFSM
//
//  Created by Ciprian Caba on 01/08/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

enum TurnstileTransition: String {
  case Push = "Push"
  case Coin = "Coin"
}

extension TurnstileTransition: CustomStringConvertible {
  var description: String {
    get {
      switch self {
      case Push:
        return "Push"
      case Coin:
        return "Coin"
      }
    }
  }
}