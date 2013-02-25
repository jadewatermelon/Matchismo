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

- (NSString *)gameType
{
    return @"Set";
}

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:[super numPlayableCards]
                                                  usingDeck:[[SetCardDeck alloc] init]
                                               matchingMode:3
                                                   gameType:self.gameType];
    return _game;
}

- (NSAttributedString *)cardToAttributedString:(Card *)card
{
    NSMutableAttributedString *converted;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:@{NSParagraphStyleAttributeName : paragraphStyle}];    
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        // build up attributes
        UIColor *color;
        
        switch(setCard.color) {
            case 1: //red
                color = [UIColor colorWithRed:1.00 green:0.10 blue:0.07 alpha:1.00];
                break;
            case 2: // green
                color = [UIColor colorWithRed:0.00 green:0.84 blue:0.32 alpha:1.00];
                break;
            case 3: // purple
                color = [UIColor colorWithRed:0.42 green:0.15 blue:0.79 alpha:1.00];
                break;
            default: // problem if we are ever here
                color = [UIColor blackColor];
                break;
        }
        
        [attributes addEntriesFromDictionary:@{NSStrokeColorAttributeName : color}];
        
        // all get a strokewidth
        [attributes addEntriesFromDictionary:@{NSStrokeWidthAttributeName : @-5}];
        
        switch(setCard.shading) {
            case 1: // open
                [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.0]}];
                break;
            case 2: // striped
                [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.3]}];
                break;
            case 3: // solid
                [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:1.0]}];
                break;
            default: // should never get half filled
                [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.5]}];
                break;
        }
        
        NSString *symbol;
        
        switch(setCard.symbol) {
            case 1: // ■
                symbol = @"■";
                break;
            case 2: // ▲
                symbol = @"▲";
                break;
            case 3: // ●
                symbol = @"●";
                break;
            default: // should never get a ♠
                symbol = @"♠";
                break;
        }
        
        // initializes converted with however many symbols the card has
        NSString *symbols = [[NSString stringWithFormat:@"%@",symbol]
                          stringByPaddingToLength:setCard.number
                          withString:[NSString stringWithFormat:@"%@",symbol]
                          startingAtIndex:0];
        converted = [[NSMutableAttributedString alloc] initWithString:symbols attributes:attributes];  
    }
    return converted ? converted : [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
}

- (void)updateUIButton:(UIButton *)button withCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        [button setAttributedTitle:[self cardToAttributedString:card] forState:UIControlStateNormal];
        if (card.isFaceUp && !card.isUnplayable) {
            [button setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.7 alpha:0.3]];
        } else {
            [button setBackgroundColor:nil];
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
