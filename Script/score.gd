extends Resource

var s: Array:
	set(val):
		assert(val is Array)
		s = []
		for i in range(Constant.SUBJECT_NUM):
			s.append(-1)
		for i in range(min(Constant.SUBJECT_NUM, val.size())):
			assert(val[i] is int)
			s[i] = val[i]

func _init(val: Array = []):
	s = val

func get_score_by_id(id: int) -> float:
	assert(id >= 0 and id < Constant.SUBJECT_NUM)
	return s[id]
