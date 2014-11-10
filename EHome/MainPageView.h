//
//  MainPageView.h
//  BeautyLife
//
//  Created by Seven on 14-7-29.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StewardFeeFrameView.h"
#import "RepairsFrameView.h"
#import "NoticeFrameView.h"
#import "ExpressView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "ADVDetailView.h"
#import "Advertisement2.h"
#import "CommunityView.h"

@interface MainPageView : UIViewController<SGFocusImageFrameDelegate, UIActionSheetDelegate>
{
    NSMutableArray *advDatas;
    SGFocusImageFrame *bannerView;
    int advIndex;
    
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *advIv;
@property (weak, nonatomic) IBOutlet UILabel *xiaoquLb;

#pragma mark -按钮点击事件

- (IBAction)ggzyAction:(id)sender;

- (IBAction)wyfwAction:(id)sender;
- (IBAction)wytzAction:(id)sender;
- (IBAction)yzscAction:(id)sender;
- (IBAction)sqltAction:(id)sender;
- (IBAction)lmsjAction:(id)sender;
- (IBAction)sqswAction:(id)sender;
- (IBAction)bmfwAction:(id)sender;
- (IBAction)tjjxAction:(id)sender;
- (IBAction)cydhAction:(id)sender;
- (IBAction)grzxAction:(id)sender;

@end
