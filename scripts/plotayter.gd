extends Node2D


enum PotatoState {WAITING, GROWING, REVIVING, DEAD, FINISHED}


export var base_speed = 200 # how fast the player moves without boost (pixels / second)
export var rotation_speed = 5 # how fast the player rotates (radians / second)
var state = PotatoState.WAITING
var control
var index
var nitro_active = false
var bonus_gain = 0

const wrap_width = 2048 # todo: put this in a more global location


var hats = [
	preload("res://scenes/hats/Hat0.tscn"),
	preload("res://scenes/hats/Hat1.tscn"),
	preload("res://scenes/hats/Hat2.tscn"),
	preload("res://scenes/hats/Hat3.tscn")
]


func _ready():
	pass


func start_growing():
	state = PotatoState.GROWING

func set_id_index(control_id, index):
	control = PlayerInputs.get_control(control_id)
	self.index = index
	for icon in $Tip/Sprites.get_children():
		icon.queue_free()
	$Tip/Sprites.add_child(hats[index].instance())


func die():
	state = PotatoState.DEAD

func finish():
	state = PotatoState.FINISHED

func y_position():
	return $Tip.global_position.y

func is_nitro_active():
	return nitro_active

func set_bonus_gain(bonus):
	bonus_gain = bonus



func _physics_process(delta):
	if state == PotatoState.GROWING:
		var inp = control.move_direction()
		$Tip.rotation += inp * delta * rotation_speed
		var current_speed = base_speed

		var vel = Vector2(0, -current_speed).rotated($Tip.rotation)

		$Tip.position += vel * delta
		if $Tip.global_position.x < 0:
			$Tip.position.x += wrap_width
		elif $Tip.global_position.x >= wrap_width:
			$Tip.position.x -= wrap_width

