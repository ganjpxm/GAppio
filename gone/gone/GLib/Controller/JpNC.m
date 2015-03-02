//
//  JpNC.m
//  JpSample
//
//  Created by Johnny on 23/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpNC.h"
#import "JpConst.h"
#import "JpSystemUtil.h"
#import "UIButton+Jp.h"

@interface JpNC ()

@end

@implementation JpNC

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
//        UINavigationBar *navBar s= [self navigationBar];
        
//        UIButton *backButton = [UIButton createButtonWithTitle:@"" x:0 y:0 width:50 height:44 target:self action:@selector(onClickBackBtn:) imgName:@"icon_back_white" bgImgName:Nil bgPressImgName:Nil bgColor:Nil titleColor:Nil font:Nil tag:1 isEnable:TRUE isHidden:NO];
//        [backButton setTintColor:COLOR_GREEN];
//        [backButton setTitle:@"Back" forState:UIControlStateNormal];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        //icon_back_white
        
        [JpSystemUtil setNavAndStatusbarStytle:self];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}


@end
