/*:
 # Launching Rocket 🚀 with [Momentum](glossary://momentum)
 
 I believe you must have seen rockets launch on the TV, but maybe not in real life. In this playground page, you can launch your own rocket with ARKit. But before that, do you know rockets have [momentum](glossary://momentum) too? Try to use the knowledge you have learnt in the previous pages, and answer the question below.
 
 # Question
 
 The rocket has a [mass](glossary://mass) of 1000kg and is moving at 5m/s. How much is the [momentum](glossary://momentum) of the rocket in kg m/s?
 
 ## Reminder
 
 * Find a plane first.
 * Tap the screen once to place the rocket
 * Tap the screen twice to launch the rocket
 
*/
//#-hidden-code
import UIKit
import PlaygroundSupport

let viewController = RocketViewController()

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

//#-end-hidden-code
let momentum = /*#-editable-code*/<#T##answer##Int#>/*#-end-editable-code*/

//#-hidden-code
if momentum == 5000 {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Well done! You have learned the definition of [momentum](glossary://momentum). You can move to [next page](@next).")
    }
} else {

    PlaygroundPage.current.assessmentStatus = .fail(hints: ["The equation to calculate [momentum](glossary://momentum) is momentum = mass x velocity = 1000kg x 5m/s"],solution: "let momentum = 5000")
}

//#-end-hidden-code
