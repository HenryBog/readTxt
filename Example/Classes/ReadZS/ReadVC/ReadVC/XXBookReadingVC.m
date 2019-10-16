//
//  XXBaseBookReadingVC.m
//  Novel
//
//  Created by app on 2018/1/20.
//  Copyright © 2018年 th. All rights reserved.
//

#define SpaceWith kScreenWidth / 3
#define SpaceHeight kScreenHeight / 3
#define kShowMenuDuration 0.3f

#import "XXBookReadingVC.h"
#import "XXBookContentVC.h"
#import "XXBookMenuView.h"
#import "XXDirectoryVC.h"
#import "XXSummaryVC.h"
#import "XXDatabase.h"
#import "XXBookModel.h"
#import "XXReadSettingVC.h"
#import "XXBookReadingBackViewController.h"

@interface XXBookReadingVC () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) XXBookMenuView *menuView;

/** 判断是否是下一章，否即上一章 */
@property (nonatomic, assign) BOOL ispreChapter;

/** 是否显示状态栏 */
@property (nonatomic, assign) BOOL hiddenStatusBar;

/** 是否更换源 */
@property (nonatomic, assign) BOOL isReplaceSummary;

/* 点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) BOOL isTaping;

@property (nonatomic, strong) XXBookContentVC *currentReadPage;

@end

@implementation XXBookReadingVC


- (instancetype)initWithBookId:(NSString *)bookId bookTitle:(NSString *)bookTitle summaryId:(NSString *)summaryId {
    if (self = [super init]) {
        [kReadingManager clear];
        kReadingManager.bookId = bookId;
        kReadingManager.title = bookTitle;
        kReadingManager.summaryId = summaryId;
        kReadingManager.isSave = YES;
        
        XXBookModel *book = [kDatabase getBookWithId:bookId];
        if (book) {
            //查询是否已经加入书架
            kReadingManager.chapter = book.chapter;
            kReadingManager.page = book.page;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}


//进入后台 保存下进度
- (void)onApplicationWillResignActive {
    if (_pageViewController && kReadingManager.isSave == YES) {
        ReadingManager *manager = [ReadingManager shareReadingManager];
        XXBookModel *model = [kDatabase getBookWithId:manager.bookId];
        if (manager.transitionStyle == kTransitionStyle_Scroll) {
            //左右滑动
            XXBookContentVC *firstVc = [self.pageViewController.viewControllers firstObject];
            model.page = firstVc.page;
            model.chapter = firstVc.chapter;
        }
        else {
            model.page = manager.page;
            model.chapter = manager.chapter;
        }
        
        model.updateStatus = NO;
        [kDatabase updateBook:model];
    }
}


#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden {
    return _hiddenStatusBar;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    BookSettingModel *setMd = [BaseModel decodeModelWithKey:NSStringFromClass([BookSettingModel class])];
//    if (setMd.isLandspace) {
//        [kReadingManager allowLandscapeRight:YES];
//    }
    
//    [UIViewController attemptRotationToDeviceOrientation];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = NO;
    
    [self requestDataWithShowLoading:YES];
}


- (void)setupViews {
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap:)];
    _tap.numberOfTapsRequired = 1;
    _tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tap];
    _tap.delegate = self;
    
    [self pageViewController];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.menuView]) {
        return NO;
    }
    return YES;
}


#pragma mark - 开始进来处理下网络或者缓存
- (void)requestDataWithShowLoading:(BOOL)show {
    if (show) {
        [HUD showProgress:nil inView:self.view];
    }

    MJWeakSelf;
    [self requestSummaryWithComplete:^{
        
        [weakSelf requestChaptersWithComplete:^{
            
            [weakSelf requestContentWithComplete:^{
                [HUD hide];
                //初始化显示控制器
                [weakSelf.pageViewController setViewControllers:@[[weakSelf getpageBookContent]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }];
        }];
    }];
}


#pragma mark - 请求源头列表
- (void)requestSummaryWithComplete:(void(^)(void))complete {
    
    MJWeakSelf;
    
    if (kReadingManager.summaryId.length > 0) {
        
        complete();
        
    } else {
        //如果没有加入书架的就会没有源id 需要请求一遍拿到源id,然后请求目录数组->再请求第一章
        [kReadingManager requestSummaryCompletion:^{
            
            //请求完成
            if (kReadingManager.summaryId.length == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️" message:@"当前书籍没有源更新!" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    weakSelf.hiddenStatusBar = NO;
                    [weakSelf setNeedsStatusBarAppearanceUpdate];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    
                }]];
                
                [weakSelf presentViewController:alert animated:YES completion:^{
                    [HUD hide];
                }];
            } else {
                //有源id
                complete();
            }
            
        } failure:^(NSString *error) {
            [HUD hide];
            [HUD showError:error inview:weakSelf.view];
        }];
    }
    
}


#pragma mark - 请求小数目录数组
- (void)requestChaptersWithComplete:(void(^)(void))complete {
    
    MJWeakSelf
    [kReadingManager requestChaptersWithUseCache:!self.isReplaceSummary completion:^{
        if (weakSelf.isReplaceSummary) {
            //已经更换了源ID 弹出目录让用户选择
            if (kReadingManager.chapter > kReadingManager.chapters.count - 1) {
                //如果上次读的章节数大于当前源的总章节数
                kReadingManager.chapter = kReadingManager.chapters.count - 1;
            }
            weakSelf.isReplaceSummary = NO;
            //保存下进度
            XXBookModel *model = [kDatabase getBookWithId:kReadingManager.bookId];
            model.chapter = kReadingManager.chapter;
            model.page = kReadingManager.page;
            model.summaryId = kReadingManager.summaryId;
            [kDatabase updateBook:model];
            
            dispatch_async_on_main_queue(^{
                [weakSelf showDirectoryVCWithIsReplaceSummary:YES];
            });
        } else {
            complete();
        }
    } failure:^(NSString *error) {
        [HUD hide];
        [HUD showError:error inview:weakSelf.view];
    }];
}


#pragma mark - 请求小说内容
- (void)requestContentWithComplete:(void(^)(void))complete {
    
    MJWeakSelf;
    [kReadingManager requestContentWithChapter:kReadingManager.chapter ispreChapter:weakSelf.ispreChapter Completion:^{
        complete();
    } failure:^(NSString *error) {
        [HUD hide];
    }];
}


#pragma mark - UIPageViewControllerDelegate
/*
 self.pageViewController setViewControllers:<#(nullable NSArray<UIViewController *> *)#> direction:<#(UIPageViewControllerNavigationDirection)#> animated:<#(BOOL)#> completion:<#^(BOOL finished)completion#>
 animated:NO 是不走这个方法的
 */
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        XXBookContentVC *readerPageVC = (XXBookContentVC *)previousViewControllers.firstObject;
        kReadingManager.page = readerPageVC.page;
        kReadingManager.chapter = readerPageVC.chapter;
    } else {
        XXBookContentVC *readPageVC = (XXBookContentVC *)pageViewController.viewControllers.firstObject;
        kReadingManager.page = readPageVC.page;
        kReadingManager.chapter = readPageVC.chapter;
    }
    _isTaping = NO;
}


#pragma mark - UIPageViewControllerDataSource

//上一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (_isTaping) {
        return nil;
    }
    
    if (kReadingManager.chapter == 0 && kReadingManager.page == 0) {
        [HUD showMsgWithoutView:@"已经是第一页了!"];
        return nil;
    }
    
    if ((kReadingManager.transitionStyle == kTransitionStyle_PageCurl || kReadingManager.transitionStyle == kTransitionStyle_default) && [viewController isKindOfClass:XXBookContentVC.class]) {
        XXBookReadingBackViewController *vc = [[XXBookReadingBackViewController alloc] init];
        [vc updateWithViewController:viewController];
        return vc;
    }
    
    if (kReadingManager.page > 0) {
        kReadingManager.page--;
        NSLog(@"点击了上一页chapter=%ld page=%ld", kReadingManager.chapter, kReadingManager.page);
        return [self getpageBookContent];
    } else {
        kReadingManager.chapter--;
        _ispreChapter = YES;
        NSLog(@"点击了上一页chapter=%ld page=%ld", kReadingManager.chapter, kReadingManager.page);
        return [self getChapterBookContent];
    }
}


//下一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (_isTaping) {
        return nil;
    }
    
    if (kReadingManager.page == [kReadingManager.chapters.lastObject pageCount] - 1 && kReadingManager.chapter >= kReadingManager.chapters.count - 1) {
        [HUD showMsgWithoutView:@"已经是最后一页了!"];
        return nil;
    }
    
    if ((kReadingManager.transitionStyle == kTransitionStyle_PageCurl || kReadingManager.transitionStyle == kTransitionStyle_default) && [viewController isKindOfClass:XXBookContentVC.class]) {
        XXBookReadingBackViewController *vc = [[XXBookReadingBackViewController alloc] init];
        [vc updateWithViewController:viewController];
        return vc;
    }
    
    if (kReadingManager.page >= [kReadingManager.chapters[kReadingManager.chapter] pageCount] - 1) {
        kReadingManager.page = 0;
        kReadingManager.chapter++;
        _ispreChapter = NO;
        NSLog(@"点击了下一页chapter=%ld page=%ld", kReadingManager.chapter, kReadingManager.page);
        return [self getChapterBookContent];;
        
    } else {
        kReadingManager.page++;
        NSLog(@"点击了下一页chapter=%ld page=%ld", kReadingManager.chapter, kReadingManager.page);
        return [self getpageBookContent];
    }
}


- (XXBookContentVC *)getChapterBookContent {
    MJWeakSelf;
    XXBookContentVC __block *contentVC = [[XXBookContentVC alloc] init];
    [self requestContentWithComplete:^{
        contentVC.bookModel = kReadingManager.chapters[kReadingManager.chapter];
        contentVC.chapter = kReadingManager.chapter;
        contentVC.page = kReadingManager.page;
        
        weakSelf.isTaping = NO;
    }];
    return contentVC;
}


- (XXBookContentVC *)getpageBookContent {
    
    if (kReadingManager.chapter > kReadingManager.chapters.count - 1) {
        [HUD showError:@"当前章节超出目录" inview:self.view];
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    XXBookContentVC *contentVC = [[XXBookContentVC alloc] init];
    contentVC.bookModel = kReadingManager.chapters[kReadingManager.chapter];
    contentVC.chapter = kReadingManager.chapter;
    contentVC.page = kReadingManager.page;
    
    return contentVC;
}


- (void)touchTap:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.pageViewController.view];

    if ((touchPoint.x < SpaceWith * 2 && touchPoint.y < SpaceHeight) || (touchPoint.x < SpaceWith && touchPoint.y > SpaceHeight)) {
        // 左边
        if (kReadingManager.isFullTapNext) {
            [self tapNextPage];
        }
        else {
            [self tapPrePage];
        }
    }
    else if ((touchPoint.x > SpaceWith * 2 && touchPoint.y < SpaceHeight * 2) || (touchPoint.x > SpaceWith && touchPoint.y > SpaceHeight * 2)) {
        //右边
        [self tapNextPage];
    }
    else {
        //中间
        [self showMenu];
    }
}


//点击下一页
- (void)tapNextPage {
    
    if (kReadingManager.page == [kReadingManager.chapters.lastObject pageCount] - 1 && kReadingManager.chapter >= kReadingManager.chapters.count - 1) {
        [HUD showMsgWithoutView:@"已经是最后一页了!"];
        return;
    }
    
    if (kReadingManager.page >= [kReadingManager.chapters[kReadingManager.chapter] pageCount] - 1) {
        kReadingManager.page = 0;
        kReadingManager.chapter++;
        _ispreChapter = NO;
        [self requestDataAndSetViewController];
        
    } else {
        if (kReadingManager.transitionStyle == kTransitionStyle_default) {
            kReadingManager.page++;
            XXBookContentVC *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
        else if (kReadingManager.transitionStyle == kTransitionStyle_PageCurl) {
            kReadingManager.page++;
            XXBookContentVC *textVC = [self getpageBookContent];
            XXBookReadingBackViewController *backView = [[XXBookReadingBackViewController alloc] init];
            [backView updateWithViewController:textVC];
            [self.pageViewController setViewControllers:@[textVC, backView] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        else {
            MJWeakSelf;
            _isTaping = YES;
            XXBookContentVC *firstVc = [self.pageViewController.viewControllers firstObject];
            kReadingManager.page = firstVc.page + 1;
            self.view.userInteractionEnabled = NO;
            self.pageViewController.view.userInteractionEnabled = NO;
            XXBookContentVC *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.isTaping = NO;
                    weakSelf.pageViewController.view.userInteractionEnabled = YES;
                    weakSelf.view.userInteractionEnabled = YES;
                }
            }];
        }
    }
}


//点击上一页
- (void)tapPrePage {
    
    if (kReadingManager.chapter == 0 && kReadingManager.page == 0) {
        [HUD showMsgWithoutView:@"已经是第一页了!"];
        return;
    }
    
    if (kReadingManager.page > 0) {
        
        if (kReadingManager.transitionStyle == kTransitionStyle_default) {
            kReadingManager.page--;
            XXBookContentVC *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        }
        else if (kReadingManager.transitionStyle == kTransitionStyle_PageCurl) {
            kReadingManager.page--;
            XXBookContentVC *textVC = [self getpageBookContent];
            XXBookReadingBackViewController *backView = [[XXBookReadingBackViewController alloc] init];
            [backView updateWithViewController:textVC];
            [self.pageViewController setViewControllers:@[textVC, backView] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
        else {
            MJWeakSelf;
            XXBookContentVC *firstVc = [self.pageViewController.viewControllers firstObject];
            kReadingManager.page = firstVc.page - 1;
            _isTaping = YES;
            self.view.userInteractionEnabled = NO;
            self.pageViewController.view.userInteractionEnabled = NO;
            XXBookContentVC *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.isTaping = NO;
                    weakSelf.pageViewController.view.userInteractionEnabled = YES;
                    weakSelf.view.userInteractionEnabled = YES;
                }
            }];
        }
    } else {
        kReadingManager.chapter--;
        _ispreChapter = YES;
        [self requestDataAndSetViewController];
    }
}


- (void)requestDataAndSetViewController {
    MJWeakSelf;
    [self requestContentWithComplete:^{
        XXBookContentVC *contentVC = [[XXBookContentVC alloc] init];
        contentVC.bookModel = kReadingManager.chapters[kReadingManager.chapter];
        contentVC.chapter = kReadingManager.chapter;
        contentVC.page = kReadingManager.page;
        weakSelf.isTaping = NO;
        [weakSelf.pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }];
}


#pragma mark - 处理菜单的单击事件
- (void)configMenuTap {
    
    MJWeakSelf;
    
    self.menuView.delegate = [RACSubject subject];
    
    [self.menuView.delegate subscribeNext:^(id  _Nullable x) {
        
        NSUInteger type = [x integerValue];
        
        switch (type) {
            case kBookMenuType_source: {
                //换源
                XXSummaryVC *vc = [[XXSummaryVC alloc] init];
                vc.modalPresentationStyle = 0;
                [weakSelf presentViewController:vc animated:YES completion:nil];

                vc.selectedSummaryBlock = ^(NSString *_id) {
                    weakSelf.isReplaceSummary = YES;
                    kReadingManager.summaryId = _id;
                    
                    [weakSelf requestDataWithShowLoading:YES];
                };
            }
                
                break;
            case kBookMenuType_close: {
                //关闭
                
                //保存进度
                ReadingManager *manager = [ReadingManager shareReadingManager];
                XXBookModel *model = [kDatabase getBookWithId:manager.bookId];
                if (manager.transitionStyle == kTransitionStyle_Scroll) {
                    //左右滑动
                    XXBookContentVC *firstVc = [self.pageViewController.viewControllers firstObject];
                    model.page = firstVc.page;
                    model.chapter = firstVc.chapter;
                }
                else {
                    model.page = manager.page;
                    model.chapter = manager.chapter;
                }
                
                model.updateStatus = NO;
                [kDatabase updateBook:model];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadBookShelfNotification object:nil];
                
                [kReadingManager clear];
                
                [weakSelf go2Back];
            }
                break;
            case kBookMenuType_day: {
                //白天黑夜切换
                [weakSelf.menuView changeDayAndNight];
            }
                break;
            case kBookMenuType_directory: {
                //目录
                [weakSelf showDirectoryVCWithIsReplaceSummary:NO];
            }
                
                break;
            case kBookMenuType_down: {
                //下载
                
            }
                break;
            case kBookMenuType_setting: {
                //设置
                [weakSelf.menuView showOrHiddenSettingView];
            }
                break;
                
            default:
                break;
        }
    }];
    
    
    self.menuView.settingView.changeSmallerFontBlock = ^{
        //字体缩小
        NSUInteger font = kReadingManager.font - 1;
        [weakSelf changeWithFont:font];
    };
    
    self.menuView.settingView.changeBiggerFontBlock = ^{
        //字体放大
        NSUInteger font = kReadingManager.font + 1;
        [weakSelf changeWithFont:font];
    };
    
    self.menuView.settingView.moreSettingBlock = ^{
        XXReadSettingVC *vc = [[XXReadSettingVC alloc] init];
        [weakSelf pushViewController:vc];
        vc.transitionStyleBlock = ^(kTransitionStyle style) {
            //先删除pageViewController在重新加上
            [weakSelf.pageViewController willMoveToParentViewController:nil];
            [weakSelf.pageViewController.view removeFromSuperview];
            [weakSelf.pageViewController removeFromParentViewController];
            kDealloc(weakSelf.pageViewController);
            [weakSelf pageViewController];
            [weakSelf requestDataAndSetViewController];
            [weakSelf showMenu];
        };
    };
}


#pragma mark - 弹出目录
- (void)showDirectoryVCWithIsReplaceSummary:(BOOL)isReplaceSummary {
    
    [HUD hide];
    
    XXDirectoryVC *directoryVC = [[XXDirectoryVC alloc] initWithIsReplaceSummary:isReplaceSummary];
    directoryVC.modalPresentationStyle = 0;
    [self presentViewController:directoryVC animated:YES completion:^{
        [directoryVC scrollToCurrentRow];
    }];
    
    //选择章节
    MJWeakSelf;
    directoryVC.selectChapter = ^(NSInteger chapter) {
        
        [weakSelf showMenu];
        
        [kReadingManager requestContentWithChapter:chapter ispreChapter:weakSelf.ispreChapter Completion:^{
            [HUD hide];
            kReadingManager.chapter = chapter;
            kReadingManager.page = 0;
            
            [weakSelf.pageViewController setViewControllers:@[[weakSelf getpageBookContent]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        } failure:^(NSString *error) {
            [HUD hide];
        }];
    };
}


#pragma mark - 改变内容字体大小
- (void)changeWithFont:(NSUInteger)font {
    
    if (font < 5) return;
    
    BookSettingModel *md = [BookSettingModel decodeModelWithKey:[BookSettingModel className]];
    md.font = font;
    kReadingManager.font = md.font;
    [BookSettingModel encodeModel:md key:[BookSettingModel className]];
    
    XXBookChapterModel *bookModel = kReadingManager.chapters[kReadingManager.chapter];
    [kReadingManager pagingWithBounds:kReadingFrame withFont:fontSize(kReadingManager.font) andChapter:bookModel];
    
    //跳转回该章的第一页
    if (kReadingManager.page < bookModel.pageCount) {
        kReadingManager.page = 0;
    }
    [self.pageViewController setViewControllers:@[[self getpageBookContent]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


#pragma mark - 弹出或隐藏菜单
- (void)showMenu {
    
    [self.view insertSubview:self.menuView aboveSubview:self.pageViewController.view];
    
    if (!self.menuView.hidden) {
        //如果没有隐藏，代表已经弹出来了，那么执行的是隐藏操作
        self.hiddenStatusBar = YES;
    } else {
        self.hiddenStatusBar = NO;
    }
    
    [self.menuView showMenuWithDuration:kShowMenuDuration completion:nil];
    
    [self.menuView showTitle:kReadingManager.title bookLink:((XXBookChapterModel *)kReadingManager.chapters[kReadingManager.chapter]).link];
}


#pragma mark - get/set

- (void)setPresentComplete:(BOOL)presentComplete {
    _presentComplete = presentComplete;
    if (_presentComplete) {
        self.hiddenStatusBar = YES;
    }
}


//控制状态栏的显示和隐藏
- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar {
    _hiddenStatusBar = hiddenStatusBar;
    [UIView animateWithDuration:kShowMenuDuration animations:^{
        //给状态栏的隐藏和显示加动画
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}


#pragma mark - getter

//pageViewController
- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        //NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        UIPageViewControllerTransitionStyle style;
        BOOL doubleSided = NO;
        if (kReadingManager.transitionStyle == kTransitionStyle_Scroll) {
            style = UIPageViewControllerTransitionStyleScroll;
        }
        else {
            doubleSided = YES;
            style = UIPageViewControllerTransitionStylePageCurl;
        }
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.doubleSided = doubleSided;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
        [self.view addSubview:_pageViewController.view];
        [self addChildViewController:_pageViewController];
        
        for (UIGestureRecognizer *gesture in _pageViewController.gestureRecognizers) {
            /*
             /UIPageViewControllerTransitionStylePageCurl模拟翻页类型中有UIPanGestureRecognizer UITapGestureRecognizer两种手势，删除左右边缘的点击事件
             */
            if ([gesture isKindOfClass:UITapGestureRecognizer.class]) {
                [_pageViewController.view removeGestureRecognizer:gesture];
            }
        }
    }
    return _pageViewController;
}


//菜单
- (XXBookMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[XXBookMenuView alloc] init];
        [self.view addSubview:_menuView];
        
        //第一次进来要隐藏
        _menuView.hidden = YES;
        
        [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_menuView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            //来到这里表示menu已经是弹出来的
            [self showMenu];
        }]];
        
        [self configMenuTap];
    }
    return _menuView;
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
