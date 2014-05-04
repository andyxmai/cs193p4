//
//  Deck.h
//  Matchismo
//
//  Created by Andy Mai on 4/6/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card* )card;

- (Card *)drawRandomCard;

@end
