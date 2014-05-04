//
//  SetCard.h
//  Matchismo
//
//  Created by Andy Mai on 4/22/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSNumber *shape;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *color;
@property (strong, nonatomic) NSNumber *shade;

+ (NSArray *)validShapes;
+ (NSArray *)validCounts;
+ (NSArray *)validShades;
+ (NSArray *)validColors;


@end
