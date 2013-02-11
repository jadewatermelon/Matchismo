//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tom Billings on 31/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; // of type Cardq
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *lastPlay;
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
    
    if (card && !card.isUnplayable) {
        if (card.isFaceUp) {
            self.lastPlay = @"";
        } else {
            self.lastPlay =[NSString stringWithFormat:@"Flipped up %@", card.contents];
        }
        
        self.score -= FLIP_COST;
        card.faceUp = !card.faceUp;
        
        int numFaceUp = [self numFaceUpCards];
        card.orderClicked = numFaceUp - 1;
        
        if (numFaceUp == self.numCardsToMatch){
            [self matchFaceUpCards];
        }
    }
}

- (NSUInteger)numFaceUpCards
{
    NSUInteger num = 0;
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable)
            num++;
    }
    return num;
}

- (void)matchFaceUpCards
{
    NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init]; //initWithCapacity:self.numCardsToMatch];

    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            [cardsToMatch addObject:card];                        //insertObject:card atIndex:card.orderClicked];
        }
    }
    
    [cardsToMatch sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"orderClicked" ascending:YES]]];
    
    NSString *matches = [cardsToMatch componentsJoinedByString:@"&"];
    
    Card *card = [cardsToMatch lastObject];
    [cardsToMatch removeObject:card];
    
    int matchScore = [card match:cardsToMatch];
    if (matchScore) {
        for (Card *matchedCard in cardsToMatch) {
            matchedCard.unplayable = YES;
            matchedCard.orderClicked = 0;
        }
        card.unplayable = YES;
        card.orderClicked = 0;
        
        self.lastPlay = [NSString stringWithFormat:@"Matched %@\nfor %d points!", matches, matchScore * MATCH_BONUS];
        self.score += matchScore * MATCH_BONUS;
    } else {
        for (Card *unmatchedCard in cardsToMatch) {
            unmatchedCard.faceUp = NO;
            unmatchedCard.orderClicked = 0;
        }            
//        card.faceUp = NO;
        card.orderClicked = 0;

        self.lastPlay = [NSString stringWithFormat:@"%@ do not match!\n%d point penalty", matches, MISMATCH_PENALTY];
        self.score -= MISMATCH_PENALTY;
    }
}
/*  slightly more unweildy method, but prints out the contents in the order clicked
- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *status = nil;
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
                            status = [NSString stringWithFormat:@"Matched %@\nfor %d points!", matches, matchScore * MATCH_BONUS];
                            
                            self.score += matchScore * MATCH_BONUS;
                        } else {
                            for (Card *unmatchedCard in cardsToMatch)
                                unmatchedCard.faceUp = NO;
                            
                            [cardsToMatch insertObject:card atIndex:0];  // last card flipped up remains up
                            NSString *noMatches = [cardsToMatch componentsJoinedByString:@"&"];
                            status = [NSString stringWithFormat:@"%@ do not match!\n%d point penalty", noMatches, MISMATCH_PENALTY];

                            self.score -= MISMATCH_PENALTY;
                        }
                        break;
                    }
                }
            }
            self.score -= FLIP_COST;
            if (!status)
                self.lastPlay = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            else
                self.lastPlay = status;
        }
        card.faceUp = !card.faceUp;
    }
*//*
    if (self.isGameOver) {
        for (Card *crd in self.cards) {
            crd.unplayable = YES;
            //crd.faceUp = YES;
        }
        self.lastPlay = [self.lastPlay stringByAppendingString:@"No further matches\nGameOver! Please click deal to play again."];
    }
*/

- (BOOL)isGameOver
{
    BOOL gameOver = YES;
    NSMutableArray *playableCards = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards)
        if (!card.isUnplayable)
            [playableCards addObject:card];
    
    while ([playableCards count] > 1) {
        Card *card = [playableCards lastObject];
        [playableCards removeLastObject];
        if ([card match:playableCards]) {
            gameOver = NO;
            break;
        }
    }
    
    return gameOver;
}

@end