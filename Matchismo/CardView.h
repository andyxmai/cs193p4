//
//  CardView.h
//  Matchismo
//
//  Created by Andy Mai on 5/4/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView
@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL matched;

-(void) drawRoundedRect:(CGRect)rect fillColor:(UIColor *)color;

@end
