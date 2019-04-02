/*:
 # Physics - [Momentum](glossary://momentum)
 
 Welcome! First, you need to understand what is [MOMENTUM](glossary://momentum).
 
 All moving objects have momentum and momentum is a [vector](glossary://vector). But if an object is not moving then it's momentum is zero. Objects that are not moving have no momentum.
 
 However, [momentum](glossary://momentum) has an exact scienific definition:
 
 **The word equation**
 
 [momentum](glossary://momentum) `=` [mass](glossary://mass) `x` [velocity](glossary://velocity)
 
  **The symbol equation**
 
 [p](glossary://p) `=` [m](glossary://m) `x` [v](glossary://v)
 
 # Question
 
 The car has a [mass](glossary://mass) of 100kg and is not moving. How much is the [momentum](glossary://momentum) of the car in kg m/s?
 
 ## Reminder
 
 * Use the equation above to help you
 * You may move around with your finger to view the car
 * If you saw black screen after run, please reset the page and run it again, thx!
 */

//#-hidden-code
import UIKit
import PlaygroundSupport
    
let viewController = IntroViewController()

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code
let momentum = /*#-editable-code*/<#T##answer##Int#>/*#-end-editable-code*/

//#-hidden-code
if momentum == 0 {
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            PlaygroundPage.current.assessmentStatus = .pass(message: "Whoa! You have learned the definition of [momentum](glossary://momentum). You can move to [next page](@next) and continue your momentum journey.")
    }
} else {

    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Because we are finding the [momentum](glossary://momentum) of the car, we need to apply the equation: momentum = mass x velocity = 100kg x 0m/s"],solution: "let momentum = 0")
}

//#-end-hidden-code
