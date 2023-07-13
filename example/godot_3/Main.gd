extends Node

onready var not_granted_lbl = $Canvas/Center/VBox/HBox/NotGrantedLbl
onready var granted_lbl = $Canvas/Center/VBox/HBox/GrantedLbl

var notification_tag = 1

func _ready():
	LocalNotification.init()
	#var _o = LocalNotification.connect("on_completed", self, "_on_completed")
	#var _o2 = LocalNotification.connect("on_error", self, "_on_error")

	_update_status()


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_FOCUS_IN):
		_update_status()


func _on_error(error_code):
	print("failed with error: " + error_code)


func _on_completed():
	print("Completed")


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
	yield(LocalNotification, "on_permission_request_completed")
	
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
	LocalNotification.showDaily("Daily Notification", "See you after a day :))", 0, notification_tag)
	OS.alert("Open this app next day at this time to see notification :)")


func _on_CancelBtn_pressed():
	LocalNotification.cancel(notification_tag)
	OS.alert("All notification has been cleared")
