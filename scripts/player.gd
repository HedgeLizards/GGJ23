extends KinematicBody2D


export var speed = 256


func _ready():
	pass 

func _physics_process(delta):
	var inp = Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	)
	var vel = inp.normalized() * speed
	self.move_and_slide(vel)
