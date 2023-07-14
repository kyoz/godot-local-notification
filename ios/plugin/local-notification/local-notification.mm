//
//  local-notification.m
//  local-notification
//
//  Created by Kyoz on 14/07/2023.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

#ifdef VERSION_4_0
#include "core/object/class_db.h"
#else
#include "core/class_db.h"
#endif

#include "local-notification.h"

LocalNotification *LocalNotification::instance = NULL;

LocalNotification::LocalNotification() {
    instance = this;
    granted = false;
    NSLog(@"initialize local_notification");
}

LocalNotification::~LocalNotification() {
    if (instance == this) {
        instance = NULL;
    }
    
    NSLog(@"deinitialize local_notification");
}

LocalNotification *LocalNotification::get_singleton() {
    return instance;
};


void LocalNotification::_bind_methods() {
    ADD_SIGNAL(MethodInfo("permission_request_completed"));
    
    ClassDB::bind_method("isPermissionGranted", &LocalNotification::isPermissionGranted);
    ClassDB::bind_method("requestPermission", &LocalNotification::requestPermission);
    ClassDB::bind_method("openAppSetting", &LocalNotification::openAppSetting);
    ClassDB::bind_method("show", &LocalNotification::show);
    ClassDB::bind_method("showRepeating", &LocalNotification::showRepeating);
    ClassDB::bind_method("showDaily", &LocalNotification::showDaily);
    ClassDB::bind_method("cancel", &LocalNotification::cancel);
}


bool LocalNotification::isPermissionGranted() {
    NSLog(@"[GodotLocalNotification] called isPermissionGranted()");

    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            granted = true;
        } else {
            granted = false;
        }
    }];
    
    return granted;
}

void LocalNotification::requestPermission() {
    NSLog(@"[GodotLocalNotification] called requestPermission()");

    if (granted) {
        emit_signal("permission_request_completed");
        return;
    }
    
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL is_granted, NSError * _Nullable error) {
            if(error) {
                granted = false;
                NSLog(@"[GodotLocalNotification] request permission error: %@", error);
            }
            
            granted = is_granted;
        
            dispatch_async(dispatch_get_main_queue(), ^{
                emit_signal("permission_request_completed");
            });

            [UNUserNotificationCenter.currentNotificationCenter removeAllDeliveredNotifications];
        }];
}

void LocalNotification::openAppSetting() {
    [[UIApplication sharedApplication]
                openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                options:[[NSDictionary alloc] init]
                completionHandler:^(BOOL success) {
               }];
}

void LocalNotification::show(const String &title, const String &message, const int &interval, const int &tag) {
    if(!granted) {
        NSLog(@"[GodotLocalNotification] No permission granted");
        return;
    }
    
    NSString *_title = [NSString stringWithUTF8String:title.utf8().get_data()];
    NSString *_message = [NSString stringWithUTF8String:message.utf8().get_data()];
    NSString *_identifier = [NSString stringWithFormat:@"ln_%d", tag];
    NSLog(@"[GodotLocalNotification] show(%@, %@, %@, %@)", _title, _message, @(interval), @(tag));
    
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:@[_identifier]];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = _title;
        content.body = _message;
        content.sound = [UNNotificationSound defaultSound];
        
        //content.categoryIdentifier = @"Call menu";
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_identifier content:content trigger:trigger];
        [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"[GodotLocalNotification] Error when add notification request: %@", error);
            }
        }];
    } else {
        NSLog(@"[GodotLocalNotification] Unsupport");
    }
}

void LocalNotification::showRepeating(const String &title, const String &message, const int &interval, const int &repeat_interval, const int &tag) {
    if(!granted) {
        NSLog(@"[GodotLocalNotification] No permission granted");
        return;
    }
    
    NSString *_title = [NSString stringWithUTF8String:title.utf8().get_data()];
    NSString *_message = [NSString stringWithUTF8String:message.utf8().get_data()];
    NSString *_identifier = [NSString stringWithFormat:@"ln_%d", tag];
    NSLog(@"[GodotLocalNotification] showRepeating(%@, %@, %@, %@, %@)", _title, _message, @(repeat_interval), @(interval), @(tag));

    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:@[_identifier]];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = _title;
        content.body = _message;
        content.sound = [UNNotificationSound defaultSound];
        
        int _repeat_interval = repeat_interval;
        
        // Must be at least 60 seconds
        if (_repeat_interval < 60) {
            _repeat_interval = 60;
        }
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:_repeat_interval repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_identifier content:content trigger:trigger];
        [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"[GodotLocalNotification] Error when add notification request: %@", error);
            }
        }];
    } else {
        NSLog(@"[GodotLocalNotification] Unsupport");
    }
}

void LocalNotification::showDaily(const String &title, const String &message, const int &at_hour, const int &at_minute, const int &tag) {
    if(!granted) {
        NSLog(@"[GodotLocalNotification] No permission granted");
        return;
    }
    
    NSString *_title = [NSString stringWithUTF8String:title.utf8().get_data()];
    NSString *_message = [NSString stringWithUTF8String:message.utf8().get_data()];
    NSString *_identifier = [NSString stringWithFormat:@"ln_%d", tag];
    NSLog(@"[GodotLocalNotification] showDaily(%@, %@, %@, %@)", _title, _message, @(at_hour), @(at_minute));
    
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:@[_identifier]];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = _title;
        content.body = _message;
        content.sound = [UNNotificationSound defaultSound];
        
        NSDateComponents* date = [[NSDateComponents alloc] init];
        date.hour = at_hour;
        date.minute = at_minute;
        
        UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:date repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_identifier content:content trigger:trigger];
        [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if(error) NSLog(@"Error when schedule the notification: %@", error);
        }];
    } else {
        NSLog(@"[GodotLocalNotification] Unsupport");
    }
}

void LocalNotification::cancel(const int &tag) {
    NSString *_identifier = [NSString stringWithFormat:@"ln_%d", tag];
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:@[_identifier]];
    } else {
        NSLog(@"[GodotLocalNotification] Unsupport");
    }
}
