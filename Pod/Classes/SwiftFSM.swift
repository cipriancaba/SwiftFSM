//
//  SwiftFSM.swift
//  OneUCore
//
//  Created by Ciprian Caba on 03/07/15.
//  Copyright (c) 2015 Cipri. All rights reserved.
//

import Foundation
import UIKit

/// A simple, enum based FSM implementation
public class SwiftFSM<State: Hashable, Transition: Hashable> {
  private let _id: String
  private let _willLog: Bool
  
  private var _states = [State: SwiftFSMState<State, Transition>]()
  private var _currentState: SwiftFSMState<State, Transition>?
  
  /// Returns the current state of the fsm
  public var currentState: State {
    get {
      return _currentState!.state
    }
  }
  
  /**
  Initializes a new fsm with the provided id and logging specifications
  Also defines the State and Transition generics
  
  :param: id The id of the fsm.. Might come in handy if you use multiple fsm instances
  :param: willLog Parameter that will enable/disable logging of this fsm instance
  
  :returns: A new SwiftFSM instance
  */
  public init (id: String = "SwiftFSM", willLog: Bool = true) {
    _id = id
    _willLog = willLog
  }
  
  /**
  Adds and returns a new or an already existing fsm state
  If the state was defined before, that SwiftFSMState instance will be returned
  
  :param: newState The enum of the new fsm state
  
  :returns: A SwiftFSMState instance for the newState
  */
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
  
  /**
  Starts the fsm in the specified state. The state must be defined with the addState method
  
  This method will not trigger any onEnter or onExit methods
  
  :param: state The initial state of the fsm
  */
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
  
  /** 
  Try transitioning the fsm with the specified transition

  :param: transition The transition to be used
  
  :returns: This method will return the new state if the state transition was successful or nil otherwise
  */
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