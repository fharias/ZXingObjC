/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AppDelegate.h"
#import "ViewController.h"
#import "InitViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[InitViewController alloc] initWithNibName:@"InitViewController" bundle:nil];
  [self.window makeKeyAndVisible];
  return YES;
}

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                      
                                  }];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }

    [FBAppCall handleDidBecomeActive];
}

@end
