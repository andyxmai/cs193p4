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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) NSMutableArray *cardViews;
@end

@implementation CardGameViewController

#define NUM_START_CARDS 12

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    //self.cardViews = nil;
    [self populateCards:NO];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.cardGrid.size = self.cardsBoundaryView.bounds.size;
    [self populateCards:NO];
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
    [self populateCards:YES];
}

- (void)populateCards:(BOOL)animate
{
    [self removeAllCardViews];
    NSUInteger counter = 0;
    NSUInteger row = 0;
    NSUInteger col = 0;
    
    while (counter < [self.cardViews count]) {
        //Card *card = [self.game cardAtIndex:counter];
        if (col == self.cardGrid.columnCount) {
            row++;
            col = 0;
        }
        
        CGPoint center = [self.cardGrid centerOfCellAtRow:row inColumn:col];
        CGRect frame = [self.cardGrid frameOfCellAtRow:row inColumn:col];
        
        PlayingCardView *cardView = [self.cardViews objectAtIndex:counter];
        cardView.center = center;
        cardView.frame = frame;
        cardView.matched = [self.game cardAtIndex:counter].isMatched;
        //cardView.faceUp = !card.isChosen;
        //cardView.faceUp = card.isMatched;
        
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
    
//    NSUInteger counter = 0;
//    for (NSUInteger i = 0; i < self.cardGrid.rowCount; i++) {
//        for (NSUInteger j = 0; j < self.cardGrid.columnCount; j++) {
//            CGPoint center = [self.cardGrid centerOfCellAtRow:i inColumn:j];
//            CGRect frame = [self.cardGrid frameOfCellAtRow:i inColumn:j];
//            
//            PlayingCardView *cardView = [self.cardViews objectAtIndex:counter];
//            cardView.center = center;
//            cardView.frame = frame;
//            //cardView.faceUp = !([self.game cardAtIndex:counter].isChosen);
//            
//            if (animate) {
//                [UIView transitionWithView:self.cardsBoundaryView
//                              duration:0.5
//                               options:UIViewAnimationOptionTransitionCurlUp
//                            animations:^ { [self.cardsBoundaryView addSubview:cardView]; }
//                            completion:nil];
//            } else {
//                [self.cardsBoundaryView addSubview:cardView];
//            }
//            //ADD THIS ^!!!!!!!
//            counter++;
//        }
//    }
//    
//    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
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
            [self populateCards:NO];
        }
    } else {
        [self populateCards:YES];
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
    NSLog(@"HERE");
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
            NSLog(@"Pan Began");
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                [self.animator removeBehavior:behavior];
            }
            
            for (UIView *cardView in self.cardViews) {
                UIAttachmentBehavior *attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:point];
                [self.animator addBehavior:attachBehavior];
            }
        } else if (gesture.state == UIGestureRecognizerStateChanged) {
            NSLog(@"Panning");
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                ((UIAttachmentBehavior *)behavior).anchorPoint = point;
            }
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            NSLog(@"Pan Ended");
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                [self.animator removeBehavior:behavior];
            }
        
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:point];
                [self.animator addBehavior:snapBehavior];
            }
            
            //self.animator = nil;
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

/*
 Button event for the left Card
 */
- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

/*
 Updates the UI to reflect which cards have been flipped and matched.
 It also sets the texts of the labels.
 */
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

/*
 Returns the attributed string used to display as the result of the last (mis)match
 */
- (NSMutableAttributedString *)getLastResultString
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *currentCards = [self combineCardContents:self.game.currentCards];
    
    if (self.game.scoreDiff == 0) {
        result = currentCards;
    } else if (self.game.scoreDiff < 0) {
        [result appendAttributedString:currentCards];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"don't match! %d points penalty!",-1*self.game.scoreDiff]]];
        
        self.game.scoreDiff = 0;
    } else {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
        [result appendAttributedString:currentCards];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"for %d points",self.game.scoreDiff]]];
    }
    
    return result;
}

/*
 Helper method to concatent the contents of an array of cards
 */
- (NSMutableAttributedString *)combineCardContents:(NSArray *)otherCards
{
    NSMutableAttributedString *cardContents = [[NSMutableAttributedString alloc] init];
    
    for (Card *card in otherCards) {
        [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:card.contents]];
        [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    return cardContents;
}


/*
 Helper method to set the title for each card for UI
 */
- (NSAttributedString *)titleForCard:(Card *)card
{
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (card.isChosen) {
        [title appendAttributedString:[[NSAttributedString alloc] initWithString:card.contents]];
    }
    
    return title;
}

/*
 Helper method to set the background image for each card
 */
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
