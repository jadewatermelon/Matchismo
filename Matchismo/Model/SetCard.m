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

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] ==2) {
        NSMutableArray *cards = [[NSMutableArray alloc] initWithArray:otherCards];
        [cards addObject:self];
        
        NSCountedSet *features = [[NSCountedSet alloc] init];
        
        for (id obj in cards) {
            if ([obj isKindOfClass:[SetCard class]]) {
                SetCard *card = (SetCard *)obj;
                [features addObject:@(card.number)];
                [features addObject:card.symbol];
                [features addObject:card.shading];
                [features addObject:card.color];
            }
        }
        for (id feature in features) {
            // if any feature is present twice then there is no set
            if ([features countForObject:feature] == 2) {
                score = 0;
                break;
            }
            else
                score = MATCHSCORE;
        }
    }
    
    return score;
}

- (NSString *)contents
{
    return [[SetCard numberStrings][self.number] stringByAppendingFormat:@"%@%@%@",self.shading,self.color,self.symbol];
}

- (NSString *)description
{
    return [self contents];
}

@synthesize symbol = _symbol;
@synthesize shading = _shading;
@synthesize color = _color;

+ (NSArray *)numberStrings
{
    return @[@"?",@"1",@"2",@",3"];
}

+ (NSInteger)maxNumber
{
    return [[self numberStrings] count] - 1;
}

+ (NSArray *)validSymbols
{
    return @[@"■",@"▲",@"●"];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol])
        _symbol = symbol;
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

+ (NSArray *)validShadings
{
    return @[@"solid",@"striped",@"open"];
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading])
        _shading = shading;
}

- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

+ (NSArray *)validColors
{
    return @[@"red",@"green",@"purple"];
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color])
         _color = color;
}

- (NSString *)color
{
    return _color ? _color : @"?";
}

@end

/* // first very impracticle implementation of match before learning about NSCountedSet
 - (int)match:(NSArray *)otherCards
 {
 int score = 0;
 if ([otherCards count] == 2)
 {
 NSMutableArray *numbers = [[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithInteger:self.number]]];
 NSMutableArray *symbols = [[NSMutableArray alloc] initWithArray:@[self.symbol]];
 NSMutableArray *shadings = [[NSMutableArray alloc] initWithArray:@[self.shading]];
 NSMutableArray *colors = [[NSMutableArray alloc] initWithArray:@[self.color]];
 
 for (id otherCard in otherCards) {
 if ([otherCard isKindOfClass:[SetCard class]]) {
 SetCard *otherSetCard = (SetCard *)otherCard;
 [numbers addObject:[NSNumber numberWithInteger:otherSetCard.number]];
 [symbols addObject:otherSetCard.symbol];
 [shadings addObject:otherSetCard.shading];
 [colors addObject:otherSetCard.color];
 }
 }
 
 if (([SetCard allEqual:numbers] || [SetCard allDifferent:numbers]) &&
 ([SetCard allEqual:symbols] || [SetCard allDifferent:symbols]) &&
 ([SetCard allEqual:shadings] || [SetCard allDifferent:shadings]) &&
 ([SetCard allEqual:colors] || [SetCard allDifferent:colors])) {
 score = MATCHSCORE;
 }
 }
 
 return score;
 }
 
 + (BOOL)allEqual:(NSArray *)features
 // input will either be an array of only numbers or only strings
 {
 BOOL result = NO;
 if ([features count] == 3) {
 switch ([self arrayCheck:features]) {
 case 1: // all ints
 result = features[0] == features[1] && features[0] == features[2];
 break;
 case 2: // all strings
 result = [features[0] isEqualToString:features[1]] && [features[0] isEqualToString:features[2]];
 break;
 default:
 break;
 }
 }
 
 return result;
 }
 
 + (BOOL)allDifferent:(NSArray *)features
 // input will either be an array of only numbers or only strings
 {
 BOOL result = NO;
 if ([features count] == 3) {
 switch ([self arrayCheck:features]) {
 case 1: // all ints
 result = features[0] != features[1] && features[0] != features[2] && features[1] != features[2];
 break;
 case 2: // all strings
 result = ![features[0] isEqualToString:features[1]] && ![features[0] isEqualToString:features[2]] && ![features[1] isEqualToString:features[2]];
 break;
 default:
 break;
 }
 }
 
 return result;
 }
 
 + (NSInteger)arrayCheck:(NSArray *)features
 // returns 1 if input array is all numbers
 // returns 2 if input array is all strings
 // returns 0 otherwise
 {
 BOOL numbers = YES;
 BOOL strings = YES;
 NSInteger result = 0;
 
 for (id feature in features) {
 if ([feature isKindOfClass:[NSNumber class]] && numbers) {
 strings = NO;
 } else if ([feature isKindOfClass:[NSString class]] && strings) {
 numbers = NO;
 } else {
 return result;
 }
 }
 
 if (numbers)
 result = 1;
 else if (strings)
 result = 2;
 
 return result;
 }
 */
