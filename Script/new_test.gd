extends Button

signal new_test_created

@onready var class_list = $MyWindow/ClassList
@onready var my_window = $MyWindow
@onready var test_name = $MyWindow/TestName
@onready var data_file_path = $MyWindow/DataFilePath
@onready var geo_bio_point_scale = $MyWindow/GeoBioPointScale
@onready var test_list = $MyWindow/TestList

func update(new_class_info: Array[ClassInfo]) -> void:
	class_list.update(new_class_info)


func _on_pressed():
	my_window.show()


# 我希望有一天能修改成可以识别出这些 onready 变量的类型, 和他们的方法和变量
# 然后消除下面的非安全行
func _on_my_window_confirmed():
	if class_list.selected_id == []:
		Constant.warn(self, "需要先选一下在哪一个班级创建新考试")
		my_window.show()
		return
	print('in new test, selected class id is: ', class_list.selected_id)
	var class_id: int = class_list.selected_id[0]
	var selected_class: ClassInfo = class_list.class_info[class_id]
	var my_class_name: String = selected_class.my_class_name
	
	if data_file_path.selected_path == "":
		Constant.warn(self, "没选数据文件的话去哪里搞数据呢, 选一下吧")
		my_window.show()
		return
	
	if geo_bio_point_scale.point_scale == 0:
		Constant.warn(self, "需要选一下地理生物的最高分数, 这个数据还挺重要的")
		my_window.show()
		return
	
	if test_name.text == "":
		test_name.text = (data_file_path.selected_path as String).get_file().get_basename()
	
	for i in selected_class.test_name:
		if i == test_name.text:
			Constant.warn(self, "和已有的考试名称重复, 这似乎是不可行的, 选个别的名字吧")
			my_window.show()
			return
	
	var err_code := Interface.new_test(my_class_name,
		test_name.text,
		data_file_path.selected_path,
		geo_bio_point_scale.point_scale)
	
	if err_code == Interface.EXECUTE_SUCCESSFULLY_CODE:
		new_test_created.emit()
		Constant.warn(self, '新考试添加成功成功')
		test_name.text = ''
		data_file_path.selected_path = ''
	else:
		Constant.warn(self, "出现了一些问题, 新考试并未创建成功, 错误代码[%d]. 不过不用着急." % [err_code])
		my_window.show()



func _on_class_list_class_selected(id: int):
	test_list.update(class_list.class_info[id])
