extends KinematicBody2D

# Aliases
onready var cam = $Camera2D
onready var col = $Collision
onready var spr = $AnimatedSprite

# Configurable variables
export (float) var MOVE_SPEED = 90.0


# System variables
# inp_dir and cursor_dir should be normalized!!!
var inp_dir = Vector2() 
var cursor_dir = Vector2()
var right = true

# Constants
const up_diag_sine = sin(deg2rad(-68))
const upside_diag_sine = sin(deg2rad(-23))
const downside_diag_sine = sin(deg2rad(23))
const down_diag_sine = sin(deg2rad(68))

# Called when the node enters the scene tree for the first time.
func _ready():
	#cam.make_current()
	cam.drag_margin_h_enabled = false
	cam.drag_margin_v_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()
	update_animation()

func _physics_process(delta):
	process_physics()

func update_animation():
	spr.flip_h = !right
	
	var angle_sine = inp_dir.y
	if inp_dir.length_squared() > 0:
		print("angle sine: " + str(angle_sine))
		print("down diag sine: " + str(down_diag_sine))
		if angle_sine < up_diag_sine:
			spr.animation = "idle_up"
		elif angle_sine > up_diag_sine and angle_sine < upside_diag_sine:
			spr.animation = "idle_upside"
		elif angle_sine > upside_diag_sine and angle_sine < downside_diag_sine:
			spr.animation = "idle_side"
		elif angle_sine > downside_diag_sine and angle_sine < down_diag_sine:
			spr.animation = "idle_downside"
		elif angle_sine > down_diag_sine:
			spr.animation = "idle_down"
	
	spr.play()

func process_input():
	inp_dir.x = (int(Input.is_action_pressed("key_right")) 
		- int(Input.is_action_pressed("key_left")))
	inp_dir.y = (int(Input.is_action_pressed("key_down")) 
		- int(Input.is_action_pressed("key_up")))
	
	inp_dir = inp_dir.normalized()
	if abs(inp_dir.x) > 0:
		right = inp_dir.x > 0

func process_physics():
	var velocity = inp_dir * MOVE_SPEED
	
	move_and_slide(velocity)