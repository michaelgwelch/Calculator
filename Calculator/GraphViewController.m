//
//  GraphViewController.m
//  Calculator
//
//  Created by Michael Welch on 11/23/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController ()
@property (nonatomic,weak) IBOutlet GraphView *graphView;

@end

@implementation GraphViewController
@synthesize graphView = _graphView;
@synthesize program = _program;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
