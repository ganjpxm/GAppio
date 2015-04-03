//
//  ObsBookingCompleteVC.m
//  ULOCR
//
//  Created by Johnny on 2/1/14.
//  Copyright (c) 2014 dbs. All rights reserved.
//

#import "ObsBookingCompleteVC.h"
#import "ObsConst.h"
#import "JpSystemUtil.h"
#import "JpUiUtil.h"
#import "ObsWebAPIClient.h"
#import "JpDataUtil.h"
#import "UIAlertView+AFNetworking.h"

@interface ObsBookingCompleteVC ()

@end

@implementation ObsBookingCompleteVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(id)init{
    self = [super init];
    if (self) {
        // Set the background color of the view.
        [self.view setBackgroundColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.7]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.screenName = SCREEN_BOOKING_COMPLETE;
    
    float screenWidth = [JpUiUtil getScreenWidth];
    float screenHeight = [JpUiUtil getScreenHeight];
    float viewHeight = 200;
    UIView  *dialogView = [[UIView alloc] init];
    dialogView.frame = CGRectMake(16, (screenHeight-viewHeight)/2 + [JpUiUtil getStartHeightOffset] - 50, screenWidth-32, viewHeight);
    dialogView.backgroundColor = [UIColor whiteColor];
    float viewWidth = dialogView.frame.size.width;
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, viewWidth, 30)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = @"Have completed the job?";
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    [dialogView addSubview:titleLabel];
    float y = titleLabel.frame.size.height + 24;
    
    tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, y, viewWidth, 20)];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    tipLabel.text = @"Please enter your claim amount : ";
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [dialogView addSubview:tipLabel];
    y += tipLabel.frame.size.height + 12;
    
    currencys= [[NSArray alloc]initWithObjects:@"SGD", @"MYR",nil];
    currencyTF = [[UITextField alloc]initWithFrame:CGRectMake(8, y, 60, 42)];
    currencyTF.borderStyle = UITextBorderStyleRoundedRect;
    currencyTF.delegate = self;
    currencyTF.text = @"SGD";
    [dialogView addSubview:currencyTF];
    currencyPV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, screenWidth, 480)];
    currencyPV.delegate = self;
    currencyPV.dataSource = self;
    [currencyPV setShowsSelectionIndicator:YES];
    currencyTF.inputView =  currencyPV;
    currencyPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 56)];
    currencyPickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [currencyPickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [currencyPickerToolbar setItems:barItems animated:YES];
    currencyTF.inputAccessoryView = currencyPickerToolbar;

    priceTF = [[UITextField alloc]initWithFrame:CGRectMake(currencyTF.frame.size.width+16, y, viewWidth-currencyTF.frame.size.width-24, 42)];
    priceTF.borderStyle = UITextBorderStyleRoundedRect;
    priceTF.delegate = self;
    [priceTF setKeyboardType:UIKeyboardTypeDecimalPad];
    [priceTF setReturnKeyType:UIReturnKeyDone];
    [dialogView addSubview:priceTF];
    y += currencyTF.frame.size.height + 12;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(8, y+3, (viewWidth-24)/2, 40);
    [cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor whiteColor]];
    [cancelBtn setBackgroundColor:[UIColor blackColor]];
    [dialogView addSubview:cancelBtn];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(cancelBtn.frame.size.width+16, y+3, (viewWidth-24)/2, 40);
    [okBtn addTarget:self action:@selector(onClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"Complete" forState:UIControlStateNormal];
    [okBtn setTintColor:[UIColor whiteColor]];
    [okBtn setBackgroundColor:[UIColor blackColor]];
    [dialogView addSubview:okBtn];
    
    [self.view addSubview:dialogView];
    //long titleLabelHeight = titleLabel.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Public methods
-(void)popupBookingItemDialog:(UIView *)targetView bookingItemId:(NSString *)bookingItemId currency:(NSString *)currency price:(NSString *)price {
    mCurrentBookingItemId = bookingItemId;

    [self.view setFrame:CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y, targetView.frame.size.width, targetView.frame.size.height)];
    
    if ([price length]>0 && ![@"0.0" isEqualToString:price]) {
        currencyTF.text = currency;
        priceTF.text = price;
        titleLabel.text = @"Change your claim amount";
        [okBtn setTitle:@"Submit" forState:UIControlStateNormal];
    }
    if ([currency length]>0 && [@"MYR" isEqualToString:currency]) {
        [currencyPV selectRow:1 inComponent:0 animated:YES];
        [currencyPV reloadComponent:0];
    } else {
        [currencyPV selectRow:0 inComponent:0 animated:YES];
        [currencyPV reloadComponent:0];
    }
    [targetView addSubview:self.view];
}

-(NSString*)removeBookingItemDialog{
    [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.25];
    return mCurrentBookingItemId;
}

-(NSString*)removeBookingItemDialogInstantly
{
    [self.view removeFromSuperview];
    return mCurrentBookingItemId;
}

- (IBAction)onClickOkBtn:(id)sender {
    NSString *price = priceTF.text;
    if ([price length]<1) {
        [JpUiUtil showAlertWithMessage:@"Please enter your claim amount first." title:@""];
        return;
    }
    NSString *userId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
    NSString *userName = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_NAME];
    NSDictionary *parameters = @{KEY_USER_ID: userId, KEY_USER_NAME: userName, KEY_BOOKING_VEHICLE_ITEM_ID: mCurrentBookingItemId, @"driverClaimCurrency": currencyTF.text, @"driverClaimPrice": price, @"deviceName": [JpSystemUtil getDeviceName]};
    
    [[ObsWebAPIClient sharedClient] POST:@"web/01/changeDriverClaim" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableDictionary *respondDic = responseObject;
        NSString *result = [respondDic valueForKey:KEY_RESULT];
        if ([result isEqualToString:VALUE_SUCCESS]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Limousine Transport" message:@"Success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alertView.tag = COMPLETE_SUCCESS;
            [alertView show];
        } else {
            [JpUiUtil showAlertWithMessage:@"Fail" title:@"Alert"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [JpUiUtil showAlertWithMessage:@"Fail" title:@"Alert"];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == COMPLETE_SUCCESS) {
        NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookingTableView" object:nil];
                [self.delegate delegateOkBtnEvent];
            } else {
                [JpUiUtil showAlertWithMessage:@"Refresh Fail" title:@"Alert"];
            }
        }];
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
}

- (IBAction)onClickCancelBtn:(id)sender {
    [self.delegate delegateCancelBtnEvent];
}

-(void)pickerDoneClicked
{
    [currencyTF resignFirstResponder];
    currencyPickerToolbar.hidden=YES;
    currencyPV.hidden=YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [currencys count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [currencys objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currencyTF.text = [currencys objectAtIndex:row];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == currencyTF) {
        currencyPickerToolbar.hidden=NO;
        currencyPV.hidden=NO;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == priceTF) {
        NSUInteger lengthOfString = string.length;
        for (NSInteger index = 0; index < lengthOfString; index++)
        {
            unichar character = [string characterAtIndex:index];
            if (character == 46) return YES;
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}


@end