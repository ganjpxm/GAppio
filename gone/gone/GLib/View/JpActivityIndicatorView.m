//
//  JpActivityIndicatorView.m
//  JpLib
//
//  Created by Johnny on 24/2/14.
//  Copyright (c) 2014 dbs. All rights reserved.
//

#import "JpActivityIndicatorView.h"

// =================================
// = Interface for private methods
// =================================
@interface JpActivityIndicatorView (private)

- (void)setGearSizes;
- (void)restyleTextLabel: (UIColor*)theTextColor indicatorColor:(UIColor*) theIndicatorColor;

@end

static CGFloat smallGearSize;
static CGFloat largeGearSize;


// =====================================
// = Implementation of public methods
// =====================================
@implementation JpActivityIndicatorView

@synthesize activityIndicatorViewStyle;
@synthesize hidesWhenStopped;
@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize indicatorColor = _indicatorColor;

//
//  initWithActivityIndicatorStyle:text:superview
//
//  Initializes and returns a customized activity-indicator object
//
- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
								text:(NSString *)theText
                           textColor:(UIColor*)theTextColor
                      indicatorColor:(UIColor*)theIndicatorColor
						   superview:(UIView *)theSuperview
//
//  Parameters:
//  style
//      A constant that specifies the style of the object to be created. See UIActivityIndicatorStyle
//      for descriptions of the style constants
//  text
//      The indicator's text, to be displayed in a label next to the gear. If nil, "Loading" is displayed.
//  superview
//      The view to which is activity indicator will be added as subview. Should be a UIView or subclass thereof
//
//  Return Value
//  An initialized QcActivityIndicatorView object or nil if the object couldn’t be created or no superview
//  was specified.
//
//  Discussion
//  QcActivityIndicatorView sizes the returned instance according to the specified style. You can set
//  and retrieve the style of a activity indicator through the activityIndicatorViewStyle property. It also
//  centers it within the superview and styles the text based on the indicator style. You can also set
//  and retrieve the text through its properties.
//
{
	if (theSuperview == nil) {
		return nil;
	} else {
		_superview = theSuperview;
	}
    
    self = [super init];
    if (self) {
        // Initialization code.
        // Peter add for mask
        //_mask = [[UIView alloc] initWithFrame:_superview.frame];
        //_mask.backgroundColor = [UIColor blackColor];
        //_mask.alpha = 0.5;
        //[_superview addSubview:_mask];
        
		self.frame = CGRectMake(0, 0, 300, 65);
		self.center = CGPointMake(_superview.frame.size.width/2, _superview.frame.size.height/2);
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8;
        
		[_superview addSubview:self];
		
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        //[_activityIndicatorView setColor: [UIColor redColor]];
		[self addSubview:_activityIndicatorView];
		
		_label = [[UILabel alloc] init];
		// Don't worry about the frame size right now; it'll soon be resized
		_label.frame = CGRectMake(0, 0, 300, 65);
		_label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        _label.textAlignment = NSTextAlignmentCenter; // UITextAlignmentLeft;
        //_label.lineBreakMode = NO;
        _label.numberOfLines = 0;
		_label.hidden = YES;
		[self addSubview:_label];
        
    	[self restyleTextLabel:theTextColor indicatorColor:theIndicatorColor];
		[self setText:theText]; // calling this will also ensure layoutSubviews is called
		[self setGearSizes];
	}
    return self;
}

//
//  setText:
//
//  Override synthesized setter so that we can set a default string, truncate if needed, as well as call layoutSubviews
//
- (void)setText:(NSString *)theText  {
	_text = theText;
	if (_text == nil || [_text length] == 0) {
		// Text is empty; set a default string
		_text = NSLocalizedString(@"Loading",@"Loading");
	}
	else {
		// Text is too long; truncate it
		if (_text.length > 180) {
			_text = [self.text substringToIndex:180];
		}
	}
	
	// Now that the text is changed, we need to propgate to _label and realign things
	[self layoutSubviews];
}

#pragma mark -
#pragma mark Emulating UIActivityIndicatorView Methods

- (void)setHidesWhenStopped:(BOOL)hides {
	[_activityIndicatorView setHidesWhenStopped:hides];
	if (!hides) {
		_label.hidden = NO;
        self.hidden = NO;
	} else {
		_label.hidden = YES;
        self.hidden = YES;
	}
	
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style {
	[_activityIndicatorView setActivityIndicatorViewStyle:style];
	
	// we need to resize the frame for the gear since there is seemingly a bug that
	// resetting the style doesn't resize the frame as well
	if (style == UIActivityIndicatorViewStyleWhiteLarge) {
		_activityIndicatorView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, largeGearSize, largeGearSize);
	} else {
		_activityIndicatorView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, smallGearSize, smallGearSize);
	}
	// If the style has changed, we should adjust the styling of the textLabel as well
	//[self restyleTextLabel];
	[self restyleTextLabel:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0] indicatorColor:[UIColor colorWithRed:1.7 green:1.0 blue:1.0 alpha:1.0]];
    // And then we should realign it
	[self layoutSubviews];
}

- (void)startAnimating {
	[_activityIndicatorView startAnimating];
	
	_label.hidden = NO;
    self.hidden = NO;
}

- (void)stopAnimating {
	[_activityIndicatorView stopAnimating];
	
	if (_activityIndicatorView.hidesWhenStopped) {
		_label.hidden = YES;
        self.hidden = YES;
	}
}

- (BOOL)isAnimating
{
	return [_activityIndicatorView isAnimating];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// No sense doing all this if _label has not been instantiated yet
	if (_label != nil) {
		_label.text = [NSString stringWithFormat:@"%@", self.text]; // add dots
		[_label sizeToFit];
		// Calculate the new width for our subviews with gear, 5px spacer and UILabel
		CGFloat totalWidth = _activityIndicatorView.frame.size.width + 5.0 + _label.frame.size.width;
		// Realign the gear to be left-aligned in the view
		_activityIndicatorView.center = CGPointMake(self.frame.size.width/2.0 - totalWidth/2.0 + _activityIndicatorView.frame.size.width/2.0, self.frame.size.height/2.0);
		// Realign the textLabel to butt against the gear but with a 5px gap, also vertically aligned within the view
		_label.center = CGPointMake(self.frame.size.width/2.0 + _activityIndicatorView.frame.size.width/2.0 + 5.0, self.frame.size.height/2.0);
	}
}

@end

// =====================================
// = Implementation of private methods
// =====================================

@implementation JpActivityIndicatorView (private)

//
// setGearSizes
//
// Set the static vars for the gear sizes, based on what they would be if instantiated
//
- (void)setGearSizes {
	UIActivityIndicatorView *smallGear = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	smallGearSize = smallGear.frame.size.width;
	UIActivityIndicatorView *largeGear = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	largeGearSize = largeGear.frame.size.width;
}

//
// restyleTextLabel
//
// Based on the activityIndicatorViewStyle, restyle the textLabel accordingly
//
- (void)restyleTextLabel: (UIColor*)theTextColor indicatorColor:(UIColor*) theIndicatorColor{
	if (_activityIndicatorView.activityIndicatorViewStyle == UIActivityIndicatorViewStyleWhiteLarge) {
		// _label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]*1.33];
	} else {
		// _label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]*0.9];
	}
	
	if (_activityIndicatorView.activityIndicatorViewStyle == UIActivityIndicatorViewStyleGray) {
		_label.textColor = theIndicatorColor;
        //_label.textColor = [UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:1.0];
		_label.shadowColor = [UIColor whiteColor];
		_label.shadowOffset = CGSizeMake(0, 1);
	} else {
		_label.textColor = theTextColor;
        //_label.textColor = [UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:1.0];
		_label.shadowColor = [UIColor clearColor];
		_label.shadowOffset = CGSizeMake(0, 0);
	}
}

@end
