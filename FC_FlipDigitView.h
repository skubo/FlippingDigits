//
//  FlipDigitView.h
//  RayDOFull
//
//  Created by Christian Garbers on 09.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FC_FlipDigitView : UIView {
	UIImageView *m_DigitImage;
	CGRect		m_UpperRect;
	CGRect		m_LowerRect;
	int			m_Value;
	int			m_MaxValue;
	int			m_DigitPosition;
	
	id __unsafe_unretained m_ValueChangedDelegate;
}

@property (assign) int m_MaxValue, m_DigitPosition, m_Value;
@property (assign) id m_ValueChangedDelegate;

-(void)setCurrentValue:(int)p_Val;
-(void)resize;
-(void)incrementDigit;
-(void)decrementDigit;
@end
