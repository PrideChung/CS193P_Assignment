//
//  PlayingCard.m
//  Assignment1_Matchismo
//
//  Created by 钟 子豪 on 13-2-1.
//  Copyright (c) 2013年 Pride Chung. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)contents
{
	return [[PlayingCard ranStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)ranStrings
{
	static NSArray *rankStrings;
	if (!rankStrings) {
		rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
	}
	return rankStrings;
}

+ (NSUInteger)maxRank
{
	return [PlayingCard ranStrings].count-1;
}

+ (NSArray *)validSuits
{
	static NSArray *validSuits;	
	if (!validSuits) validSuits = @[@"♦",@"♣",@"♥",@"♠"];
	return validSuits;
}

- (void)setSuit:(NSString *)suit
{
	if ([[PlayingCard validSuits] containsObject:suit]) {
		_suit = suit;
	}
}

- (NSString *)suit
{
	return _suit ? _suit : @"?";
}

- (int)match:(NSArray *)otherCards
{
	int score = 0;
	if ([otherCards count] == 1) {
		PlayingCard *otherCard = [otherCards lastObject];
		if ([otherCard.suit isEqualToString:self.suit]) {
			score = 1;
		} else if (otherCard.rank == self.rank){
			score = 4;
		}
		
	}

	return score;
}

@end