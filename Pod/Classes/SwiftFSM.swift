//
//  SwiftFSM.swift
//  OneUCore
//
//  Created by Ciprian Caba on 03/07/15.
//  Copyright (c) 2015 Cipri. All rights reserved.
//

import Foundation
import UIKit

public class SwiftFSMState<State: Hashable, Transition: Hashable> {
  private var _availableTransitions = [Transition: State]()
  public var onEnter: ((Transition) -> Void)?
  public var onExit: ((Transition) -> Void)?
  
  public private(set) var state: State
  
  public init(state: State) {
    self.state = state
  }
  
  public func addTransition(transition: Transition, to: State) {
    _availableTransitions[transition] = to
  }
  
  private func transitionWith(transition: Transition) -> State? {
    if let newState = _availableTransitions[transition] {
      return newState
    }
    
    return nil
  }
  
  private func enter(withTransition: Transition) {
    onEnter?(withTransition)
  }
  
  private func exit(withTransition: Transition) {
    onExit?(withTransition)
  }
}

public class SwiftFSM<State: Hashable, Transition: Hashable> {
  private let _id: String
  private let _willLog: Bool
  
  private var _states = [State: SwiftFSMState<State, Transition>]()
  private var _currentState: SwiftFSMState<State, Transition>?
  
  public var currentState: State {
    get {
      return _currentState!.state
    }
  }
  
  public init (id: String = "SwiftFSM", willLog: Bool = true) {
    _id = id
    _willLog = willLog
  }
  
  public func addState(newState: State) -> SwiftFSMState<State, Transition> {
    if let existingState = _states[newState] {
      log("State \(newState) already added")
      return existingState
    } else {
      let newFsmState = SwiftFSMState<State, Transition>(state: newState)
      _states[newState] = newFsmState
      return newFsmState
    }
  }
  
  public func startFrom(state: State) {
    if _currentState == nil {
      if let fsmState = _states[state] {
        _currentState = fsmState
      } else {
        log("Cannot find the \(state) start state")
      }
    } else {
      log("Fsm already started. Cannot startFrom again")
    }
  }
  
  public func transitionWith(transition: Transition) -> State? {
    if let oldState = _currentState {
      if let newState = oldState.transitionWith(transition) {
        if let newFsmState = _states[newState] {
          log("\(oldState.state) -> \(transition) -> \(newState)")
          _currentState = newFsmState
          oldState.exit(transition)
          newFsmState.enter(transition)
          return newState
        } else {
          log("The \(transition) transitions to an unregistered \(newState) state")
        }
      } else {
        log("There is no transition defined from the [\(oldState.state)] state with the [\(transition)] transition")
      }
    } else {
      log("Please start the fsm first")
    }
    
    return nil
  }
  
  private func log(message: String) {
    if _willLog {
      println("\(_id) \(message)")
    }
  }
}