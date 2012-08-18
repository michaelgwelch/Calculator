//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Welch on 7/28/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
 
@property (nonatomic) BOOL userIsInMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, readonly) BOOL brainError;
@property (nonatomic, strong, readonly) NSDictionary *operationsForTitles;
@property (nonatomic, readonly) BOOL userHasEnteredDecimalPoint;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize tape = _tape;
@synthesize userIsInMiddleOfEnteringNumber = _userIsInMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize operationsForTitles = _operationsForTitles;


- (NSDictionary *)operationsForTitles
{
    if (!_operationsForTitles) {
        _operationsForTitles = @{ @"+" : [NSNumber numberWithInt:CalculatorAddOperation],
        @"-" : [NSNumber numberWithInt:CalculatorSubtractOperation],
        @"*" : [NSNumber numberWithInt:CalculatorMultiplyOperation],
        @"/" : [NSNumber numberWithInt:CalculatorDivideOperation],
        @"π" : [NSNumber numberWithInt:CalculatorPiOperation],
        @"sin" : [NSNumber numberWithInt:CalculatorSinOperation],
        @"cos" : [NSNumber numberWithInt:CalculatorCosOperation],
        @"sqrt" : [NSNumber numberWithInt:CalculatorSquareRootOperation]};
    }
    
    return _operationsForTitles;
    
}

- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (BOOL)brainError
{
    return self.brain.operationError;
}

- (BOOL)userHasEnteredDecimalPoint
{
    return ([self.display.text rangeOfString:@"."].location != NSNotFound);
}

- (void)updateDisplayByAppendingString:(NSString *)string
{
    self.display.text = [self.display.text stringByAppendingFormat:@"%@", string];
}

- (void)updateDisplayByAppendingString:(NSString *)format
                          withArgument:(id)arg
{
    [self updateDisplayByAppendingString:[NSString stringWithFormat:format, arg]];
}



- (void)updateDisplayWithResult:(double)result
{
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (void)updateDisplayWithString:(NSString *)string
{
    self.display.text = string;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    if (self.brainError) return;
    
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInMiddleOfEnteringNumber)
    {
        [self updateDisplayByAppendingString:@"%@" withArgument:digit];
    }
    else
    {
        [self updateDisplayWithString:digit];
        self.userIsInMiddleOfEnteringNumber = YES;
    }
    
}


- (IBAction)decimalPointPressed
{
    if (self.brainError) return;
    if (self.userHasEnteredDecimalPoint) return;
    
    [self updateDisplayByAppendingString:@"."];
    self.userIsInMiddleOfEnteringNumber = YES;
}

- (IBAction)enterPressed
{
    if (self.brainError) return;
    
    self.userIsInMiddleOfEnteringNumber = NO;
    double value = [self.display.text doubleValue];
    [self.brain pushOperand:value];
    self.tape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}




- (CalculatorOperation)calculateOperationFromTitle:(NSString *)title
{
    NSNumber *operationObject = [self.operationsForTitles objectForKey:title];
    return [operationObject intValue];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.brainError) return;
    if (self.userIsInMiddleOfEnteringNumber) [self enterPressed];
    
    CalculatorOperation operation = [self calculateOperationFromTitle:sender.currentTitle];
    
    double result = [self.brain performOperation:operation];
    self.tape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    if (self.brain.operationError)
    {
        self.display.text = @"Error";
    }
    else
    {
        [self updateDisplayWithResult:result];
    }
    
}

- (void)resetDisplay
{
    self.userIsInMiddleOfEnteringNumber = NO;
    self.display.text = @"0";
    self.tape.text = @"";
}

- (IBAction)clearPressed
{
    [self.brain reset];
    [self resetDisplay];
}



@end
