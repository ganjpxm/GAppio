//
//  JpViewController.h
//  JpSample
//
//  Created by Johnny on 23/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "GAITrackedViewController.h"

@interface JpVC : GAITrackedViewController<UIAlertViewDelegate>

- (UIViewController*)initWithNib;

/*
 * Obtain a class instance object from a string class name
 */
- (UIViewController*)getViewControllerWithClassName:(NSString*)theClassName;

/**
 *list all notification this view can receive
 *return: array of notification
 */
- (NSArray *)listNotificationInterests;

- (UIBarButtonItem *) getBackButtonItem;

@end
