//
//  ViewController.m
//  gdemo
//
//  Created by ganjianping on 4/2/15.
//  Copyright (c) 2015 ganjp. All rights reserved.
//

#import "ViewController.h"
#import "JpUiUtil.h"
#import "JpSystemUtil.h"
#import "SimpleTableVC.h"
#import "JpApplication.h"
#import "NSString+Jp.h"
#import "JpDataUtil.h"
#import "CustomizeTableVC.h"

@interface ViewController ()

@property (nonatomic, assign) float scrollViewY;
@property (nonatomic, assign) BOOL  isFirstTime;
@property (nonatomic, assign) BOOL  isOrientationPortrait;

@property (nonatomic, strong) NSMutableDictionary  *titleNameAndItemsDic;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    _titleNameAndItemsDic = [@"userInterface:defaultTable,customizeTable,tableWithSection;setting:changeLang;" toDic];
    _isFirstTime = YES;
    _isOrientationPortrait = YES;
    _scrollViewY = PAGE_MARGIN_WIDTH;
    [self initUI];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self setTitle:[JpSystemUtil getLocalizedStr:@"IOS_DEMO"]];
    
    float screenWidth = [JpUiUtil getScreenWidth];
    float screenHeight = [JpUiUtil getScreenHeight];
    [self.view setBackgroundColor:COLOR_GRAY_LIGHT_PRIMARY];
    
    // ------------------------- create scrollview with subviews
    float scrollViewHeight = screenHeight - _scrollViewY;
    float scrollViewWidth = screenWidth - PAGE_MARGIN_WIDTH*2;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(PAGE_MARGIN_WIDTH, _scrollViewY, scrollViewWidth, scrollViewHeight);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    
    // -------- user interface
    int columns = 2;
    if (screenWidth<=320) {
        columns = 1;
    }
    float titleHeight = 40;
    float btnHeight = 40;
    float btnWidth = (scrollViewWidth-(columns+1)*PAGE_MARGIN_WIDTH) / columns;
    
    float frameCoordY = 0;
    for (NSString* titleName in _titleNameAndItemsDic) {
        float frameHeight = titleHeight + btnHeight + FRAME_MARGIN_WIDTH;
        UIView *frameView = [[UIView alloc] init];
        [frameView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel = [self getTitleLable:[JpSystemUtil getLocalizedStr:titleName] rectMake:CGRectMake(0, 0, scrollViewWidth, titleHeight)];
        [frameView addSubview:titleLabel];
        
        float btnCoordX = FRAME_MARGIN_WIDTH;
        float btnCoordY = titleHeight + FRAME_MARGIN_WIDTH;
        
        int itemCount = 1;
        NSString *itemsWithComma = [_titleNameAndItemsDic objectForKey:titleName];
        NSMutableArray *items = [itemsWithComma toArr];
        for (int i=0; i<[items count]; i++) {
            NSString *btnName = items[i];
            
            UIButton *itemBtn = [self getButton:[JpSystemUtil getLocalizedStr:btnName] rectMake:CGRectMake(btnCoordX, btnCoordY, btnWidth, btnHeight) action:[self getAction:btnName]];
            [frameView addSubview:itemBtn];
            btnCoordX += btnWidth + FRAME_MARGIN_WIDTH;
            if (itemCount % columns == 0) {
                btnCoordX = FRAME_MARGIN_WIDTH;
                frameHeight += btnHeight + FRAME_MARGIN_WIDTH;
                btnCoordY += btnHeight + FRAME_MARGIN_WIDTH;
            }
            itemCount++;
        }
        if (columns==1) {
            frameHeight -= btnHeight;
        } else {
            frameHeight += FRAME_MARGIN_WIDTH;
        }
        frameView.frame = CGRectMake(0, frameCoordY, scrollViewWidth, frameHeight);
        frameCoordY += frameHeight + FRAME_MARGIN_WIDTH;
        [_scrollView addSubview:frameView];
    }
    
    [self.view addSubview:_scrollView];
}

- (UILabel *) getTitleLable:(NSString *)title rectMake:(CGRect)rectMake
{
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:rectMake];
    titleLabel.backgroundColor=[JpApplication sharedManager].colorPrimary;
    titleLabel.textColor= [JpApplication sharedManager].colorFront;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    titleLabel.text= title;
    return titleLabel;
}

- (UIButton *) getButton:(NSString *)title rectMake:(CGRect)rectMake action:(SEL)action
{
    UIButton *demoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    demoBtn.frame = rectMake;
    demoBtn.layer.borderColor = [COLOR_DIVIDER CGColor];
    demoBtn.layer.borderWidth = 0.5;
    [demoBtn setTitle:title forState:UIControlStateNormal];
    [demoBtn setTitleColor:COLOR_PRIMARY_TEXT forState:UIControlStateNormal];
    [demoBtn setTitleColor:[JpApplication sharedManager].colorDarkPrimary forState:UIControlStateHighlighted];
    [demoBtn setBackgroundImage:[JpUiUtil imageWithColor:COLOR_GRAY_LIGHT_PRIMARY] forState:UIControlStateHighlighted];
    if (action) {
        [demoBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return demoBtn;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    if (device.orientation!=UIDeviceOrientationFaceUp && device.orientation!=UIDeviceOrientationFaceDown) {
        if (UIDeviceOrientationIsPortrait(device.orientation)) {
            _isOrientationPortrait = YES;
        }
        if (UIDeviceOrientationIsLandscape(device.orientation)) {
            _isOrientationPortrait = NO;
        }
        [self resetUi];
    }
}
- (void)resetUi
{
    [_scrollView removeFromSuperview];
    _scrollViewY = PAGE_MARGIN_WIDTH + self.navigationController.navigationBar.frame.size.height;
    if (_isOrientationPortrait) {
        _scrollViewY += [JpUiUtil getStartHeightOffset];
    }
    [self initUI];
}

//--------------------------------------- Button Method -----------------------------------
//userInterface:defaultTable,customizeTable,tableWithSection;setting:changeLang;
- (SEL)getAction:(NSString *)btnName
{
    if ([btnName isEqualToString:@"defaultTable"])
    {
        return @selector(goToSimpleTableVC);
    }
    else if ([btnName isEqualToString:@"customizeTable"])
    {
        return @selector(goToCustomizeTableVC);
    }
    else if ([btnName isEqualToString:@"changeLang"])
    {
        return @selector(changeLang);
    }
    else
    {
        return NULL;
    }
}


- (void)goToSimpleTableVC
{
    SimpleTableVC *simpleTableVC = [[SimpleTableVC alloc] init];
    [self.navigationController pushViewController:simpleTableVC animated:YES];
}
- (void)goToCustomizeTableVC
{
    CustomizeTableVC *customizeTableVC = [[CustomizeTableVC alloc] init];
    [self.navigationController pushViewController:customizeTableVC animated:YES];
}

- (void)changeLang
{
    NSString* lang = [JpSystemUtil getAppLanguage];
    if ([lang isEqualToString:VALUE_LANG_EN] )
    {
        [JpSystemUtil setAppLanguage:VALUE_LANG_ZH_HANS];
    }
    else
    {
        [JpSystemUtil setAppLanguage:VALUE_LANG_EN];
    }
    [self resetUi];
}

@end
