//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tom Billings on 31/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; // of type Card
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *flipStatus;
@property (nonatomic) NSUInteger numCardsToMatch;
@end

@implementation CardMatchingGame

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck matchingMode:(NSUInteger)num
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.numCardsToMatch = num;
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.flipStatus = nil;
    NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [cardsToMatch addObject:otherCard];
                    if ((cardsToMatch.count + 1) == self.numCardsToMatch) {
                        int matchScore = [card match:cardsToMatch];
                        if (matchScore) {
                            [cardsToMatch insertObject:card atIndex:0]; // last card flipped up matched 
                            for (Card *matchedCard in cardsToMatch)
                                matchedCard.unplayable = YES;
                            
                            NSString *matches = [cardsToMatch componentsJoinedByString:@"&"];
                            self.flipStatus = [NSString stringWithFormat:@"Matched %@ for %d points!", matches, matchScore * MATCH_BONUS];
                            
                            self.score += matchScore * MATCH_BONUS;
                        } else {
                            for (Card *unmatchedCard in cardsToMatch)
                                unmatchedCard.faceUp = NO;
                            
                            [cardsToMatch insertObject:card atIndex:0];  // last card flipped up remains up
                            NSString *noMatches = [cardsToMatch componentsJoinedByString:@"&"];
                            self.flipStatus = [NSString stringWithFormat:@"%@ do not match! %d point penalty", noMatches, MISMATCH_PENALTY];

                            self.score -= MISMATCH_PENALTY;
                        }
                        break;
                    }
                }
            }
            self.score -= FLIP_COST;
            if (!self.flipStatus)
                self.flipStatus = [NSString stringWithFormat:@"Flipped up %@", card.contents];
        }
        card.faceUp = !card.faceUp;
    }    
}

@end
/*
 if (self.matchMode == 0) {
 if (!card.isUnplayable) {
 if (!card.isFaceUp) {
 for (Card *otherCard in self.cards) {
 if (otherCard.isFaceUp && !otherCard.isUnplayable) {
 int matchScore = [card match:@[otherCard]];
 if (matchScore) {
 otherCard.unplayable = YES;
 card.unplayable = YES;
 self.score += matchScore * MATCH_BONUS;
 self.flipStatus = [NSString stringWithFormat:@"Matched %@ & %@ for %d points!", card.contents, otherCard.contents, MATCH_BONUS];
 } else {
 otherCard.faceUp = NO;
 self.score -= MISMATCH_PENALTY;
 self.flipStatus = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY];
 }
 break;
 }
 }
 self.score -= FLIP_COST;
 if (!self.flipStatus)
 self.flipStatus = [NSString stringWithFormat:@"Flipped up %@", card.contents];
 }
 card.faceUp = !card.faceUp;
 }
 } else if (self.matchMode == 1) {
 NSMutableArray *otherCards;
 if (!card.isUnplayable) {
 if (!card.isFaceUp) {
 for (Card *otherCard in self.cards) {
 if (otherCard.isFaceUp && !otherCard.isUnplayable)
 [otherCards addObject:otherCard];
 }// possibly no other cards face up; one card is face up; or two cards face up
 // call match if 1 or 2 cards face up and report back otherwise just say what's been flipped up
 // what happens if you send match an empty array? it returns 0 the same as if there were no match... so still need to verify count
 if (otherCards.count == 1) {
 
 }
 else if (otherCards.count == 2) {
 
 }
 }
 }
 }*/


 /*       Card *otherCardA = nil;
        if (!card.isUnplayable) {
            if (!card.isFaceUp) {
                for (Card *otherCard in self.cards) {
                    if (!otherCardA && otherCard.isFaceUp && !otherCard.isUnplayable) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            otherCardA = otherCard;
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            self.flipStatus = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY];
                        }
                    } else if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        int matchScore = [card match:@[otherCard, otherCardA]];
                        if (matchScore) {
                            otherCard.unplayable = YES;
                            otherCardA.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.flipStatus = [NSString stringWithFormat:@"Matched %@ & %@ & %@ for %d points!", card.contents, otherCardA.contents, otherCard.contents, MATCH_BONUS];
                        } else {
                            otherCard.faceUp = NO;
                            otherCardA.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            self.flipStatus = [NSString stringWithFormat:@"%@ & %@ & %@ don't match! %d point penalty!", card.contents, otherCardA.contents, otherCard.contents, MISMATCH_PENALTY];
                        }
                        break;
                    }
                }
                self.score -= FLIP_COST;
                if (!self.flipStatus)
                    self.flipStatus = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            card.faceUp = !card.faceUp;
        }
    }
    
}

@end
*/