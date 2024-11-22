import Foundation

fileprivate struct InterpolationNarrowedInput {
    var leftEdgeInput: Double
    var rightEdgeInput: Double
    var leftEdgeOutput: Double
    var rightEdgeOutput: Double
    init(_ leftEdgeInput: Double, _ rightEdgeInput: Double, _ leftEdgeOutput: Double, _ rightEdgeOutput: Double) {
        self.leftEdgeInput = leftEdgeInput
        self.rightEdgeInput = rightEdgeInput
        self.leftEdgeOutput = leftEdgeOutput
        self.rightEdgeOutput = rightEdgeOutput
    }
}

func interpolate(x: Double, inputRange: [Double], outputRange: [Double]) -> Double {
    let length = inputRange.count
    var narrowedInput =
    InterpolationNarrowedInput(inputRange[0], inputRange[1], outputRange[0], outputRange[1])
    if (length > 2) {
        if (x > inputRange[length - 1]) {
            narrowedInput.leftEdgeInput = inputRange[length - 2];
            narrowedInput.rightEdgeInput = inputRange[length - 1];
            narrowedInput.leftEdgeOutput = outputRange[length - 2];
            narrowedInput.rightEdgeOutput = outputRange[length - 1];
        } else {
            for i in (1 ..< length) {
                if (x <= inputRange[i]) {
                    narrowedInput.leftEdgeInput = inputRange[i - 1]
                    narrowedInput.rightEdgeInput = inputRange[i]
                    narrowedInput.leftEdgeOutput = outputRange[i - 1]
                    narrowedInput.rightEdgeOutput = outputRange[i]
                    break
                }
            }
        }
    }
    if (narrowedInput.rightEdgeInput - narrowedInput.leftEdgeInput == 0.0) {
        return narrowedInput.leftEdgeOutput;
    }
    
    let progress    = (x - narrowedInput.leftEdgeInput) / (narrowedInput.rightEdgeInput - narrowedInput.leftEdgeInput);
    let value       = narrowedInput.leftEdgeOutput + progress * (narrowedInput.rightEdgeOutput - narrowedInput.leftEdgeOutput);
    
    let coef = if (narrowedInput.rightEdgeOutput >= narrowedInput.leftEdgeOutput) {
        1
    } else {
        -1
    }
    if (Double(coef) * value < Double(coef) * narrowedInput.leftEdgeOutput) {
        return narrowedInput.leftEdgeOutput
    }
    if (Double(coef) * value > Double(coef) * narrowedInput.rightEdgeOutput) {
        return narrowedInput.rightEdgeOutput
    }
    return value
}
