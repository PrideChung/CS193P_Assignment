//
//  Card.m
//  Assignment1_Matchismo
//
//  Created by 钟 子豪 on 13-2-1.
//  Copyright (c) 2013年 Pride Chung. All rights reserved.
//

#import "Card.h"

@interface Card ()

@end

@implementation Card

- (int)match:(NSArray *)otherCards
{
	int score = 0;
	
	for (Card *otherCard in otherCards) {
		if ([otherCard.contents isEqualToString:self.contents]) {
			score =1;
		}
	}

	return score;
}

@end
