extends Label

@onready var max_is_100 = $GeoBio/MaxIs100
@onready var max_is_50 = $GeoBio/MaxIs50

var point_scale: int:
	get:
		if max_is_100.button_pressed:
			return 100
		elif max_is_50.button_pressed:
			return 50
		else:
			return 0

var button_group := ButtonGroup.new()

func _ready():
	max_is_100.button_group = button_group
	max_is_50.button_group = button_group
