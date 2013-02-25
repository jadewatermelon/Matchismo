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
    
    int maxNumber = [SetCard maxNumber];
    
    if (self) {
        for (NSUInteger number = 1; number <= maxNumber; number++) {
            for (NSUInteger symbol = 1; symbol <= maxNumber; symbol++) {
                for (NSUInteger shading = 1; shading <= maxNumber; shading++) {
                    for (NSUInteger color = 1; color <= maxNumber; color++) {
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
