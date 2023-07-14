//
//  local-notification.h
//  local-notification
//
//  Created by Kyoz on 14/07/2023.
//

#ifndef LOCAL_NOTIFICATION_H
#define LOCAL_NOTIFICATION_H

#ifdef VERSION_4_0
#include "core/object/object.h"
#endif

#ifdef VERSION_3_X
#include "core/object.h"
#endif

class LocalNotification: public Object {

    GDCLASS(LocalNotification, Object);
    bool granted;
    static LocalNotification *instance;

public:
    bool isPermissionGranted();
    void requestPermission();
    void openAppSetting();
    void show(const String &title, const String &message, const int &interval, const int &tag);
    void showRepeating(const String &title, const String &message, const int &interval, const int &repeat_interval, const int &tag);
    void showDaily(const String &title, const String &message, const int &at_hour, const int &at_minute, const int &tag);
    void cancel(const int &tag);

    static LocalNotification *get_singleton();
    
    LocalNotification();
    ~LocalNotification();

protected:
    static void _bind_methods();
};

#endif
