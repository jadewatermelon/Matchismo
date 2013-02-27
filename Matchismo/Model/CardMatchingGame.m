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
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger numCardsInPlay;
@property (nonatomic, readwrite) NSMutableArray *moveHistory; // of type CardMatchingGameMove
@property (nonatomic) NSUInteger numCardsToMatch;
@property (nonatomic) NSString* gameType;
@property (strong, nonatomic) NSMutableArray *faceUpCards;

@property (nonatomic) MoveType currentMove;
@property (nonatomic) int currentScoreChange;
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

- (NSMutableArray *)moveHistory
{
    if (!_moveHistory) _moveHistory = [[NSMutableArray alloc] init];
    return _moveHistory;
}

- (NSMutableArray *)faceUpCards
{
    if (!_faceUpCards) _faceUpCards = [[NSMutableArray alloc] init];
    return _faceUpCards;
}

- (CardMatchingGameResults *)results
{
    if (!_results)
        _results = [[CardMatchingGameResults alloc] initWithGameType:self.gameType];
    return _results;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
           matchingMode:(NSUInteger)num
               gameType:(NSString *)type
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
        self.gameType = type;
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    self.currentMove = MoveTypeFlipDown;
    self.currentScoreChange = 0;
    
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            self.currentMove = MoveTypeFlipUp;
            self.currentScoreChange -= FLIP_COST;  // self.score -= FLIP_COST;
        }

        card.faceUp = !card.faceUp;
        
        int numFaceUp = [self numFaceUpCards];
        card.orderClicked = numFaceUp - 1;
        // preserve current state of cards by sorting based on orderClicked
        [self.faceUpCards sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"orderClicked" ascending:YES]]];
        NSArray *currentCardOrder = [[NSArray alloc] initWithArray:self.faceUpCards]; // copyItems:YES];  // want to do a deep copy....
        
        if (numFaceUp == self.numCardsToMatch){
            [self matchFaceUpCards];
        }
        
        // if the previous move was a flip down remove it
        if ([[[self.moveHistory lastObject] description] isEqualToString:@""]) {
            [self.moveHistory removeLastObject];
        }
        
        CardMatchingGameMove *currentMove = [[CardMatchingGameMove alloc] initWithMoveType:self.currentMove withFlippedCards:currentCardOrder withScoreChange:self.currentScoreChange];
        [self.moveHistory addObject:currentMove];
        self.score += self.currentScoreChange;
        // update game results for every flip
        self.results.score = self.score;
    }
}

- (NSUInteger)numFaceUpCards
{
    NSUInteger num = 0;
    self.faceUpCards = nil;
    for (Card *card in self.cards) {
        if (card.isFaceUp && !card.isUnplayable) {
            num++;
            [self.faceUpCards addObject:card];
        }
    }
    return num;
}

- (void)matchFaceUpCards
{
    NSMutableArray *cardsToMatch = [self.faceUpCards mutableCopy];          // used to update orderClicked for future moves
    
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
        
        self.currentMove = MoveTypeMatch;
        self.currentScoreChange += matchScore * MATCH_BONUS;
    } else {
        for (Card *unmatchedCard in cardsToMatch) {
            unmatchedCard.faceUp = NO;
            unmatchedCard.orderClicked = 0;
        }            
//        card.faceUp = NO;                     // comment if you want the last card selected to remain faceup
        card.orderClicked = 0;

        self.currentMove = MoveTypeMismatch;
        self.currentScoreChange -= MISMATCH_PENALTY;
    }
}
@end