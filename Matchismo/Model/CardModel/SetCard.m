//
//  SetCard.m
//  Matchismo
//
//  Created by Tom Billings on 10/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#define MATCHSCORE 10
#define CARDS_IN_A_SET 3

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int numberMatches  = self.number;
    int symbolMatches  = self.symbol;
    int shadingMatches = self.shading;
    int colorMatches   = self.color;
    
    if ([otherCards count] == 2) {
        for (id obj in otherCards) {
            if ([obj isKindOfClass:[SetCard class]]) {
                SetCard *setCard = (SetCard *)obj;
                
                numberMatches  += setCard.number;
                symbolMatches  += setCard.symbol;
                shadingMatches += setCard.shading;
                colorMatches   += setCard.color;
            }
        }
        if ((numberMatches  % CARDS_IN_A_SET == 0) &&
            (symbolMatches  % CARDS_IN_A_SET == 0) &&
            (shadingMatches % CARDS_IN_A_SET == 0) &&
            (colorMatches   % CARDS_IN_A_SET == 0))
            score = MATCHSCORE;
    }
    
    return score;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d.%d.%d.%d",self.number,self.shading,self.color,self.symbol];
}

- (NSString *)description
{
    return [self contents];
}

#pragma mark - Setters & Helpers -

+ (NSArray *)numberStrings
{
    return @[@"?",@"1",@"2",@",3"];
}

+ (NSInteger)maxNumber
{
    return [[self numberStrings] count] - 1;
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

- (void)setSymbol:(NSUInteger)symbol
{
    if (symbol <= [SetCard maxNumber])
        _symbol = symbol;
}

- (void)setShading:(NSUInteger)shading
{
    if (shading <= [SetCard maxNumber])
        _shading = shading;
}

- (void)setColor:(NSUInteger)color
{
    if (color <= [SetCard maxNumber])
         _color = color;
}

@end
