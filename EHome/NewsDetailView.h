//
//  NewsDetailView.h
//  BeautyLife
//
//  Created by Seven on 14-8-15.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailView : UIViewController
{
    UIWebView *phoneCallWebView;
}

@property (weak, nonatomic) News *news;
@property int catalog;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
