extends Button

signal new_class_created

@onready var my_window = $MyWindow
@onready var class_list = $MyWindow/ClassList
@onready var my_class_name = $MyWindow/MyClassName
@onready var data_file_path = $MyWindow/DataFilePath

func _on_pressed():
	my_window.show()


func update(new_class_info: Array[ClassInfo]) -> void:
	class_list.update(new_class_info)


func _on_my_window_confirmed():
	if data_file_path.selected_path == "":
		Constant.warn(self, "需要数据文件才能创建班级哦")
		my_window.show()
	
	if my_class_name.text == "":
		my_class_name.text = data_file_path.selected_path.get_file().get_basename()
	
	for i in class_list.class_info:
		if my_class_name.text == i.my_class_name:
			Constant.warn(self, "新的班级名字和已有的班级名字重复了, 得要换一个才行")
			my_window.show()
			break
	
	var err_code := Interface.new_class(my_class_name.text, data_file_path.selected_path)
	if err_code == Interface.EXECUTE_SUCCESSFULLY_CODE:
		new_class_created.emit()
		Constant.warn(self, '新班级添加成功')
		my_class_name.text = ''
		data_file_path.selected_path = ''
	else:
		Constant.warn(self, "由于神秘因素的影响, 新班级创建失败, 错误代码[%d], 也许你想再试一次>?" % [err_code])
		my_window.show()
	
