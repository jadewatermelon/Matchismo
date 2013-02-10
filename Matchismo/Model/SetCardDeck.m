//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Tom Billings on 10/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id) init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
            for (NSString *symbol in [SetCard validSymbols]) {
                for (NSString *shading in [SetCard validShadings]) {
                    for (NSString *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
