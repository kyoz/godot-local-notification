//
//  local_notification.m
//  local_notification
//
//  Created by Kyoz on 07/07/2023.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#ifdef VERSION_4_0
#include "core/object/class_db.h"
#else
#include "core/class_db.h"
#endif

#include "local_notification.h"

LocalNotification *LocalNotification::instance = NULL;

LocalNotification::LocalNotification() {
    instance = this;
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
    ADD_SIGNAL(MethodInfo("completed"));
    ADD_SIGNAL(MethodInfo("error", PropertyInfo(Variant::STRING, "error_code")));
    
    ClassDB::bind_method("show", &LocalNotification::show);
}

void LocalNotification::show() {
    if (@available(iOS 14.0, *)) {
        UIWindowScene *scene = nil;
        
        for(UIWindowScene *s in UIApplication.sharedApplication.connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                scene = s;
                break;
            }
        }
        
        if (scene != nil) {
            [SKStoreReviewController requestReviewInScene:scene];
            emit_signal("completed");
        } else {
            emit_signal("error", "ERROR_NO_ACTIVE_SCENE");
        }
    } else if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
        emit_signal("completed");
    } else {
        emit_signal("error", "ERROR_UNKNOWN");
    }
}

