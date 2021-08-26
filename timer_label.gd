extends Label

var time_chosen = 0.1 * 60 # 25 minutes
var time_shown = time_chosen
var time_on = false
var can_change_slider_value = true

func _ready():
	get_parent().get_node("time_slider").value = time_chosen / 60


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
	
	# Slider
	var slider_value = get_parent().get_node("time_slider").value
	if slider_value > 0 and can_change_slider_value:
		time_chosen = slider_value * 60
		time_shown = time_chosen


func _on_btn_start_pressed():
	time_on = true
	can_change_slider_value = false
	get_parent().get_node("btn_start").disabled = true
	get_parent().get_node("btn_pause").disabled = false

func _on_btn_pause_pressed():
	time_on = false
	can_change_slider_value = false
	get_parent().get_node("btn_start").disabled = false
	get_parent().get_node("btn_pause").disabled = true


func _on_btn_reset_pressed():
	time_on = false
	can_change_slider_value = true
	time_shown = time_chosen
	get_parent().get_node("btn_start").disabled = false
	get_parent().get_node("btn_pause").disabled = true
