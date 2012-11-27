//
//  FlippingDigitsView.m
//  RayDOFull
//
//  Created by Christian Garbers on 07.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FC_FlipClockView.h"
#import "FC_FlipDigitView.h"

#define SPACER 2

@implementation FC_FlipClockView

@synthesize m_Delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		int x = 0;
		int numNonDigits = m_NumDigits-[m_Values count];
		int digitWidth = (frame.size.width / (m_NumDigits + (numNonDigits/4)));
		m_Numbers = [[NSMutableArray alloc] init];
		digitWidth = digitWidth - m_NumDigits * SPACER;
        for (int i=0; i<[m_Values count]; i++) {
			if ([[NSScanner scannerWithString:[m_Values objectAtIndex:i]] scanInt:NULL]) {
//				NSLog(@"%@ is numeric", [m_Values objectAtIndex:i]);
				FC_FlipDigitView *digit = [[FC_FlipDigitView alloc] initWithFrame:CGRectMake(x, 0, digitWidth, frame.size.height)];
				[digit setCurrentValue:[[m_Values objectAtIndex:i] intValue]];
				[digit setM_DigitPosition:i];
				[digit setM_ValueChangedDelegate:self];
				[self addSubview:digit];
				[m_Numbers addObject:digit];
				x = x + digitWidth + SPACER;
			} else if ([[m_Values objectAtIndex:i]isEqualToString:@":"]) {
//				NSLog(@"%@ is doppelpunkt",[m_Values objectAtIndex:i] );
				x = SPACER + x + digitWidth/7;
			}
		}
		m_WasRollOver = NO;
		m_WasRollUnder = NO;
    }
    return self;
}


-(id)initWithFrame:(CGRect)p_Frame withValue:(NSString*)p_ValueString {
	m_ValueString = p_ValueString;
	if ([p_ValueString length] > 0) {
		m_Values = [[NSMutableArray alloc] init];
	}
	m_NumDigits = 0;
	for (int i=0; i<p_ValueString.length; i++) {
		NSString *l_Digit = [p_ValueString substringWithRange:NSMakeRange(i, 1)];
		[m_Values addObject:l_Digit];
		if ([[NSScanner scannerWithString:l_Digit] scanInt:NULL]) {
			m_NumDigits++;
		}
	}
	return [self initWithFrame:p_Frame];
}

-(void)enable:(BOOL)enable {
	for (int i=0; i<[m_Numbers count]; i++) {
		[[m_Numbers objectAtIndex:i] setUserInteractionEnabled:enable];
	}
}

-(void)resize {
	int x = 0;
	int l_NumNonDigits = m_NumDigits-[m_Values count];
	int l_NumDigits = 0;
	float l_DigitWidth = (self.frame.size.width / (m_NumDigits + (l_NumNonDigits/4)));
	l_DigitWidth = l_DigitWidth - m_NumDigits * SPACER;
	for (int i=0; i<[m_Values count]; i++) {
		if ([[NSScanner scannerWithString:[m_Values objectAtIndex:i]] scanInt:NULL]) {

			[[m_Numbers objectAtIndex:l_NumDigits] setFrame:CGRectMake(x, 0, l_DigitWidth, self.frame.size.height)];
			[[m_Numbers objectAtIndex:l_NumDigits] resize];
			
            x = x + l_DigitWidth + SPACER;
			
            l_NumDigits++;
		} else if ([[m_Values objectAtIndex:i]isEqualToString:@":"]) {
            x = SPACER + x + l_DigitWidth/7;
		}
	}
	
}

-(void)setCurrentValue:(NSString*)p_ValueString {
	m_ValueString = p_ValueString;

	if ([p_ValueString length] > 0) {
		[m_Values removeAllObjects];
	}
	m_NumDigits = 0;
	for (int i=0; i<p_ValueString.length; i++) {
		NSString *l_Digit = [p_ValueString substringWithRange:NSMakeRange(i, 1)];
		[m_Values addObject:l_Digit];
		if ([[NSScanner scannerWithString:l_Digit] scanInt:NULL]) {
            FC_FlipDigitView *l_FV = [m_Numbers objectAtIndex:m_NumDigits];
			[l_FV setCurrentValue:[l_Digit intValue]];
			m_NumDigits++;
		}
	}
}

-(BOOL)previousDigitIsNumberAndNotSpacer:(int)p_DigitIndex {
	if (p_DigitIndex == 0) {
		return NO;
	}
	if ([[NSScanner scannerWithString:[m_Values objectAtIndex:p_DigitIndex-1]] scanInt:NULL]) {
		return YES;
	} else {
		return NO;
	}
	
}

-(BOOL)nextDigitIsNumberAndNotSpacer:(int)p_DigitIndex {
	if (p_DigitIndex == ([m_Values count] - 1)) {
		return NO;
	}
	if ([[NSScanner scannerWithString:[m_Values objectAtIndex:p_DigitIndex+1]] scanInt:NULL]) {
		return YES;
	} else {
		return NO;
	}
	
}

-(void)setMaxValue:(NSString*)p_ValueString {
	m_MaxValue = p_ValueString;
	if ([p_ValueString length] == [m_Values count]) {
		NSArray *views = [self subviews];
		int l_View = 0;
		for (int i=0; i<[p_ValueString length]; i++) {
			if ([[NSScanner scannerWithString:[p_ValueString substringWithRange:NSMakeRange(i, 1)]] scanInt:NULL]) {
				if (![self previousDigitIsNumberAndNotSpacer:i]) {
					[[views objectAtIndex:l_View] setM_MaxValue:[[p_ValueString substringWithRange:NSMakeRange(i, 1)] intValue]];
					l_View++;
				} else {
					[[views objectAtIndex:l_View] setM_MaxValue:9];
					l_View++;
				}

			}
		}
	}
}

-(void)updateValues {
	int gig = 0;
	for (int i=0; i< [m_Values count]; i++) {
		if ([[NSScanner scannerWithString:[m_Values objectAtIndex:i]] scanInt:NULL]) {
			[m_Values replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%i", [[m_Numbers objectAtIndex:gig] m_Value]]];
			gig++;
		}
	}
}

/*
 * digit delegates
 */

-(void)valueChangedAtPosition:(int)p_Position {
	// find out digit index from position
	int l_Index = 0;
	int l_Empty = 0;
	for (int i=0; i<p_Position; i++) {
		
		if ([[NSScanner scannerWithString:[m_MaxValue substringWithRange:NSMakeRange(i, 1)]] scanInt:NULL]) {
			l_Index++;
		} else {
			l_Empty++;
		}

	}
	if ([self previousDigitIsNumberAndNotSpacer:p_Position]) {
		// check if previous digit has max value, 
		int prevmax = [[m_MaxValue substringWithRange:NSMakeRange(p_Position-1, 1)] intValue];
		int prev = [[m_Numbers objectAtIndex:p_Position-l_Empty - 1] m_Value];
		int curmax = [[m_MaxValue substringWithRange:NSMakeRange(p_Position, 1)] intValue];
		int cur = [[m_Numbers objectAtIndex:p_Position - l_Empty] m_Value];
		if (prev == prevmax) {
			//if yes, check if we are above max value for this digit
			if (cur > curmax) {
				// if yes, rollover/rollunder this digit
                FC_FlipDigitView *l_FV = [m_Numbers objectAtIndex:p_Position - l_Empty];
				if (m_WasRollOver) {
					[l_FV setCurrentValue:0];
				} else if (m_WasRollUnder) {
					[l_FV setCurrentValue:curmax];
				} else {
					[l_FV setCurrentValue:0];
				}

			}
		}
	}
	if ([self nextDigitIsNumberAndNotSpacer:p_Position]) {
		int nextmax = [[m_MaxValue substringWithRange:NSMakeRange(p_Position+1, 1)] intValue];
		int next = [[m_Numbers objectAtIndex:p_Position - l_Empty + 1] m_Value];
		int curmax = [[m_MaxValue substringWithRange:NSMakeRange(p_Position, 1)] intValue];
		int cur = [[m_Numbers objectAtIndex:p_Position - l_Empty] m_Value];
		if (next > nextmax) {
			//if yes, check if we are above max value for this digit
			if (cur == curmax) {
				// if yes, we set the next to the max value
                FC_FlipDigitView *l_FV = [m_Numbers objectAtIndex:p_Position - l_Empty + 1];
				[l_FV setCurrentValue:nextmax];
			}
		}
	}
	
	[self updateValues];
	
	SEL selector = @selector(valueChanged:);
	if ([m_Delegate respondsToSelector:selector]) {
		NSMethodSignature *signature = [[m_Delegate class] instanceMethodSignatureForSelector:selector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setTarget:m_Delegate];
		[invocation setSelector:selector];
		[invocation setArgument:&m_Values atIndex:2];
		[invocation invoke];
	} else {
		NSLog(@"no delegate present!");
	}
	m_WasRollUnder = NO;
	m_WasRollOver = NO;
}
-(void)rollOverAtPosition:(int)pos {
	m_WasRollOver = YES;
	m_WasRollUnder = NO;
}
-(void)rollUnderAtPosition:(int)pos {
	m_WasRollOver = NO;
	m_WasRollUnder = YES;
}

-(NSMutableArray*)digitArray {
	return m_Values;
}

-(int)totalSeconds {
	int hours_to = [[NSString stringWithFormat:@"%@%@", [ m_Values objectAtIndex:0], [m_Values objectAtIndex:1]] intValue];
	int mins_to = [[NSString stringWithFormat:@"%@%@", [m_Values objectAtIndex:3], [m_Values objectAtIndex:4]] intValue];
	
	int totalseconds_to = (hours_to * 60 * 60) + (mins_to * 60);
	return totalseconds_to;
}

-(int)totalSecondsForString:(NSString*)st {
	int hours = [[st substringToIndex:2] intValue] *60 *60;
	int mins = [[st substringFromIndex:3] intValue] *60;
	return hours + mins;
}
@end
