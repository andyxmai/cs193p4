//
//  GameHistoryViewController.m
//  Matchismo
//
//  Created by Andy Mai on 4/23/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GameHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUI];
}

/*
 Adds the game history texts to the UITextView
 */
- (void)updateUI
{
    NSMutableAttributedString *text = self.textView.textStorage;
    
    if ([self.gameHistory count]) {
        for (NSMutableAttributedString *history in self.gameHistory) {
            [text appendAttributedString:history];
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        }
    } else {
        [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"No history for this game yet!"]];
    }
}

@end
