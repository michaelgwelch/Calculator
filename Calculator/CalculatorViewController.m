//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Welch on 7/28/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

int iserror(double value)
{
    return (isnan(value) || isinf(value));
}

@interface CalculatorViewController ()

// only set to true if at least one variable was entered.
@property (nonatomic) BOOL userIsEnteringProgram;
@property (nonatomic, readonly) BOOL userIsInMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong, readonly) NSDictionary *operationsForTitles;
@property (nonatomic, readonly) BOOL userHasEnteredDecimalPoint;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@property (nonatomic, strong) NSString* numberInProgress;
@property (nonatomic) double currentResult;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize tape = _tape;
@synthesize usedVariableValues = _usedVariableValues;
@synthesize brain = _brain;
@synthesize operationsForTitles = _operationsForTitles;
@synthesize testVariableValues = _testVariableValues;
@synthesize numberInProgress = _numberInProgress;
@synthesize currentResult = _currentResult;
@synthesize userIsEnteringProgram = _userIsEnteringProgram;

- (NSString *)numberInProgress
{
    if (!_numberInProgress) {
        _numberInProgress = @"";
    }
    return _numberInProgress;
}

- (void)setNumberInProgress:(NSString *)numberInProgress
{
    if (!numberInProgress) {
        _numberInProgress = @"";
    } else {
        _numberInProgress = numberInProgress;
    }
}

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

- (BOOL)userHasEnteredDecimalPoint
{
    return ([self.numberInProgress rangeOfString:@"."].location != NSNotFound);
}

// Updates the user interface
// if user is entering a number then displayText should
// be supplied. If not the diplay will be filled with result
// of running current program. The tape and variableValues
// will be filled as well.
- (void)updateUI
{
    if (self.userIsEnteringProgram)
    {
        self.testVariableValues = nil;
    }
    
    if (self.userIsInMiddleOfEnteringNumber) {
        self.display.text = self.numberInProgress;
    } else {
        self.display.text = [NSString stringWithFormat:@"%g", self.currentResult];
        self.tape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
        self.usedVariableValues.text = [CalculatorViewController describeUsedVariableValuesInProgram:self.brain.program usingVariableValues:self.testVariableValues];
    }
}

+ (NSString *)describeUsedVariableValuesInProgram:(id)program
                              usingVariableValues:(NSDictionary *)variableValues
{
    NSString *key;
    NSString *result = @"";
    BOOL firstUsedVariable = YES;
    NSSet *variablesInProgram = [CalculatorBrain variablesUsedInProgram:program];
    for (key in variablesInProgram)
    {
        
        if (!firstUsedVariable)
        {
            result = [result stringByAppendingString:@", "];
        }
        else
        {
            firstUsedVariable = NO;
        }
        double value = [[variableValues objectForKey:key] doubleValue];
        result = [result stringByAppendingFormat:@"%@ = %g", key, value];
    }
    return result;
}

- (BOOL)userIsInMiddleOfEnteringNumber
{
    return ![self.numberInProgress isEqualToString:@""];
}

- (CalculatorOperation)calculateOperationFromTitle:(NSString *)title
{
    NSNumber *operationObject = [self.operationsForTitles objectForKey:title];
    return [operationObject intValue];
}

///////////  PUBLIC METHODS THAT UPDATE UI

//// Methods that impact tape, variables used, and result field
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInMiddleOfEnteringNumber) [self enterPressed];
    
    self.currentResult = [self.brain performOperation:[self calculateOperationFromTitle:sender.currentTitle]];
    [self updateUI];
}

- (IBAction)variablePressed:(UIButton *)sender
{
    if (self.userIsInMiddleOfEnteringNumber) [self enterPressed];
    
    self.userIsEnteringProgram = YES;
    [self.brain pushVariableOperand:sender.currentTitle];
    self.currentResult = [CalculatorBrain runProgram:self.brain.program];
    [self updateUI];
}


// This method updates UI but also is called from methods
// that will update UI. Potential clean up location here.
// Extract out the logic from the request for update.
- (IBAction)enterPressed
{    
    double value = [self.numberInProgress doubleValue];
    [self.brain pushOperand:value];
    self.numberInProgress = @"";
    [self updateUI];
}

- (IBAction)clearPressed
{
    [self.brain reset];
    self.numberInProgress = @"";
    self.currentResult = 0;
    self.testVariableValues = @{};
    [self updateUI];
}

//// Methods that only impact result field

- (IBAction)decimalPointPressed
{
    if (self.userHasEnteredDecimalPoint) return;

    self.numberInProgress = [self.numberInProgress stringByAppendingString:@"."];
    [self updateUI];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInMiddleOfEnteringNumber)
    {
        self.numberInProgress = [self.numberInProgress stringByAppendingString:digit];
    }
    else
    {
        self.numberInProgress = digit;
    }
    
    [self updateUI];
}

- (IBAction)testButtonPressed:(UIButton *)sender
{
    if (self.userIsInMiddleOfEnteringNumber) [self enterPressed];
    self.userIsEnteringProgram = NO;

    if ([sender.currentTitle isEqualToString:@"Test 1"])
    {
        self.testVariableValues =
        @{
        @"a" : [NSNumber numberWithDouble:105.17],
        @"b" : [NSNumber numberWithDouble:12.3],
        @"x" : [NSNumber numberWithDouble:-3.57]
        };
    }
    else if ([sender.currentTitle isEqualToString:@"Test 2"])
    {
        self.testVariableValues =
        @{
        @"a" : [NSNumber numberWithDouble:17],
        @"b" : [NSNumber numberWithDouble: -12],
        @"c" : [NSNumber numberWithDouble:45]
        };
    }
    else if ([sender.currentTitle isEqualToString:@"Test 3"])
    {
        self.testVariableValues =
        @{
        @"a" : [NSNumber numberWithDouble:1],
        @"b" : [NSNumber numberWithDouble: -2],
        @"c" : [NSNumber numberWithDouble:3]
        };
    }
    
    self.currentResult = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    [self updateUI];
}


- (void)viewDidUnload {
    self.usedVariableValues = nil;
    self.display = nil;
    self.tape = nil;
    
    [super viewDidUnload];
}
@end
