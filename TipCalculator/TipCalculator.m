//
//  TipCalculator.m
//  TipCalculator
//
//  Created by Cay Cornelius on 16/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "TipCalculator.h"

@implementation TipCalculator

-(NSString *)calculateTip:(NSString *)billAmountInput withPercentage:(NSString *)percentageInput {
    float tipPercentage = [percentageInput floatValue];
    float tip = [billAmountInput floatValue] * tipPercentage / 100;
    NSString *tipString = [NSString stringWithFormat:@"$ %.1f", tip];
    return tipString;
}

@end
