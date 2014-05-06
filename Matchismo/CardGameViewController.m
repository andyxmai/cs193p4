//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Andy Mai on 4/5/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardViews;
@end

@implementation CardGameViewController

#define NUM_START_CARDS 12

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateCardsWithAnimation:NO];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.cardGrid.size = self.cardsBoundaryView.bounds.size;
    [self populateCardsWithAnimation:NO];
}

-(void)removeAllCardViews
{
    for (UIView *view in [self.cardsBoundaryView subviews]) {
        [view removeFromSuperview];
    }
}

//reDeals the cards and restarts the game.
- (IBAction)reDealButton:(UIButton *)sender {
    
    [self removeAllCardViews];
    self.cardViews = nil;
    self.game = nil;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.cardGrid = nil;
    
    self.animator = nil;
    [self populateCardsWithAnimation:YES];
}

- (void)populateCardsWithAnimation:(BOOL)animate
{
    [self removeAllCardViews];
    NSUInteger counter = 0;
    NSUInteger row = 0;
    NSUInteger col = 0;
    
    while (counter < [self.cardViews count]) {
        Card *card = [self.game cardAtIndex:counter];
        if (col == self.cardGrid.columnCount) {
            row++;
            col = 0;
        }
        
        CGPoint center = [self.cardGrid centerOfCellAtRow:row inColumn:col];
        CGRect frame = [self.cardGrid frameOfCellAtRow:row inColumn:col];
        
        PlayingCardView *cardView = [self.cardViews objectAtIndex:counter];
        cardView.center = center;
        cardView.frame = frame;
        cardView.faceUp = card.isChosen;
        cardView.matched = [self.game cardAtIndex:counter].isMatched;
        
        if (animate) {
            [UIView transitionWithView:self.cardsBoundaryView
                              duration:0.5
                            options:UIViewAnimationOptionTransitionCurlDown
                            animations:^ { [self.cardsBoundaryView addSubview:cardView]; }
                            completion:nil];
        } else {
            [self.cardsBoundaryView addSubview:cardView];
        }
        
        col++;
        
        counter++;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)flipCardWithTouch:(UITapGestureRecognizer *)recognizer
{
    if (!self.animator) {
        CardView *cardView = (CardView *)(recognizer.view);
        int chosenCardViewIndex = [self.cardViews indexOfObject:cardView];
        Card *chosenCard = [self.game cardAtIndex:chosenCardViewIndex];
        if (!chosenCard.isMatched) {
            cardView.faceUp = !cardView.faceUp;
            [UIView transitionWithView:cardView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:nil
                            completion:nil];
            [self.game chooseCardAtIndex:chosenCardViewIndex];
            [self populateCardsWithAnimation:NO];
        }
    } else {
        [self populateCardsWithAnimation:YES];
        self.animator = nil;
    }
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) {
        _cardViews = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < NUM_START_CARDS; i++) {
            PlayingCardView *cardView = [[PlayingCardView alloc] init];
            Card *card = [self.game cardAtIndex:i];
            cardView.suit = ((PlayingCard *)card).suit;
            cardView.rank = ((PlayingCard *)card).rank;
            cardView.faceUp = card.isChosen;
            
            UITapGestureRecognizer *singleTapCardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCardWithTouch:)];
            [singleTapCardGestureRecognizer setNumberOfTouchesRequired:1];
            [cardView addGestureRecognizer:singleTapCardGestureRecognizer];
            [_cardViews addObject:cardView];
        }
    }
    
    return _cardViews;
}

- (Grid *)cardGrid {
    if (!_cardGrid) {
        _cardGrid = [[Grid alloc] init];
        _cardGrid.cellAspectRatio = 0.75;
        _cardGrid.minimumNumberOfCells = NUM_START_CARDS;
        _cardGrid.size = self.cardsBoundaryView.bounds.size;
    }
    
    return _cardGrid;
}
- (IBAction)gatherCardsWithPinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        if (!self.animator) {
            CGPoint center = [gesture locationInView:self.cardsBoundaryView];
            self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardsBoundaryView];
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:center];
                [self.animator addBehavior:snapBehavior];
            }
        }
    }
}

- (IBAction)moveCardsWithPan:(UIPanGestureRecognizer *)gesture {
    if (self.animator) {
        CGPoint point = [gesture locationInView:self.cardsBoundaryView];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                [self.animator removeBehavior:behavior];
            }
            
            for (UIView *cardView in self.cardViews) {
                UIAttachmentBehavior *attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:point];
                [self.animator addBehavior:attachBehavior];
            }
        } else if (gesture.state == UIGestureRecognizerStateChanged) {
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                ((UIAttachmentBehavior *)behavior).anchorPoint = point;
            }
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                [self.animator removeBehavior:behavior];
            }
        
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:point];
                [self.animator addBehavior:snapBehavior];
            }
        }
    }
}

/*
 Getter for game. Calls the custom init method if it has not been initialized.
 */
- (CardMatchingGame *)game
{
    if (!_game) {
        
        _game = [[CardMatchingGame alloc] initWithCardCount:NUM_START_CARDS
                                                          usingDeck:[self createDeck]];
    }
    
    return _game;
}

/*
 Creates the deck by calling the custom init method PlayingCardDeck.
 */
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
