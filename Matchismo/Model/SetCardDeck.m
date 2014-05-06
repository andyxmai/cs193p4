//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Andy Mai on 4/22/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

/*
 Custom init method. It adds all possible Set card combination to a deck and
 returns it.
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSNumber *shape in [SetCard validShapes]) {
            for (NSNumber *count in [SetCard validCounts]) {
                for (NSNumber *color in [SetCard validColors]) {
                    for (NSNumber *shade in [SetCard validShades]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.count = count;
                        card.color = color;
                        card.shade = shade;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

/* Returns total number of cards in deck */
+ (NSUInteger)totalNumCards {
    return [[SetCard validColors] count]*[[SetCard validCounts] count]*[[SetCard validShades] count]*[[SetCard validShapes] count];
}

@end
