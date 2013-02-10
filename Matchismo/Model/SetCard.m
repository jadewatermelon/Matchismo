//
//  SetCard.m
//  Matchismo
//
//  Created by Tom Billings on 10/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // add matching logic later
    
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

+ (NSUInteger)maxNumber
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
