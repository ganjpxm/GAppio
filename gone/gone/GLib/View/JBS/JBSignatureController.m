//
//  JBSignatureController.m
//  JBSignatureController
//
//  Created on 12/10/11.
//  Copyright (c) 2013. All rights reserved.
//

#import "JBSignatureController.h"
#import "JBSignatureView.h"
#import "JpUiUtil.h"
#import "JpConst.h"
#import "JpSystemUtil.h"


#pragma mark - *** Private Interface ***

@interface JBSignatureController() {
@private
	__strong JBSignatureView *signatureView_;
	__strong UIImageView *signaturePanelBackgroundImageView_;
	__strong UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	__strong UIButton *confirmButton_, *cancelButton_, *clearButton_;
	__weak id<JBSignatureControllerDelegate> delegate_;
}

// The view responsible for handling signature sketching
@property(nonatomic,strong) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,strong) UIImageView *signaturePanelBackgroundImageView;

// Private Methods
-(void)didTapCanfirmButton;
-(void)didTapCancelButton;
-(void)didTapClearButton;

@end



@implementation JBSignatureController

@synthesize
signaturePanelBackgroundImageView = signaturePanelBackgroundImageView_,
signatureView = signatureView_,
portraitBackgroundImage = portraitBackgroundImage_,
landscapeBackgroundImage = landscapeBackgroundImage_,
confirmButton = confirmButton_,
cancelButton = cancelButton_,
clearButton = clearButton_,
delegate = delegate_;



#pragma mark - *** Initializers ***

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	}
	
	return self;
	
}

-(id)init {
	return [self initWithNibName:nil bundle:nil];
}




#pragma mark - *** View Lifecycle **
-(void)loadView {
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    NSInteger intHeightoffset;
    NSInteger buttonWidth, buttonHeight;
    buttonWidth = 100;
    buttonHeight = 80;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        intHeightoffset = 20;
    } else { intHeightoffset = 0; }
    NSInteger winHeight = [JpUiUtil getScreenHeight];
    
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	// Background images
	self.portraitBackgroundImage = [UIImage imageNamed:@"bg_signature_portrait"];
	self.signaturePanelBackgroundImageView = [[UIImageView alloc] initWithImage:self.portraitBackgroundImage];
    [self.signaturePanelBackgroundImageView sizeToFit];
    
    //UIImage *img = [UIImage imageNamed:@"bg_btn_red_normal"]; //[[UIImage alloc] init];
	//UIImage *imgtouch = [UIImage imageNamed:@"bg_btn_red_touch"];
    
	// Signature view
	self.signatureView = [[JBSignatureView alloc] init];
	
	// Confirm
	self.confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm_red"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"btn_confirm_red"] forState:UIControlStateHighlighted];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	[self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
	[self.confirmButton sizeToFit];

	[self.confirmButton setFrame:CGRectMake(self.view.frame.size.width - buttonWidth, winHeight + intHeightoffset - buttonHeight, buttonWidth+5, buttonHeight)];
	[self.confirmButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	
	// Cancel
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_cancel_red"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_cancel_red"] forState:UIControlStateHighlighted];
	//[self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[self.cancelButton sizeToFit];
	[self.cancelButton setFrame:CGRectMake(0, winHeight + intHeightoffset - buttonHeight, buttonWidth, buttonHeight)];
	[self.cancelButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    
    // Clear
	self.clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"btn_clear_red"] forState:UIControlStateNormal];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"btn_clear_red"] forState:UIControlStateHighlighted];
	//[self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
	[self.clearButton sizeToFit];
	[self.clearButton setFrame:CGRectMake((self.view.frame.size.width - buttonWidth) / 2 - 8,
										   winHeight + intHeightoffset - buttonHeight,
										   buttonWidth+16,
										   buttonHeight)];
	[self.clearButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    
}

/**
 * Setup the view heirarchy
 **/
-(void)viewDidLoad {
	
	// Background Image
    float startHeight = [JpUiUtil getStartHeightOffset];
    float width = self.view.bounds.size.width;
    float height = self.view.bounds.size.height + startHeight;
	[self.signaturePanelBackgroundImageView setFrame:CGRectMake(0,0,width,height)];
	[self.view addSubview:self.signaturePanelBackgroundImageView];
    
	
	// Signature View
//    CGRect frame = self.view.bounds; //208*95
    float signatureWidth = (height-110)*0.5;
    [self.signatureView setFrame:CGRectMake((width-signatureWidth)/2, startHeight, signatureWidth, height-110) ]; //448*205
	 
    [self.signatureView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:self.signatureView];
	
	// Buttons
	[self.view addSubview:self.cancelButton];
	[self.view addSubview:self.confirmButton];
    [self.view addSubview:self.clearButton];
	
	// Button actions
	[self.confirmButton addTarget:self action:@selector(didTapCanfirmButton) forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.clearButton addTarget:self action:@selector(didTapClearButton) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSLog(@"Landscape");
    }
    else {
        NSLog(@"Portrait");
    }
}

#pragma mark - *** Actions ***

/**
 * Upon confirmation, message the delegate with the image of the signature.
 * Peter Lum
 **/
-(void)didTapCanfirmButton {
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureConfirmed:signatureController:)]) {
		UIImage *signatureImage = [self.signatureView getSignatureImage];
        NSLog(@"width=%f, height=%f",signatureImage.size.width, signatureImage.size.height);
//        [self.delegate signatureConfirmed:signatureImage signatureController:self];
        if (signatureImage) {
            [self.delegate signatureConfirmed:signatureImage signatureController:self];
        } else {
//            [UiUtil showAlertWithMessage:@"Please signature." title:@"Alert"];
        }
		
	}
}

-(UIImage *)drawImage:(UIImage*)profileImage withBadge:(UIImage *)badge
{
    UIGraphicsBeginImageContextWithOptions(profileImage.size, NO, 0.0f);
    [profileImage drawInRect:CGRectMake(0, 0, profileImage.size.width, profileImage.size.height)];
    [badge drawInRect:CGRectMake(0, profileImage.size.height - badge.size.height, badge.size.width, badge.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

static inline double radians (double degrees) {
    return degrees * M_PI/180;
}
UIImage* rotate(UIImage* src, UIImageOrientation orientation)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}
/**
 * Upon cancellation, message the delegate.
 * Peter Lum
 **/
-(void)didTapCancelButton {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureCancelled:)]) {
		[self.delegate signatureCancelled:self];
	}
	
}

/**
 * Upon cancellation, message the delegate.
 * Peter Lum
 **/
-(void)didTapClearButton {
	
	[self.signatureView clearSignature];
	
}

#pragma mark - *** Public Methods ***

-(void)clearSignature {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureCleared:signatureController:)]) {
		UIImage *signatureImage = [self.signatureView getSignatureImage];
		[self.delegate signatureCleared:signatureImage signatureController:self];
	}
	
	[self.signatureView clearSignature];
}


@end
