extends Resource
class_name ClassInfo

const MAX_TEST_NUM := 100
const MAX_STUDENT_NUM := 64

var my_class_name: String
var test_name := []:
	set(val):
		if val.size() < MAX_TEST_NUM:
			test_name = val
		else:
			test_name = []
			for i in range(MAX_TEST_NUM):
				test_name.append(val[i])
		# 也许还可以发个信号通知改变了, 不过感觉没必要
var student_name := []:
	set(val):
		if val.size() < MAX_STUDENT_NUM:
			student_name = val
		else:
			student_name = []
			for i in range(MAX_STUDENT_NUM):
				student_name.append(val[i])

var test_num: int:
	get:
		return test_name.size()
var student_num: int:
	get:
		return student_name.size()


func _init(n: String = "no_class_name", t := [], s := []):
	my_class_name = n
	test_name = t
	student_name = s

func get_test(idx: int) -> String:
	return test_name[idx]


func get_student(idx: int) -> String:
	return student_name[idx]


func _to_string() -> String:
	var info := 'class_name:[' + my_class_name
	info += '], test name:[' + ', '.join(test_name)
	info += '], student name:[' + ', '.join(student_name) + ']'
	return info


# Resource 类的 duplicate() 在自定义的 Resource 子类上似乎有问题, 于是只好手动深复制
func deepcopy() -> ClassInfo:
	var dst := ClassInfo.new(my_class_name)
	dst.test_name = test_name.duplicate()	# 这是数组的深复制, 没问题
	dst.student_name = student_name.duplicate()
	return dst
