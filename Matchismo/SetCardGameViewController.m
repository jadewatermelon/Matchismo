//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Tom Billings on 12/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (NSString *)gameType
{
    return @"Set";
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)matchingMode
{
    return 3;
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
        
        if ([setCard.color isEqualToString:@"red"]) {
            color = [UIColor redColor];
        } else if ([setCard.color isEqualToString:@"green"]) {
            color = [UIColor greenColor];
        } else if ([setCard.color isEqualToString:@"purple"]) {
            color = [UIColor purpleColor];
        }
        
        [attributes addEntriesFromDictionary:@{NSStrokeColorAttributeName : color}];
        
        // all get a strokewidth
        [attributes addEntriesFromDictionary:@{NSStrokeWidthAttributeName : @-5}];
        
        if ([setCard.shading isEqualToString:@"solid"]) {
            [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:1.0]}];
        } else if ([setCard.shading isEqualToString:@"striped"]) {
            [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.3]}];
        } else if ([setCard.shading isEqualToString:@"open"]) {
            [attributes addEntriesFromDictionary:@{NSForegroundColorAttributeName : [color colorWithAlphaComponent:0.0]}];
        }
        
        // initializes converted with however many symbols the card has
        NSString *symbols = [[NSString stringWithFormat:@"%@",setCard.symbol]
                          stringByPaddingToLength:setCard.number
                          withString:[NSString stringWithFormat:@"%@",setCard.symbol]
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

@end
