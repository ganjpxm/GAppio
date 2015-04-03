//
//  ObsBookingCompleteVC.h
//  OBS
//
//  Created by Johnny on 2/1/14.
//  Copyright (c) 2014 dbs. All rights reserved.
//

#import "JpVC.h"

@protocol ObsBookingCompleteVCDelegate
-(void)delegateCancelBtnEvent;
-(void)delegateOkBtnEvent;
@end


@interface ObsBookingCompleteVC : JpVC <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
    NSString* mCurrentBookingItemId;

    UITextField *currencyTF;
    UITextField *priceTF;
    UILabel *titleLabel;
    UILabel *tipLabel;
    UIButton *okBtn;
    
    NSArray *currencys;
    UIPickerView *currencyPV;
    UIToolbar *currencyPickerToolbar;
}
@property (nonatomic, retain) id<ObsBookingCompleteVCDelegate> delegate;

-(void)popupBookingItemDialog:(UIView *)targetView bookingItemId:(NSString *)bookingItemId currency:(NSString *)currency price:(NSString *)price;

-(NSString*)removeBookingItemDialog;
-(NSString*)removeBookingItemDialogInstantly;

- (IBAction)onClickOkBtn:(id)sender;
- (IBAction)onClickCancelBtn:(id)sender;


@end
