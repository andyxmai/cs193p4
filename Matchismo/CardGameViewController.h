//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Andy Mai on 4/5/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "PlayingCardView.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) Grid *cardGrid;
@property (weak, nonatomic) IBOutlet UIView *cardsBoundaryView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

- (void)updateUI;
- (void)flipCardWithTouch:(UITapGestureRecognizer *)recognizer;
- (void)removeAllCardViews;
@end
