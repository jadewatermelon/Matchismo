//
//  PlayingCard.m
//  Matchismo
//
//  Created by Tom Billings on 30/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    // create an array filled with all the cards to compare to simplify the process
    NSMutableArray *cards = [[NSMutableArray alloc] initWithArray:otherCards];
    [cards insertObject:self atIndex:0];
    
    int score = 0;
    int matches = 0;
    PlayingCard *cardA;
    PlayingCard *cardB;
    
    for (int i = 0; i < cards.count; i++) {
        cardA = [cards objectAtIndex:i];
        for (int j = i+1; j < cards.count; j++) {
            cardB = [cards objectAtIndex:j];
            if (cardA != cardB) {
                if ([cardA.suit isEqualToString:cardB.suit]) {
                    score += 1;
                    matches++;
                } else if (cardA.rank == cardB.rank) {
                    score += 4;
                    matches++;
                }
            }
        }
    }
    
    if (matches < cards.count - 1) // don't give credit for only one match
        score = 0;
    
    return score;
}
/*
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if (otherCards.count == 2) {
        PlayingCard *otherCardA = [otherCards lastObject];
        PlayingCard *otherCardB = [otherCards lastObject];
        
        if ([otherCardA.suit isEqualToString:self.suit] && [otherCardB.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCardA.rank == self.rank && otherCardB.rank == self.rank) {
            score = 22;
        }
    }
    
    return score;
}
*/
- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    // return @[@"♤",@"♡",@"♢",@"♧"];
    return @[@"♠",@"♥",@"♦",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
        _rank = rank;
}

- (NSString *)description
{
    return [self contents];
}

@end
