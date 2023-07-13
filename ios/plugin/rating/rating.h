//
//  local_notification.h
//  local_notification
//
//  Created by Kyoz on 07/07/2023.
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

    static LocalNotification *instance;

public:
    void show();

    static LocalNotification *get_singleton();
    
    LocalNotification();
    ~LocalNotification();

protected:
    static void _bind_methods();
};

#endif
