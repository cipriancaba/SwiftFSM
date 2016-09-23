//
//  SwiftFSMState.swift
//  Pods
//
//  Created by Ciprian Caba on 01/08/15.
//
//

import Foundation

/// A simple state class that is managed internally by SwiftFSM
open class SwiftFSMState<State: Hashable, Transition: Hashable> {
  
  fileprivate var _availableTransitions = [Transition: State]()
  
  /// Closure to be called when the state was entered
  open var onEnter: ((Transition) -> Void)?
  
  /// Closure to be called when the state was exited
  open var onExit: ((Transition) -> Void)?
  
  fileprivate(set) var state: State
  
  init(state: State) {
    self.state = state
  }
  
  /**
  Define a transition from the current state to a new state
  
  :param: transition The transition to be defined
  */
  open func addTransition(_ transition: Transition, to: State) {
    _availableTransitions[transition] = to
  }
  
  func transitionWith(_ transition: Transition) -> State? {
    if let newState = _availableTransitions[transition] {
      return newState
    }
    
    return nil
  }
  
  func enter(_ withTransition: Transition) {
    onEnter?(withTransition)
  }
  
  func exit(_ withTransition: Transition) {
    onExit?(withTransition)
  }
}
