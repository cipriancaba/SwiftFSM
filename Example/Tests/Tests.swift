import UIKit
import XCTest
import SwiftFSM

class Tests: XCTestCase {
  
  let fsm = SwiftFSM<TurnstileState, TurnstileTransition>(id: "TurnstileFSM", willLog: false)
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    let locked = fsm.addState(.Locked)
    locked.addTransition(.Push, to: .Locked)
    locked.addTransition(.Coin, to: .Unlocked)
    
    let unlocked = fsm.addState(.Unlocked)
    unlocked.addTransition(.Coin, to: .Unlocked)
    unlocked.addTransition(.Push, to: .Locked)
    
    fsm.startFrom(.Locked)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testOnEnter() {
    let expectationUnlockedEntered = expectationWithDescription("unlockedEntered")
    
    let unlocked = fsm.addState(.Unlocked)
    
    unlocked.onEnter = { (transition: TurnstileTransition) -> Void in
      XCTAssertEqual(transition, .Coin, "Fsm did not entered the unlocked state with the .Coin transition")
      expectationUnlockedEntered.fulfill()
    }
    
    fsm.transitionWith(.Coin)
    
    waitForExpectationsWithTimeout(3, handler: { (error) -> Void in
      if let error = error {
        println("Error: \(error.localizedDescription)")
      }
    })
  }
  
  func testOnExit() {
    let expectationUnlockedExited = expectationWithDescription("unlockedExited")
    
    let unlocked = fsm.addState(.Unlocked)
    unlocked.onExit = { (transition: TurnstileTransition) -> Void in
      XCTAssertEqual(transition, .Push, "Fsm did not exited the unlocked state with the .Push transition")
      expectationUnlockedExited.fulfill()
    }
    
    // Transition to Unlocked
    fsm.transitionWith(.Coin)
    
    // And then transition back to locked so onExit is triggered
    fsm.transitionWith(.Push)
    
    waitForExpectationsWithTimeout(3, handler: { (error) -> Void in
      if let error = error {
        println("Error: \(error.localizedDescription)")
      }
    })
  }
  
  func testStateChange() {
    // This needs to transition to unlocked
    if let newState = fsm.transitionWith(.Coin) {
      XCTAssertEqual(fsm.currentState, newState, "Fsm currentState is not the same with the returned state")
      XCTAssertEqual(fsm.currentState, .Unlocked, "Fsm did not transition to unlocked")
    } else {
      XCTFail("Fsm has not transitioned at all")
    }
  }
}
