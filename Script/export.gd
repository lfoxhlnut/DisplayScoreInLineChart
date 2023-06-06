extends Control

# 我感觉我这里的写法有些丑陋, 但是不知道怎么改进
var selected_class_name: String:
	get:
		if class_list.selected_id == []:
			return ""
		var selected_class: ClassInfo = class_info[class_list.selected_id[0]]
		return selected_class.my_class_name

var selected_test_mask: Array[int]:
	get:
		return test_list.button_flag

var selected_test_name: String:
	get:
		if test_list.selected_id == [] or class_list.selected_id == []:
			return ""
		var test_id: int = test_list.selected_id[0]
		var selected_class: ClassInfo = class_info[class_list.selected_id[0]]
		return selected_class.get_test(test_id)

var selected_student_name: String:
	get:
		if student_grid.selected_id == [] or class_list.selected_id == []:
			return ""
		var stu_id: int = student_grid.selected_id[0]
		var selected_class: ClassInfo = class_info[class_list.selected_id[0]]
		return selected_class.get_student(stu_id)

var selected_subject_id: int:
	get:
		return $SubIndication/SubjectOption.selected_subject_id

var export_format: String:
	get:
		return $ExportFormat.export_format

var export_dir_path: String:
	get:
		return $ExportPath.selected_path

var export_file_name: String	# 本来应该再做一个设置输出文件名称的功能, 现在懒得做了

var geo_bio_point_scale: int:
	get:
		return $GeoBioPointScale.point_scale

var api_provider: String:
	get:
		return $ApiProvider.api_provider

var class_info: Array[ClassInfo]

@onready var class_list = $ClassList
@onready var test_list = $TestList
@onready var student_grid = $StudentGrid
@onready var subject_option = $SubIndication/SubjectOption
@onready var export_info_preview = $ExportInfoPreview


func _ready():
	$ExportPath/FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)


func update(new_class_info: Array[ClassInfo]) -> void:
	class_info = new_class_info
	class_list.update(class_info)


func _on_export_pressed() -> void:
	if not examine_data():
		return
	
	var err_code := Interface.export(
		selected_class_name,
		selected_test_mask,
		selected_subject_id,
		selected_student_name,
		export_dir_path,
		'auto',
		export_format,
		geo_bio_point_scale,
		api_provider)
	if err_code == Interface.EXECUTE_SUCCESSFULLY_CODE:
		Constant.warn(self, '导出成功, 快去看看吧')
	else:
		Constant.warn(self, '导出失败, 不知道为什么, 错误代码[%d]' % [err_code])


func examine_data() -> bool:
	var warn_message := ''
	if selected_class_name == '':
		warn_message += '|需要选一个班级|\n'
	if selected_student_name == '':
		Constant.warn(self, '|需要选择一个学生, 不选学生的话该输出谁的数据呢|\n')

	if selected_test_mask.all(func(i: int): return not i):
		warn_message += '至少得选择一个考试\n'
	
	if export_dir_path == "":
		warn_message += '输出路径呢, 需要输出文件夹的位置\n'
	
	if selected_subject_id in [Constant.Subject.BIOLOGY, Constant.Subject.GEOGRAPHY]\
		and geo_bio_point_scale == 0:
		warn_message += '如果选的是地理或者生物的话, 需要选择一下地理生物的最高分数\n'
		
	if warn_message != "":
		Constant.warn(self, warn_message)
		return false
	
	# 其他的数据都有默认值, 不会是空的
	return true


func _on_preview_pressed():
	'%s%s成绩分析:' % [selected_student_name, Constant.SUBJECT_NAME[selected_subject_id]]
	export_info_preview.text = '没做完😊, 不想做了'


func _on_class_list_class_selected(id: int):
	test_list.update(class_info[id])
	student_grid.update(class_info[id])
