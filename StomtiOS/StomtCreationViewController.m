//
//  StomtCreationViewController.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 21/01/2017.
//  Copyright © 2017 Leonardo Cascianelli. All rights reserved.
//

#import "StomtCreationViewController.h"
#import "Stomt.h"

@import WebKit;

@interface StomtCreationViewController () <WKNavigationDelegate>
@property (nonatomic,weak) WKWebView* webView;
@property (nonatomic,strong) WKUserContentController* contentController;
@property (nonatomic,strong) NSString* defaultText;
@property (nonatomic) kSTObjectQualifier likeOrWish;
@property (nonatomic,strong) NSString* identifier;
- (NSString*)craftString;
- (void)dismissViaButton:(UIBarButtonItem*)button;
- (void)setup;
- (void)handleStomtProcessComplete:(STObject*)stomt error:(NSError*)error;
@end

@implementation StomtCreationViewController

- (instancetype)initWithTargetID:(nonnull NSString*)identifier defaultText:(nullable NSString *)defaultText likeOrWish:(NSInteger)likeOrWish
{
    if((self = [super init]))
    {
        _defaultText = defaultText;
        _likeOrWish = (kSTObjectQualifier)likeOrWish;
        _identifier = identifier;
        _dismissOnSend = NO;
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Setup navigation item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self action:@selector(dismissViaButton:)];
    self.navigationItem.title = @"Feedback via STOMT";
    // --
    
}

- (NSString*)craftString
{
    NSMutableString* string;
    string = [NSMutableString stringWithFormat:@"%@/widget?to=%@",[[Stomt sharedInstance].apiURL stringByReplacingOccurrencesOfString:@"rest." withString:@""],_identifier];
    if(_defaultText){ [string appendFormat:@"&text=%@",_defaultText]; }
    if(_likeOrWish == kSTObjectLike){ [string appendFormat:@"&positive=%@",@"true"];}
    if([Stomt loggedUser]){ [string appendFormat:@"&access_token=%@",[Stomt loggedUser].accessToken]; }
    return string;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Setup message handler

    if(!_contentController)
        _contentController = [[WKUserContentController alloc] init];
    [_contentController addScriptMessageHandler:self name:@"notification"];
    
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = _contentController;
    // --
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:config];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    _webView = webView;

    NSString* string = [self craftString];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [_webView loadRequest:request];
}

- (void)dismissViaButton:(UIBarButtonItem*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    _webView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)handleStomtProcessComplete:(STObject *)stomt error:(NSError *)error
{
    if(_dismissOnSend){
        [self dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                _completion(error,stomt);
            });
        }];
        return;
        }
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViaButton:)];
    if(_completion)
        dispatch_async(dispatch_get_main_queue(), ^{
            _completion(error,stomt);
        });
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary* dict = [NSDictionary dictionaryWithDictionary:message.body];
    
    if(![dict objectForKey:@"event"] || ![dict objectForKey:@"stomt"])
        [self handleStomtProcessComplete:nil error:[NSError errorWithDomain:@"RESPONSE ERROR" code:400 userInfo:@{@"error":@"There has been a problem in the received dictionary. Please contact @h3xept for further details."}]];
    
    if([[message.body objectForKey:@"event"] isEqualToString:@"stomtCreated"]){
        [self handleStomtProcessComplete:[message.body objectForKey:@"stomt"] error:nil];
    }
}


@end
