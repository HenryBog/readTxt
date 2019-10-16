//
//  XXBookListMainVC.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXBookListMainVC.h"

@interface XXBookListMainVC ()

@end

@implementation XXBookListMainVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 16;
        self.titleColorNormal = knormalColor;
        self.titleColorSelected = knormalColor;
        self.automaticallyCalculatesItemWidths = YES;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.preloadPolicy = WMPageControllerPreloadPolicyNear;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"周榜";
        case 1: return @"月榜";
        case 2: return @"总榜";
    }
    return @"NONE";
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSString *id = @"";
    switch (index % 3) {
        case 0:
            id = _id;
            break;
            
        case 1:
            id = _monthRank;
            break;
            
        case 2:
            id = _totalRank;
            break;
        default:
            break;
    }
    XXBookListVC *vc = [[XXBookListVC alloc] initWithType:_booklist_type id:id];
    return vc;
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = UIColorHex(#ecf0f6);
    return CGRectMake(0, 0, self.view.width, AdaWidth(40));
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.width, self.view.height - originY);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
