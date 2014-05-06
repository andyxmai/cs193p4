//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Andy Mai on 4/11/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)addThreeCards;

@property (nonatomic, readonly) NSInteger score; // current score of the game
@property (nonatomic, strong) NSString *lastResult; // Stores the string to diplay for the result label in the UI
@property (nonatomic) int scoreDiff;
@property (nonatomic, strong) NSMutableArray *currentCards;
@property (nonatomic) int numCardsDrawn;

@end
