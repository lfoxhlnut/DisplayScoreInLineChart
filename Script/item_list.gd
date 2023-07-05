extends Control

enum ButtonType { BUTTON, CHECK_BOX, CHECK_BUTTON }
enum ContainerType { VBOX, HBOX, GRID }
@export var in_a_same_button_group := true
@export
#@doc("该变量") # 好像还不支持这个特性
var button_min_size := Vector2.ZERO
@export_enum("Button", "CheckBox", "CheckButton") var button_type: int = 0
@export var container_type: ContainerType = ContainerType.VBOX
# gd4 不支持变量的值是一个类型, 所以我只好采用一些丑陋的方法
# 感觉 export_enum 不如直接 export 一个 enum 变量

# int 和 bool 似乎并不能默认转换, 用 int 的话有时会更方便, 不过也有风险
var button_flag: Array[int] = []
var selected_id: Array[int]:
	get:
		selected_id = []
		for id in button_flag.size():
			if button_flag[id]:
				selected_id.append(id)
		return selected_id
var _button_group := ButtonGroup.new()
var _container: Container

func _ready():
	if button_min_size == Vector2.ZERO:
		button_min_size.x = size.x
		button_min_size.y = size.y / 6.0
	_container = get_new_container()
	add_child(_container)


func _exit_tree():
	Constant.remove_and_free(_container)
	_container.queue_free()


func update(_data):
	pass


func _update(item_num: int) -> void:
	
	Constant.remove_and_free(_container)
	button_flag.resize(item_num)
	button_flag.fill(0)
	
	for i in range(item_num):
		var button := get_new_button()
		if in_a_same_button_group:
			button.button_group = _button_group
#		button.text = class_info[i].my_class_name
		button.text = get_item_description(i)
		button.custom_minimum_size = button_min_size
		button.pressed.connect(_on_button_pressed.bind(i))
		_container.add_child(button)


func get_item_description(_id: int) -> String:
	return ""

# 不过 gd4 支持把节点本身直接作为导出变量, 以后可以考虑使用这种方法重写
# typeof 运算符
func get_new_button() -> Button:
	match (button_type):
		0:
			return Button.new()
		1:
			return CheckBox.new()
		2:
			return CheckButton.new()
		_:
			return Button.new()


func get_new_container() -> Container:
	match (container_type):
		ContainerType.VBOX:
			return VBoxContainer.new()
		ContainerType.HBOX:
			return HBoxContainer.new()
		ContainerType.GRID:
			return GridContainer.new()
		_:
			return VBoxContainer.new()


func _on_button_pressed(id: int):
	button_flag[id] ^= 1
