//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Andy Mai on 5/4/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardView.h"

@interface PlayingCardView : CardView
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) CGFloat cellAspectRatio;

// Built-in Gesture Handler
- (void)resizeFaceWithPinch:(UIPinchGestureRecognizer *)gesture;
- (void)flipCardWithTouch:(UITapGestureRecognizer *)recognizer;
@end
