extends Node

signal on_permission_request_completed()

var ln = null


# Change this to _ready() if you want automatically init
func init():
	if Engine.has_singleton("LocalNotification"):
		ln = Engine.get_singleton("LocalNotification")
		init_signals()


func init_signals():
	ln.connect("permission_request_completed", Callable(self, "_permission_request_completed"))


func _permission_request_completed():
	emit_signal("on_permission_request_completed")


func isPermissionGranted() -> bool:
	if not ln:
		not_found_plugin()
		return false
	
	return ln.isPermissionGranted()


func requestPermission():
	if not ln:
		not_found_plugin()
		return
	
	ln.requestPermission()


func openAppSetting():
	if not ln:
		not_found_plugin()
		return
	
	ln.openAppSetting()


func show(title, message, interval, tag):
	if not ln:
		not_found_plugin()
		return
	
	ln.show(title, message, interval, tag)


func showRepeating(title, message, interval, repeat_interval, tag):
	if not ln:
		not_found_plugin()
		return
	
	ln.showRepeating(title, message, interval, repeat_interval, tag)


func showDaily(title, message, at_hour, at_minute, tag):
	if not ln:
		not_found_plugin()
		return
	
	if OS.get_name() == "iOS":
		ln.showDaily(title, message, at_hour, at_minute, tag)
	else:
		# This may not a properly and correct way but at least it work for me ATM.
		# If you have any good solution, please help :D
		ln.showRepeating(title, message,\
			_generate_android_daily_notify_interval(at_hour, at_minute), 86400, tag)


func cancel(tag):
	if not ln:
		not_found_plugin()
		return
	
	ln.cancel(tag)


func not_found_plugin():
	print('[LocalNotification] Not found plugin. Please ensure that you checked LocalNotification plugin in the export template')


func _generate_android_daily_notify_interval(hour, minute):
	var today_time = Time.get_datetime_dict_from_system()
	today_time.hour = 0
	today_time.minute = 0
	today_time.second = 0
	
	var today_unix = Time.get_unix_time_from_datetime_dict(today_time)
	var tomorrow_unix = today_unix + 86400
	
	var current_time = Time.get_datetime_dict_from_system()
	today_time.hour = current_time.hour
	today_time.minute = current_time.minute
	today_time.second = current_time.second
	var current_unix = Time.get_unix_time_from_datetime_dict(today_time)
	
	var remaining_unix = tomorrow_unix - current_unix

	var r_hour = hour
	var r_minute = minute
	
	# Today
	today_unix += r_hour * 3600
	today_unix += r_minute * 60
	
	if today_unix > current_unix && today_unix < tomorrow_unix:
		return today_unix - current_unix
	else:
		return remaining_unix + r_hour * 3600 + r_minute * 60
