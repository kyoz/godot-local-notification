extends Node

signal on_error(error_code)
signal on_completed()

var ln = null


# Change this to _ready() if you want automatically init
func init():
	if Engine.has_singleton("LocalNotification"):
		ln = Engine.get_singleton("LocalNotification")
		init_signals()


func init_signals():
	ln.error.connect(_on_error)
	ln.completed.connect(_on_completed)


func _on_error(error_code):
	emit_signal("on_error", error_code)


func _on_completed():
	emit_signal("on_completed")


func show():
	if not ln:
		not_found_plugin()
		return
	
	ln.show()
	

func not_found_plugin():
	print('[LocalNotification] Not found plugin. Please ensure that you checked LocalNotification plugin in the export template')
