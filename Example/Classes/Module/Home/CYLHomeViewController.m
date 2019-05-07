//
//  CYLHomeViewController.m
//  CYLTabBarController
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2018 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLHomeViewController.h"
//#import "CYLTabBarControllerConfig.h"
//#import "CYLPlusButtonSubclass.h"
#import "MainTabBarController.h"
#import "CYLMainRootViewController.h"

#import "CYLDetailsViewController.h"

@implementation CYLHomeViewController 

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"书架";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh TabBar" style:UIBarButtonItemStylePlain target:self action:@selector(refreshTabBar:)];
}

//- (void)refreshTabBar:(id)sender {
//    [self createNewTabBardynamically];
//}

//- (void)createNewTabBar {
//    id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
//    UIWindow *window = delegate.window;
//    CYLMainRootViewController *rootController = (CYLMainRootViewController *)window.rootViewController;
//    [rootController createNewTabBar];
//}

//- (void)createNewTabBardynamically {
//    id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
//    UIWindow *window = delegate.window;
//    CYLMainRootViewController *rootController = (CYLMainRootViewController *)window.rootViewController;
//    [rootController createNewTabBar];
//}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ Controller Cell %@", self.tabBarItem.title, @(indexPath.row)]];
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([navigationController.viewControllers count] == 1) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *badgeNumber = @(indexPath.row);
    self.navigationItem.title = [NSString stringWithFormat:@"首页(%@)", badgeNumber]; //sets navigation bar title.
    
//    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", badgeNumber]];
    
//    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
//    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
//    tabBarController.delegate = self;
//
    [self cyl_showBadgeValue:[NSString stringWithFormat:@"%@", @(indexPath.row)] animationType:CYLBadgeAnimationTypeScale];
    [self pushToNewViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self pushToNewViewController];
}

- (void)pushToNewViewController {
    CYLDetailsViewController *viewController = [CYLDetailsViewController new];
    viewController.view.backgroundColor = [UIColor orangeColor];
    [viewController cyl_setNavigationBarHidden:YES];
    [self.navigationController  pushViewController:viewController animated:YES];
}

@end
