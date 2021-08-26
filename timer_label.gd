extends Label

# prepare the required nodes
onready var btn_start = get_node("../btn_start")
onready var btn_pause = get_node("../btn_pause")
onready var btn_reset = get_node("../btn_reset")
onready var time_slider = get_node("../time_slider")
onready var progress_circle = get_node("../progress_circle")
onready var audio_stream_player = get_node("../audio_stream_player")

# time chosen by the user
var time_chosen = 0.1 * 60 # 25 minutes
# time shown on the timer, it will start from the time chosen (e.g. 25min)
var time_shown = time_chosen
# used to check if the countdown is paused or not
# e.g. when pause button is clicked, when the countdown finishes etc
var countdown_paused = true
# can_change_slider_value makes sure the user can't change the time while
# the countdown is started
var can_change_slider_value = true
# control when the alarm sound will be played
var sound_has_played = false

# load the sound alert
var alert_sound = preload("res://alert_sound.wav")

func _ready():
	# set the time_slider max value to 60 minutes (1 hour)
	time_slider.set_max(60)
	# set the time_slider value to time_chosen in seconds
	time_slider.value = time_chosen / 60


func _process(delta):
	if(!countdown_paused):
		# Countdown is on
		time_shown -= delta
	
	if(round(time_shown)) == 0.0:
		# Countdown is off
		countdown_paused = true
	
	# Claculate the seconds, minutes and hours to be displayed
	var secs = fmod(time_shown, 60)
	var mins = fmod(time_shown, 60*60) / 60
	var hrs = fmod(fmod(time_shown, 3600 * 60) / 3600, 24)
	# set the time left and display it on the label
	var time_left_str = "%02d:%02d:%02d" % [hrs, mins, secs]
	text = time_left_str
	
	# Progress circle
	# Maybe the design can be improved
	# see: https://godotforums.org/discussion/21177/how-to-make-a-rotary-knob-control
	var progress_circle_value = get_parent().get_node("progress_circle").value
	# if progress_circle_value reachs 0 (countdown start from 100 and goes down to 0)
	# and the sound has not been played and time left is 0
	if progress_circle_value == 0 and !sound_has_played and time_left_str == "00:00:00":
		# fire the alarm sound
		fire_alarm_sound()
		# disable the pause button
		btn_pause.disabled = true
		# allow the user to cange slider value
		can_change_slider_value = true
		# and show the slider
		time_slider.show()
	
	# Calculate the time elapsed percentage and display it in the prograss circle
	var time_elapsed_percentage = (round(time_shown) * 100) / round(time_chosen)
	progress_circle.value = time_elapsed_percentage
	
	# Slider
	var slider_value = time_slider.value
	if slider_value > 0 and can_change_slider_value:
		# sync the chosen time with the slider value and modify the time shown accordingly
		time_chosen = slider_value * 60
		time_shown = time_chosen
		btn_start.disabled = false


func _on_btn_start_pressed():
	countdown_paused = false
	can_change_slider_value = false
	time_slider.hide()
	btn_start.disabled = true
	btn_pause.disabled = false

func _on_btn_pause_pressed():
	countdown_paused = true
	can_change_slider_value = false
	btn_start.disabled = false
	btn_pause.disabled = true


func _on_btn_reset_pressed():
	# reset everything in the UI
	countdown_paused = true
	can_change_slider_value = true
	sound_has_played = false
	time_slider.show()
	btn_start.disabled = false
	btn_pause.disabled = true
	# set the time shown to the time chosen in the beginning
	time_shown = time_chosen


func fire_alarm_sound():
	sound_has_played = true
	audio_stream_player.stream = alert_sound
	audio_stream_player.play()
