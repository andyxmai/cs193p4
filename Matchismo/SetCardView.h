//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Andy Mai on 5/4/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView
@property (strong, nonatomic) NSNumber *shape;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *color;
@property (strong, nonatomic) NSNumber *shade;
@end
