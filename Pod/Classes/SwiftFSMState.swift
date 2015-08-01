//
//  SwiftFSMState.swift
//  Pods
//
//  Created by Ciprian Caba on 01/08/15.
//
//

import Foundation

/// A simple state class that is managed internally by SwiftFSM
public class SwiftFSMState<State: Hashable, Transition: Hashable> {
  
  private var _availableTransitions = [Transition: State]()
  
  /// Closure to be called when the state was entered
  public var onEnter: ((Transition) -> Void)?
  
  /// Closure to be called when the state was exited
  public var onExit: ((Transition) -> Void)?
  
  private(set) var state: State
  
  init(state: State) {
    self.state = state
  }
  
  /**
  Define a transition from the current state to a new state
  
  :param: transition The transition to be defined
  */
  public func addTransition(transition: Transition, to: State) {
    _availableTransitions[transition] = to
  }
  
  func transitionWith(transition: Transition) -> State? {
    if let newState = _availableTransitions[transition] {
      return newState
    }
    
    return nil
  }
  
  func enter(withTransition: Transition) {
    onEnter?(withTransition)
  }
  
  func exit(withTransition: Transition) {
    onExit?(withTransition)
  }
}