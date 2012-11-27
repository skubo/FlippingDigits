//
//  CG_ViewController.m
//  FlippingDigits
//
//  Created by Christian Garbers on 10.10.12.
//  Copyright (c) 2012 Christian Garbers. All rights reserved.
//

#import "CG_ViewController.h"
#import "FC_FlipClockView.h"

@interface CG_ViewController ()

@end

@implementation CG_ViewController

@synthesize m_SelectedTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect l_FlipRect = CGRectMake(10, 20, self.view.frame.size.width -10, 100);
    FC_FlipClockView *l_FlipClock = [[FC_FlipClockView alloc] initWithFrame:l_FlipRect withValue:@"12:00"];
    [l_FlipClock setMaxValue:@"23:59"];
    [l_FlipClock setM_Delegate:self];
    [self.view addSubview:l_FlipClock];
}

-(void)valueChanged:(NSMutableArray*)p_Values {
    NSString *l_TimeString = [NSString stringWithFormat:@"%@%@%@%@%@", [p_Values objectAtIndex:0]
                              , [p_Values objectAtIndex:1]
                              , [p_Values objectAtIndex:2]
                              , [p_Values objectAtIndex:3]
                              , [p_Values objectAtIndex:4]];
    [m_SelectedTime setText:l_TimeString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
