//
//  AppDelegate.m
//  Demo
//
//  Created by tiger on 2022/4/13.
//

#import "AppDelegate.h"
#import "GTNewsViewController.h"
#import "GTVideoViewController.h"
#import "GTRecommendViewController.h"
#import "QUILoadingViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // Override point for customization after application launch.
    
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    GTNewsViewController *newsViewController = [GTNewsViewController new];
    newsViewController.tabBarItem.title = @"新闻";
    newsViewController.tabBarItem.image = [UIImage imageNamed:@"resource/tabBar1@1.5x"];
    
    GTVideoViewController *videoViewController = [GTVideoViewController new];
    
//    GTRecommendViewController *recommendController = [GTRecommendViewController new];
    GTRecommendViewController *recommendController = [QUILoadingViewController new];
    
    UIViewController *tabbarSubViewController4 = [UIViewController new];
    tabbarSubViewController4.view.backgroundColor = [UIColor lightGrayColor];
    tabbarSubViewController4.tabBarItem.title = @"我的";
    tabbarSubViewController4.tabBarItem.image = [UIImage imageNamed:@"resource/tabBar4@3x"];
    
    [tabbarController setViewControllers:@[newsViewController, videoViewController, recommendController, tabbarSubViewController4]];
    tabbarController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabbarController];
    // iOS15 UINavigationBarAppearance与UINavigationBarScrollEdgeAppearance
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor whiteColor];
    navigationController.navigationBar.standardAppearance = appearance;
    navigationController.navigationBar.scrollEdgeAppearance = appearance;
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    NSLog(@"did select");
}

#pragma mark - UISceneSession lifecycle

//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
