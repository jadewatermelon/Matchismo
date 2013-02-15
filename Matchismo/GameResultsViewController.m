//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by Tom Billings on 15/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "GameResultsViewController.h"
#include "CardMatchingGameResults.h"

@interface GameResultsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) NSArray *allGameResults;

@end

@implementation GameResultsViewController

- (IBAction)sortByDate
{
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(dateCompare:)];
    [self updateUI];
}

- (IBAction)sortByScore
{
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(scoreCompare:)];
    [self updateUI];
}

- (IBAction)sortByDuration
{
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(durationCompare:)];
    [self updateUI];
}

- (void)updateUI
{
    NSString *matching = @"";
    NSString *set = @"";
    NSString *other = @"";
    NSString *tempText = @"";
    
    for (CardMatchingGameResults *gameResult in self.allGameResults) {
        tempText = [NSString stringWithFormat:@"Score: %d (%@, %0gs)\n",
                    gameResult.score,
                    [NSDateFormatter localizedStringFromDate:gameResult.end dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle],
                    round(gameResult.duration)];
        if ([gameResult.gameType isEqualToString:@"Matching"])
            matching = [matching stringByAppendingString:tempText];
        else if ([gameResult.gameType isEqualToString:@"Set"])
            set = [set stringByAppendingString:tempText];
        else
            other = [other stringByAppendingString:tempText];
    }
    // build final output string
    tempText = @"Matching Game Scores:\n";
    tempText = [[[tempText stringByAppendingString:matching] stringByAppendingString:@"Set Game Scores: \n"] stringByAppendingString:set];
    if ([other length] > 0)
        tempText = [[tempText stringByAppendingString:@"Other Scores:\n"] stringByAppendingString:other];
     
    self.display.text = tempText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.allGameResults = [CardMatchingGameResults allGameResults];
    [self updateUI];
}

- (void)setup
{
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup]; 
    return self;
}

@end
