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
	} else if ([otherCards count] == 2) {
		PlayingCard *otherCard1 = otherCards[0];
		PlayingCard *otherCard2 = otherCards[1];
		if ([self.suit isEqualToString:otherCard1.suit]
			&& [self.suit isEqualToString:otherCard2.suit]) {
			score = 6;
		} else if (self.rank == otherCard1.rank
					&& self.rank == otherCard2.rank){
			score = 24;
		}
	}

	return score;
}

@end