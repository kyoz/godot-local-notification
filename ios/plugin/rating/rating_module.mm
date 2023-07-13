//
//  local_notification_module.m
//  local_notification
//
//  Created by Kyoz on 10/07/2023.
//


#ifdef VERSION_4_0
#include "core/config/engine.h"
#else
#include "core/engine.h"
#endif


#include "local_notification_module.h"

LocalNotification * local_notification;

void register_local_notification_types() {
    local_notification = memnew(LocalNotification);
    Engine::get_singleton()->add_singleton(Engine::Singleton("LocalNotification", local_notification));
};

void unregister_local_notification_types() {
    if (local_notification) {
        memdelete(local_notification);
    }
}
