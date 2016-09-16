//
//  ViewController.m
//  TipCalculator
//
//  Created by Cay Cornelius on 16/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;

@property (nonatomic, strong) TipCalculator *tipCalculator;

@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;

@property (weak, nonatomic) IBOutlet UITextField *tipPercentageTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tipCalculator = [[TipCalculator alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)calculateTip:(UIButton *)sender {
    self.tipAmountLabel.text = [self.tipCalculator calculateTip:self.billAmountTextField.text withPercentage:self.tipPercentageTextField.text];
}

@end
