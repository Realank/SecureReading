//
//  ViewController.m
//  SecureReading
//
//  Created by Realank on 16/8/26.
//  Copyright © 2016年 Realank. All rights reserved.
//

#import "ViewController.h"
#import "CoverView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CoverView *view = [CoverView coverViewWithFrame:self.view.bounds];

    [self.navigationController.view addSubview:view];
    [self loadContent:nil];

}


- (IBAction)loadContent:(id)sender {
    
    NSString* url = _urlTextField.text;
    if (url.length <= 0) {
        url = @"https://www.baidu.com";
    }
    if (!([[url lowercaseString] hasPrefix:@"http://"]||[[url lowercaseString] hasPrefix:@"https://"])) {
        url = [@"http://" stringByAppendingString:url];
    }
    [self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (IBAction)hideKeyboard:(id)sender {
    [self.navigationController.view endEditing:YES];
    [self.view endEditing:YES];
    [self.urlTextField resignFirstResponder];
}

- (IBAction)backwardContent:(id)sender {
    [self.contentWebView goBack];
}
- (IBAction)forwardContent:(id)sender {
    [self.contentWebView goForward];
}





@end
