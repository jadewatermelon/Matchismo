//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Tom Billings on 12/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCard.h"


@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController
@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:[super numPlayableCards]
                                                  usingDeck:[[PlayingCardDeck alloc] init]
                                               matchingMode:2];
    return _game;
}

- (NSAttributedString *)cardToAttributedString:(Card *)card
{
    // do I need to do something prettier here?
    return [[NSAttributedString alloc] initWithString:card.contents];
}

- (void)updateUIButton:(UIButton *)button withCard:(Card *)card
{
    if ([card isKindOfClass:[PlayingCard class]]) {
        // back of playing card has an image with no text
        [button setBackgroundImage:[UIImage imageNamed:@"Images/playingCardBack.png"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
        [button setAttributedTitle:nil forState:UIControlStateNormal];
        // when the card is faceup the contents are shown whether or not it is unplayable
        // the background is defined as well
        [button setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder.png"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"Images/playingCardFrontBorder.png"] forState:UIControlStateSelected|UIControlStateDisabled];
        [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateSelected];
        [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateSelected|UIControlStateDisabled];
        
        button.alpha = card.isUnplayable ? 0.3 : 1.0;   // make transparent if the card is no longer playable
        button.selected = card.isFaceUp;
        button.enabled = !card.isUnplayable;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
