//
//  JBSignatureController.h
//  JBSignatureController
//
//  Created on 12/10/11.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JBSignatureControllerDelegate;



@interface JBSignatureController : UIViewController

// Allows you to set th background images in different states
@property(nonatomic,strong) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;

// Buttons for confirm and cancel
@property(nonatomic,strong) UIButton *confirmButton, *cancelButton, *clearButton;

// Delegate
@property(nonatomic,weak) id<JBSignatureControllerDelegate> delegate;

// Clear the signature
-(void)clearSignature;

@end



// Delegate Protocol
@protocol JBSignatureControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(JBSignatureController *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(JBSignatureController *)sender;

@end