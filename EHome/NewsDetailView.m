//
//  NewsDetailView.m
//  BeautyLife
//
//  Created by Seven on 14-8-15.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "NewsDetailView.h"

@interface NewsDetailView ()

@end

@implementation NewsDetailView
@synthesize news;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"head_back"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
        
        UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 26)];
        [rBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [rBtn setImage:[UIImage imageNamed:@"conv_order_share"] forState:UIControlStateNormal];
        UIBarButtonItem *btnShare = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
        self.navigationItem.rightBarButtonItem = btnShare;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction:(id)sender
{
    NSDictionary *contentDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.news.summary, @"title",
                                self.news.summary, @"summary",
                                nil, @"thumb",
                                nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"详情";
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    NSString *detailUrl = [NSString stringWithFormat:@"%@%@?APPKey=%@&id=%@", api_base_url, api_getnoticeinfo, appkey, news.id];
    NSURL *url = [ NSURL URLWithString : detailUrl];
    // 构造 ASIHTTPRequest 对象
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    // 开始同步请求
    [request startSynchronous ];
    NSError *error = [request error ];
    assert (!error);
    // 如果请求成功，返回 Response
    NSString *response = [request responseString ];
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSString *content;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    if (json) {
        content = [json objectForKey:@"content"];
    }
    //WebView的背景颜色去除
    [Tool clearWebViewBackground:self.webView];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView sizeToFit];
    
    NSString *html = [NSString stringWithFormat:@"<body>%@<div id='web_title'>%@</div>%@<div id='web_body'>%@</div></body>", HTML_Style, news.title, HTML_Splitline, content];
    NSString *result = [Tool getHTMLString:html];
    [self.webView loadHTMLString:result baseURL:nil];
    
    self.webView.opaque = YES;
    for (UIView *subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)subView).bounces = YES;
        }
    }
    
    self.view.backgroundColor = [Tool getBackgroundColor];
    //适配iOS7uinavigationbar遮挡的问题
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
