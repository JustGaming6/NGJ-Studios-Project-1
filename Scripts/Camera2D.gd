extends Camera2D

# Sensitivity parameter to control camera movement speed
var sensitivity = 1

# Store the previous mouse position
var prev_mouse_pos = Vector2.ZERO

# Flag to track if left mouse button is pressed and held
var is_left_mouse_button_pressed = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Update flag based on left mouse button press/release
			is_left_mouse_button_pressed = event.pressed
			if is_left_mouse_button_pressed:
				# Store the current mouse position when left mouse button is pressed
				prev_mouse_pos = get_global_mouse_position()

func _process(delta):
	if is_left_mouse_button_pressed:
		# Get the current mouse position
		var current_mouse_pos = get_global_mouse_position()

		# Check if the cursor has moved since the left mouse button was pressed
		if current_mouse_pos != prev_mouse_pos:
			# Calculate the difference in mouse position since the last frame
			var cursor_movement = (current_mouse_pos - prev_mouse_pos) * sensitivity

			# Update camera position based on cursor movement
			position -= cursor_movement

			# Update previous mouse position for the next frame
			prev_mouse_pos = current_mouse_pos
