//
//  ViewController.m
//  TipCalculator
//
//  Created by Cay Cornelius on 16/09/16.
//  Copyright © 2016 Cornelius.Media. All rights reserved.
//

#import "ViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;

@property (nonatomic, strong) TipCalculator *tipCalculator;

@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;

@property (weak, nonatomic) IBOutlet UITextField *tipPercentageTextField;
@property (weak, nonatomic) IBOutlet UISlider *tipPercentageSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tipCalculator = [[TipCalculator alloc] init];
    
    UIToolbar* numberToolbarBillAmount = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarBillAmount.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarBillAmount.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPadBillAmount)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadBillAmount)]];
    [numberToolbarBillAmount sizeToFit];
    self.billAmountTextField.inputAccessoryView = numberToolbarBillAmount;
    
    UIToolbar* numberToolbarTipPercentage = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarTipPercentage.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarTipPercentage.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPadTipPercentage)],
                                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                      [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadTipPercentage)]];
    [numberToolbarTipPercentage sizeToFit];
    self.tipPercentageTextField.inputAccessoryView = numberToolbarTipPercentage;
    
    [self.billAmountTextField addTarget:self action:@selector(billAmountTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.tipPercentageTextField addTarget:self action:@selector(tipPercentageTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.tipPercentageSlider addTarget:self action:@selector(tipPercentageSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.billAmountTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (IBAction)calculateTip:(UIButton *)sender {
    self.tipAmountLabel.text = [self.tipCalculator calculateTip:self.billAmountTextField.text withPercentage:self.tipPercentageTextField.text];
}
- (IBAction)adjustTipPercentage:(UISlider *)sender {
    self.tipPercentageTextField.text = [NSString stringWithFormat:@"%.0f", sender.value];
}
- (IBAction)enterTipPercentage:(UITextField *)sender {
    self.tipPercentageSlider.value = [sender.text floatValue];
}

-(void)cancelNumberPadBillAmount{
    [self.billAmountTextField resignFirstResponder];
    self.billAmountTextField.text = @"";
}

-(void)doneWithNumberPadBillAmount{
    [self.billAmountTextField resignFirstResponder];
}

-(void)cancelNumberPadTipPercentage{
    [self.tipPercentageTextField resignFirstResponder];
    self.tipPercentageTextField.text = @"";
}

-(void)doneWithNumberPadTipPercentage{
    [self.tipPercentageTextField resignFirstResponder];
}

- (void)billAmountTextFieldDidChange:(UITextField *)textField {
    self.tipAmountLabel.text = [self.tipCalculator calculateTip:self.billAmountTextField.text withPercentage:self.tipPercentageTextField.text];
}

- (void)tipPercentageTextFieldDidChange:(UITextField *)textField {
    self.tipPercentageSlider.value = [self.tipPercentageTextField.text floatValue];
    self.tipAmountLabel.text = [self.tipCalculator calculateTip:self.billAmountTextField.text withPercentage:self.tipPercentageTextField.text];
}

- (void)tipPercentageSliderDidChange:(UISlider *)slider {
    self.tipPercentageTextField.text = [NSString stringWithFormat:@"%.0f", self.tipPercentageSlider.value];
    self.tipAmountLabel.text = [self.tipCalculator calculateTip:self.billAmountTextField.text withPercentage:self.tipPercentageTextField.text];
}

@end
