//
//  TipCalculator.h
//  TipCalculator
//
//  Created by Cay Cornelius on 16/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipCalculator : NSObject

-(NSString *)calculateTip:(NSString *)billAmountInput withPercentage:(NSString *)percentageInput;

@end
