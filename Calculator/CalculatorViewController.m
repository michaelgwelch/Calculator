//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Michael Welch on 7/28/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//


// TODO: after running a program. As soon as I enter anything else, the program runs
// with last set of values. Perhaps this is desired behavior. So that you can set the values
// first, and then enter a program.

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

int iserror(double value)
{
    return (isnan(value) || isinf(value));
}

@interface CalculatorViewController ()


@property (nonatomic, readonly) BOOL userIsInMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong, readonly) NSDictionary *operationsForTitles;
@property (nonatomic, readonly) BOOL userHasEnteredDecimalPoint;
@property (nonatomic, strong) NSString* numberInProgress;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize tape = _tape;
@synthesize brain = _brain;
@synthesize operationsForTitles = _operationsForTitles;
@synthesize numberInProgress = _numberInProgress;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setProgram:self.brain.program];
        [segue.destinationViewController setTitle:[CalculatorBrain descriptionOfProgram:self.brain.program]];
    }
}

- (NSString *)numberInProgress
{
    if (!_numberInProgress) {
        _numberInProgress = @"";
    }
    return _numberInProgress;
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
    
    if (self.userIsInMiddleOfEnteringNumber) {
        self.display.text = self.numberInProgress;
    } else {
        double currentResult = [CalculatorBrain runProgram:self.brain.program];
        self.display.text = [NSString stringWithFormat:@"%g", currentResult];
        self.tape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
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
    
    [self.brain pushOperation:[self calculateOperationFromTitle:sender.currentTitle]];
    [self updateUI];
}

- (IBAction)variablePressed:(UIButton *)sender
{
    if (self.userIsInMiddleOfEnteringNumber) [self enterPressed];
    
    [self.brain pushVariableOperand:sender.currentTitle];
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

- (IBAction)undoPressed
{
    if (self.userIsInMiddleOfEnteringNumber)
    {
        self.numberInProgress = [self.numberInProgress substringToIndex:
                                 [self.numberInProgress length]-1];
    }
    else
    {
        [self.brain pop];
    }
    [self updateUI];
}

- (void)viewDidUnload {
    self.display = nil;
    self.tape = nil;
    
    [super viewDidUnload];
}
@end
