//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Tom Billings on 12/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:[super numPlayableCards]
                                                  usingDeck:[[SetCardDeck alloc] init]
                                               matchingMode:3];
    return _game;
}

- (NSAttributedString *)cardToAttributedString:(Card *)card
{
    NSMutableAttributedString *converted;
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        // build up attributes
        NSMutableDictionary *attributes;
        UIColor *color;
        
        if ([setCard.color isEqualToString:@"red"]) {
            color = [UIColor redColor];
            attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSStrokeColorAttributeName : color}];
        } else if ([setCard.color isEqualToString:@"green"]) {
            color = [UIColor greenColor];
            attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSStrokeColorAttributeName : color}];
        } else if ([setCard.color isEqualToString:@"purple"]) {
            color = [UIColor purpleColor];
            attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSStrokeColorAttributeName : color}];
        }
        // all get a strokewidth
        [attributes addEntriesFromDictionary:@{NSStrokeWidthAttributeName : @-5}];
        
        if ([setCard.shading isEqualToString:@"solid"]) {
            [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:1.0]}];
        } else if ([setCard.shading isEqualToString:@"striped"]) {
            [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.3]}];
        } else if ([setCard.shading isEqualToString:@"open"]) {
            [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.0]}];
        }
        NSString *symbols = [[NSString stringWithFormat:@"%@",setCard.symbol]
                          stringByPaddingToLength:setCard.number
                          withString:[NSString stringWithFormat:@"%@",setCard.symbol]
                          startingAtIndex:0];
        converted = [[NSMutableAttributedString alloc] initWithString:symbols attributes:attributes];  // initializes converted with however many symbols the card has
    }
    return converted ? converted : [[NSMutableAttributedString alloc] initWithString:@""];
}

- (void)updateUIButton:(UIButton *)button withCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateNormal];
        if (card.isFaceUp && !card.isUnplayable) {
            [button setBackgroundColor:[UIColor grayColor]];
        } else {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        
        button.alpha = card.isUnplayable ? 0.0 : 1.0;   // make transparent if the card is no longer playable
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
