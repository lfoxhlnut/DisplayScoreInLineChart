extends "res://Script/item_list.gd"

signal class_selected(id: int)

var class_info: Array[ClassInfo]


func update(data: Array[ClassInfo]) -> void:
	# ↓其实这里数组中的 ClassInfo 是否被深复制了我还是不知道, 不过没出现问题就不管了
	class_info = data.duplicate(true) as Array[ClassInfo]
	_update(class_info.size())
	for id in _container.get_child_count():
		var button := _container.get_child(id) as Button
		button.pressed.connect(func(): class_selected.emit(id))


func get_item_description(id: int) -> String:
	return class_info[id].my_class_name
