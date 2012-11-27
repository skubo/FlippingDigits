//
//  FlippingDigitsView.h
//  RayDOFull
//
//  Created by Christian Garbers on 07.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FC_FlipClockView: UIView {
	NSMutableArray *m_Values;
	NSMutableArray *m_Numbers;
	int m_NumDigits;
	NSString *m_ValueString;
	NSString *m_MaxValue;
	
	BOOL m_WasRollOver;
	BOOL m_WasRollUnder;
	
	id __unsafe_unretained m_Delegate;
}

@property (assign) id m_Delegate;

-(id)initWithFrame:(CGRect)p_Frame withValue:(NSString*)p_ValueString;
-(void)setMaxValue:(NSString*)p_ValueString;
-(void)setCurrentValue:(NSString*)p_ValueString;
-(void)enable:(BOOL)enable;
-(void)resize;
-(NSMutableArray*)digitArray;
-(int)totalSeconds;
-(int)totalSecondsForString:(NSString*)p_ValueString;
@end
