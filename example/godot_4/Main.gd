extends Node

@onready var not_granted_lbl = $Canvas/Center/VBox/HBox/NotGrantedLbl
@onready var granted_lbl = $Canvas/Center/VBox/HBox/GrantedLbl

var notification_tag = 1

func _ready():
	LocalNotification.init()

	_update_status()
	
	var _o = LocalNotification.connect("on_permission_request_completed", Callable(self, "_on_permission_request_completed"))
	

func _notification(what):
	if (what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN):
		_update_status()


func _on_permission_request_completed():
	_update_status()


func _update_status():
	not_granted_lbl.hide()
	granted_lbl.hide()
	
	
	if LocalNotification.isPermissionGranted():
		granted_lbl.show()
		return
	
	not_granted_lbl.show()


func _on_RequestPermissionBtn_pressed():
	LocalNotification.requestPermission()
	
	# To ensure the request process is done, you can use the signal as you like,
	# I prefer this solution
	await LocalNotification.on_permission_request_completed
	
	if LocalNotification.isPermissionGranted():
		OS.alert("Permission Granted")
	else:
		OS.alert("Permission is Denied or Blocked by system :'(")


func _on_GetPermissionStatusBtn_pressed():
	OS.alert(str(LocalNotification.isPermissionGranted()))


func _on_OpenSettingBtn_pressed():
	LocalNotification.openAppSetting()



func _on_ShowBtn_pressed():
	LocalNotification.cancel(notification_tag)
	LocalNotification.show("Normal Notification", "It works :))", 5, notification_tag)


func _on_ShowRepeatingBtn_pressed():
	LocalNotification.cancel(notification_tag)
	LocalNotification.showRepeating("Repeating Notification", "Next notification will fire in 15s", 5, 15, notification_tag)


func _on_ShowDailyBtn_pressed():
	LocalNotification.cancel(notification_tag)
	var current_time = Time.get_datetime_dict_from_system()
	var current_hour = current_time.hour
	var current_minute = current_time.minute + 1
	
	# This is just for testing, in real app, you just set hour and minute you want
	if (current_minute >= 60):
		current_hour += 1
		current_minute = 0
	
	if current_hour >= 24:
		current_hour = 0
	
	LocalNotification.showDaily("Daily Notification", "See you after a day :))", current_hour, current_minute, notification_tag)
	OS.alert("A notification will show after one minute and every day at that time :)")


func _on_CancelBtn_pressed():
	LocalNotification.cancel(notification_tag)
	OS.alert("Notification has been canceled")
