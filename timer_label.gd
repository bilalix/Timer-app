extends Label

var time_chosen = 1 * 60 # in minutes
var time_shown = time_chosen
var time_on = false


func _process(delta):
	if(time_on):
		time_shown -= delta
	
	if(round(time_shown)) == 0.0:
		time_on = false
	
	var secs = fmod(time_shown, 60)
	var mins = fmod(time_shown, 60*60) / 60
	var hrs = fmod(fmod(time_shown, 3600 * 60) / 3600, 24)
	var time_left_str = "%02d:%02d:%02d" % [hrs, mins, secs]
	text = time_left_str
	
	# Progress circle
	# Maybe this can be improved
	# see: https://godotforums.org/discussion/21177/how-to-make-a-rotary-knob-control
	var time_elapsed_percentage = (round(time_shown) * 100) / round(time_chosen)
	get_parent().get_node("progress_circle").value = time_elapsed_percentage


func _on_btn_start_pressed():
	time_on = true


func _on_btn_pause_pressed():
	time_on = false


func _on_btn_reset_pressed():
	time_on = false
	time_shown = time_chosen
