from enum import IntEnum, auto
from typing import List
from copy import deepcopy


# 似乎也许我应该把 subject 和 name, num, score limit 设置为 score 类的常量
class Subject(IntEnum):
    CN = 0
    MATH = auto()
    EN = auto()
    PHYSICS = auto()
    CHEMISTRY = auto()
    BIOLOGY = auto()
    POLITICS = auto()
    HISTORY = auto()
    GEOGRAPHY = auto()

SUBJECT_NUM: int = 9
SUBJECT_NAME: List[str] = [
    "语文",
    "数学",
    "英语",
    "物理",
    "化学",
    "生物",
    "道法",
    "历史",
    "地理",
]
SUBJECT_SCORE_LIMIT: List[str] = [
    "120",
    "120",
    "120",
    "100",
    "100",
    "100",
    "100",
    "100",
    "100",
    "100",
    "100",
]


class Score:
    min_width: int = 3
    def __init__(self, score: List[float] = []) -> None:
        self.__score: list = []
        for i in range(SUBJECT_NUM):
            self.__score.append(-1)
        for i in range(min(SUBJECT_NUM, len(score))):
            self.__score[i] = score[i]


    def get_score_by_id(self, id: Subject) -> float:
        return self.__score[id]


    def set_score_by_id(self, id: Subject, val: float) -> None:
        self.__score[id] = val


    def __deepcopy__(self, memo: dict):
        new_obj = Score(deepcopy(self.__score, memo))
        memo[id(self)] = new_obj
        return new_obj


    def __str__(self) -> str:
        val: str = ''
        for i in range(SUBJECT_NUM):
            if self.__score[i] == -1:
                continue;
            val += f'{SUBJECT_NAME[i]}:{self.__score[i]:{Score.min_width}g}'
            if i + 1 != SUBJECT_NUM:
                val += ', '
        return val
        # return ', '.join(f'[{SUBJECT_NAME[i]}:{self.__score[i]:{Score.min_width}}]' for i in range(SUBJECT_NUM) if self.__score[i] != -1)


class TestInfo:
    def __init__(self, name: str = "", score: Score = Score()) -> None:
        self.__name: str = name
        # self.name = name
        self.__score: Score = deepcopy(score)
        # self.score = deepcopy(score)


    def get_name(self) -> str:
        return self.__name


    def set_name(self, name: str) -> None:
        self.__name = name


    def get_score(self) -> Score:
        score = self.__score
        return self.__score


    def set_score(self, score: Score) -> None:
        self.__score = deepcopy(score)


    def __str__(self) -> str:
        if self.__name == "base":
            return ""
        return f'{self.__name} : {self.__score}'


    # def __deepcopy__(self, mem: dict):
    #     new_test = TestInfo(deepcopy((self.__name, self.__score), mem))
    #     mem[id(self)] = new_test
    #     return new_test


class Student:
    min_width: int = 2
    def __init__(self, name: str = "") -> None:
        self.__name: str = name
        Student.min_width = min(4, max(len(name), Student.min_width))
        self.__test: List[TestInfo] = []


    def get_test(self, id: int) -> TestInfo:
        return self.__test[id]


    def get_test_num(self) -> int:
        return len(self.__test)
        # 在实际使用中, 第一个 test_info(self.__test[0]) 只是辅助用的, 并非具体考试, 不会显示


    def push_test_back(self, test_info: TestInfo) -> None:

        self.__test.append(deepcopy(test_info))


    def pop_test_back(self) -> None:
        self.__test.pop()


    def get_name(self) -> str:
        return self.__name


    def set_name(self, name: str) -> None:
        self.__name = name


    # 支持 2 ~ 4 个纯中文字符名字的格式化
    @staticmethod
    def __format_name(s: str) -> str:
        if Student.min_width == 3:
            if len(s) == 2:
                s = '  '.join(s)
        elif Student.min_width == 4:
            if (len(s) == 2):
                s = '    '.join(s)
            elif (len(s) == 3):
                s = ' '.join(s)
        return s


    @staticmethod
    def set_name_min_width(t: int) -> None:
        Student.min_width = min(4, max(2, t))


    def __deepcopy__(self, memo: dict):
        new_obj = Student(deepcopy((self.__name, self.__test), memo))
        memo[id(self)] = new_obj
        return new_obj


    def __str__(self) -> str:
        val: str = Student.__format_name(self.__name)
        for i in range(len(self.__test)):
            val += f'{self.__test[i]}'
            if i + 1 != len(self.__test):
                val += '\n' + '  ' * Student.min_width + ' - '
        return val
        # return Student.__format_name(self.__name) + ' : ' + ', '.join(map(str, self.__test))


    def __lt__(self, other) -> bool:
        return self.__name < other.__name






















