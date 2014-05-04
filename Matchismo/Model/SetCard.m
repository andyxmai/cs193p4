//
//  SetCard.m
//  Matchismo
//
//  Created by Andy Mai on 4/22/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize  shape = _shape;

/*
 Main game logic to check for whether 3 cards satisfy the requirements of Set
 */
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 2) {
        SetCard *firstCard = [otherCards firstObject];
        SetCard *secondCard = [otherCards lastObject];
        if ([self validConditionFor:self.count second:firstCard.count third:secondCard.count]) {
            if ([self validConditionFor:self.shape second:firstCard.shape third:secondCard.shape]) {
                if ([self validConditionFor:self.color second:firstCard.color third:secondCard.color]) {
                    if ([self validConditionFor:self.shade second:firstCard.shade third:secondCard.shade]) {
                        score = 10;
                    }
                }
            }
        }
    }
    
    return score;
}

/*
 Checks for valid condition for an attribute for the Set Game. It returns true if all of cards
 have the same attribute or all have different attributes
 */
- (BOOL)validConditionFor:(NSNumber *)first second:(NSNumber *)second third:(NSNumber *)third
{
    if ([first intValue] == [second intValue] && [first intValue] == [third intValue]) {
        return YES;
    } else if ([first intValue] != [second intValue] && [first intValue] != [third intValue] && [second intValue] != [third intValue]) {
        return YES;
    } else {
        return NO;
    }
}

/*SHOULD ONLY RETURN INTEGERS*/

/*
 Initializes an integer array with size of the count parameter passed in.
 */
+ (NSArray *)arrayWithInts:(int)count
{
    NSMutableArray *intArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [intArr addObject:[NSNumber numberWithInt:i]];
    }
    
    return intArr;
}

/*
 A static array of all possible shapes
 */
+ (NSArray *)validShapes
{
    return [SetCard arrayWithInts:3];
}

/*
 A static array of all possible counts
 */
+ (NSArray *)validCounts
{
    return [SetCard arrayWithInts:3];
}

/*
 A static array of all possible shades
 */
+ (NSArray *)validShades
{
    return [SetCard arrayWithInts:3];
}

/*
 A static array of all possible color
 */
+ (NSArray *)validColors
{
    return [SetCard arrayWithInts:3];
}

@end
