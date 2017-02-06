//
//  StomtCreationNavigationController.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 06/02/2017.
//  Copyright © 2017 Leonardo Cascianelli. All rights reserved.
//

#import "StomtCreationNavigationController.h"

@interface StomtCreationNavigationController ()

@end

@implementation StomtCreationNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.presentedViewController != nil) {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
