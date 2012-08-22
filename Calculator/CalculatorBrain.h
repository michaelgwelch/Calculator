//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Michael Welch on 7/30/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CalculatorOperation {
    CalculatorAddOperation,
    CalculatorSubtractOperation,
    CalculatorMultiplyOperation,
    CalculatorDivideOperation,
    CalculatorPiOperation,
    CalculatorSinOperation,
    CalculatorCosOperation,
    CalculatorSquareRootOperation,
} CalculatorOperation;



@interface CalculatorBrain : NSObject
@property (readonly) id program;
- (void)reset;
- (void)pushOperand:(double)operand;
- (void)pushVariableOperand:(NSString *)operand;
- (double)performOperation:(CalculatorOperation)operation;
+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
@end
