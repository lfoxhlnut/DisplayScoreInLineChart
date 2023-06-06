extends "res://Script/item_list.gd"

var class_info: ClassInfo


func update(data: ClassInfo):
	class_info = data
	_container.columns = floori(sqrt(class_info.student_num))
	button_min_size.x = size.x / _container.columns
	button_min_size.y = size.y / (float(class_info.student_num) / _container.columns + 1)
	_update(class_info.student_num)


func get_item_description(id: int):
	return class_info.get_student(id)
