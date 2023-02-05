extends Path2D

const WormSegment = preload('res://scenes/WormSegment.tscn')
const texture_tail = preload('res://assets/worm/tail.png')
const texture_head = preload('res://assets/worm/head.png')
const texture_segment = preload('res://assets/worm/segment.png')

export(String, 'Line', 'Circle') var shape = 'Line'
export var radius = 256.0
export var segments = 5
export var offset = 0.0
export var speed = 256.0
export var inverted = false

func _ready():
	curve = curve.duplicate()
	
	match shape:
		'Line':
			curve.add_point(Vector2(-1088, 0))
			curve.add_point(Vector2(1088, 0))
		'Circle':
			var number_of_points = ceil(radius / 2)
			
			for i in number_of_points + 1:
				curve.add_point(Vector2(
					cos(TAU / number_of_points * i) * radius,
					sin(TAU / number_of_points * i) * radius
				))
	
	var last = segments - 1
	
	for i in segments:
		var worm_segment = WormSegment.instance()
		
		worm_segment.offset = offset + i * 128 * 0.9
		
		match i:
			0:
				worm_segment.get_node('Sprite').texture = (texture_head if inverted else texture_tail)
			last:
				worm_segment.get_node('Sprite').texture = (texture_tail if inverted else texture_head)
			_:
				worm_segment.get_node('Sprite').texture = texture_segment
		
		worm_segment.get_node('Sprite').flip_h = inverted
		
		add_child(worm_segment)

func _physics_process(delta):
	for child in get_children():
		child.offset += (-speed if inverted else speed) * delta
