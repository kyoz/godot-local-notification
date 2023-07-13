extends Node

signal on_permission_request_completed()

var ln = null


# Change this to _ready() if you want automatically init
func init():
	if Engine.has_singleton("LocalNotification"):
		ln = Engine.get_singleton("LocalNotification")
		init_signals()


func init_signals():
	ln.connect("permission_request_completed", self, "_permission_request_completed")


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


func showDaily(title, message, interval, tag):
	if not ln:
		not_found_plugin()
		return
	
	ln.showDaily(title, message, interval, tag)


func cancel(tag):
	if not ln:
		not_found_plugin()
		return
	
	ln.cancel(tag)


func not_found_plugin():
	print('[LocalNotification] Not found plugin. Please ensure that you checked LocalNotification plugin in the export template')
