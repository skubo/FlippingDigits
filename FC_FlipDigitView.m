//
//  FlipDigitView.m
//  RayDOFull
//
//  Created by Christian Garbers on 09.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FC_FlipDigitView.h"


@implementation FC_FlipDigitView

@synthesize m_MaxValue, m_DigitPosition, m_Value;
@synthesize m_ValueChangedDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        m_DigitImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0.png"]];
		m_Value = 0;
		m_MaxValue = 9;
		m_DigitImage.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
		[self addSubview:m_DigitImage];
		m_UpperRect = CGRectMake(0,0, frame.size.width, frame.size.height / 2);
		m_LowerRect = CGRectMake(0,frame.size.height / 2, frame.size.width, frame.size.height / 2);
    }
    return self;
}


-(void)resize {
	m_DigitImage.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
	m_UpperRect = CGRectMake(0,0, self.frame.size.width, self.frame.size.height / 2);
	m_LowerRect = CGRectMake(0,self.frame.size.height / 2, self.frame.size.width, self.frame.size.height / 2);

}

-(void)setCurrentValue:(int)p_Value {
//	NSLog(@"setValue: %i", value);
	m_Value = p_Value;
	m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", p_Value]];
}

-(void)flip:(int)fr to:(int)t {
//	NSLog(@"%i-%i.png", fr, t);
	if ((fr == 0) && (t == 9)) {
		m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i-%i.png", t, fr]];
	} else if ((fr == 9) && (t == 0)) {
		m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i-%i.png", fr, t]];
	} else if ((fr == m_MaxValue) && (t == 0) && (m_MaxValue < 9)) {
		m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i-%i.png", 0, 1]];
	} else if ((fr == 0) && (t == m_MaxValue) && (m_MaxValue < 9)) {
		m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i-%i.png", m_MaxValue-1, m_MaxValue]];
	} else if (fr<t) {
		m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i-%i.png", fr, t]];
	} else {
		m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i-%i.png", t, fr]];
	}
	
	[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(targetMethod:) userInfo:nil repeats:NO];
	
}

-(void)targetMethod: (NSTimer *) theTimer {
	[theTimer invalidate];
	theTimer = nil;

	m_DigitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", m_Value]];
	
}

-(void)incrementDigit {
	if (m_Value == m_MaxValue) {
		m_Value = 0;
		[self flip:m_MaxValue to:0];
		SEL selector = @selector(rollOverAtPosition:);
		if ([m_ValueChangedDelegate respondsToSelector:selector]) {
			NSMethodSignature *signature = [[m_ValueChangedDelegate class] instanceMethodSignatureForSelector:selector];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:m_ValueChangedDelegate];
			int pos = m_DigitPosition;
			[invocation setArgument:&pos atIndex:2];
			[invocation setSelector:selector];
			[invocation invoke];
		} else {
			NSLog(@"no delegate present!");
		}
	} else {
		[self flip:m_Value to:m_Value+1];
		m_Value++;
	}
	
	SEL selector = @selector(valueChangedAtPosition:);
	if ([m_ValueChangedDelegate respondsToSelector:selector]) {
		NSMethodSignature *signature = [[m_ValueChangedDelegate class] instanceMethodSignatureForSelector:selector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setTarget:m_ValueChangedDelegate];
		int pos = m_DigitPosition;
		[invocation setArgument:&pos atIndex:2];
		[invocation setSelector:selector];
		[invocation invoke];
	} else {
		NSLog(@"no delegate present!");
	}
	
}

-(void)decrementDigit {
	if (m_Value == 0) {
		[self flip:0 to:m_MaxValue];
		m_Value = m_MaxValue;
		SEL selector = @selector(rollUnderAtPosition:);
		if ([m_ValueChangedDelegate respondsToSelector:selector]) {
			NSMethodSignature *signature = [[m_ValueChangedDelegate class] instanceMethodSignatureForSelector:selector];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:m_ValueChangedDelegate];
			int pos = m_DigitPosition;
			[invocation setArgument:&pos atIndex:2];
			[invocation setSelector:selector];
			[invocation invoke];
		} else {
			NSLog(@"no delegate present!");
		}
	} else {
		[self flip:m_Value to:m_Value-1];
		m_Value--;
	}
	SEL selector = @selector(valueChangedAtPosition:);
	if ([m_ValueChangedDelegate respondsToSelector:selector]) {
		NSMethodSignature *signature = [[m_ValueChangedDelegate class] instanceMethodSignatureForSelector:selector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setTarget:m_ValueChangedDelegate];
		int pos = m_DigitPosition;
		[invocation setArgument:&pos atIndex:2];
		[invocation setSelector:selector];
		[invocation invoke];
	} else {
		NSLog(@"no delegate present!");
	}
	
}

/*
 * touch controls
 */

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		CGPoint touchPoint = [touch locationInView:self];
		if (CGRectContainsPoint(m_UpperRect, touchPoint)) {
			[self incrementDigit];
		} else if (CGRectContainsPoint(m_LowerRect, touchPoint)) {
			[self decrementDigit];
		}
	}
}




@end
