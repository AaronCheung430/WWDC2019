/*:
 # Conservation of [Momentum](glossary://momentum)
 
 On the right hand side, you will see a simplified diagram that shows an experimental arrangement to investigate the collision of two trolleys. On this page, you will learn more about momentum, the law of conservation of momentum.
 
 **The law of conservation of momentum**
 
 When two or more object act on each other, their total momentum remains **constant**, provided **no external [forces](glossary://force)** are acting.
 
 `Total` `final` `momentum` `=` `Total` `initial` `momentum`
 
 # Question
 
 Trolley A has a mass of 2 kg, is travelling at a velocity of 5.0 m/s to the right. It collides with trolley B, which has a mass of 4.0 kg and is initially stationary. After the collision, trolley B moves off with a velocity of 1.0 m/s to the right. The two trolleys **do not** stick together. What is the the **final velocity** of trolley A after the collison in m/s?
 
 ## Reminder
 
 * Find a plane first.
 * Tap the screen once to place the experiment
 * When the experiment is unable to place, please run it again
 * Tap the blue/red trolley to start the collision
 
*/
//#-hidden-code
import UIKit
import PlaygroundSupport

let viewController = CollisionViewController()

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code
let velocity = /*#-editable-code*/<#T##answer##Int#>/*#-end-editable-code*/

//#-hidden-code
if velocity == 3 {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "### Congratulations! \nYou have understand MOMENTUM. **Thank you** for reviewing my Playground. Hope you enjoyed and have a nice day!")
    }
}

//#-end-hidden-code
