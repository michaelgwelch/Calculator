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
- (id)pop;
- (void)pushOperand:(double)operand;
- (void)pushVariableOperand:(NSString *)operand;
- (void)pushOperation:(CalculatorOperation)operation;
- (double)run;
- (double)runUsingVariableValues:(NSDictionary *)variableValues;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
@end
