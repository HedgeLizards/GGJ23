extends Path2D

const WormSegment = preload('res://scenes/WorgSegment.tscn')

export(String, 'Line', 'Circle') var shape = 'Line'
export var radius = 100.0
export var segments = 5
export var offset = 0.0
export var speed = 256.0
export var inverted = false

func _ready():
	match shape:
		'Line':
			curve.add_point(Vector2(-1024, 0))
			curve.add_point(Vector2(1024, 0))
		'Circle':
			var number_of_points = ceil(radius / 5)
			
			for i in number_of_points + 1:
				curve.add_point(Vector2(
					cos(TAU / number_of_points * i) * radius,
					sin(TAU / number_of_points * i) * radius
				))
	
	for i in segments:
		var worm_segment = WormSegment.instance()
		
		worm_segment.offset = offset + i * 64
		
		add_child(worm_segment)

func _physics_process(delta):
	for child in get_children():
		child.offset += (-speed if inverted else speed) * delta
