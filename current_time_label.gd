extends Label

func _process(_delta):
	# get the current time and display it
	var current_time = OS.get_time()
	var hour = current_time.hour;
	var minute = current_time.minute;
	var seconds = current_time.second;
	text = "%02d:%02d:%02d" % [hour, minute, seconds]
