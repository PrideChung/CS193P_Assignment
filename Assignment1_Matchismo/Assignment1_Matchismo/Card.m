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

- (int)match:(Card *)otherCards
{
	int score = 0;
	
	if ([otherCards.contents isEqualToString:self.contents]) {
		score =1;
	}
	return score;
}

@end
