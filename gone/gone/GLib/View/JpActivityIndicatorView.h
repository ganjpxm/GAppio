//
//  ActivityIndicatorView.h
//  obsc
//
//  Created by Johnny on 24/2/14.
//  Copyright (c) 2014 dbs. All rights reserved.
//

@interface JpActivityIndicatorView : UIView {
	NSString *_text;
    UIColor *_textColor;
    UIColor *_indicatorColor;
@private
	UIActivityIndicatorView *_activityIndicatorView;
	UILabel *_label;
	UIView *_superview;
    UIView *_mask;
}
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *indicatorColor;

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
								text:(NSString *)theText
                           textColor:(UIColor*)theTextColor
                      indicatorColor:(UIColor*)theIndicatorColor
						   superview:(UIView *)theSuperview;

@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle; // default is UIActivityIndicatorViewStyleWhite
@property(nonatomic) BOOL hidesWhenStopped; // default is YES. calls -setHidden when animating gets set to NO

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
