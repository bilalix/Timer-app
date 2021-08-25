extends Label

func _process(delta):
	var current_time = OS.get_time()
	var hour = current_time.hour;
	var minute = current_time.minute;
	var seconds = current_time.second;
	text = "%02d:%02d:%02d" % [hour, minute, seconds]
