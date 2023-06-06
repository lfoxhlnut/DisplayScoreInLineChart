from sys import exit
import sys
import os
from typing import List
from score_structure import Score, Student, Subject, SUBJECT_NAME, SUBJECT_NUM, TestInfo
from format_data import format_data_from_wookbook, format_base_data_from_wookbook
from format_data import extract_student_name_from_data, extract_test_name_from_data
from format_data import load_data, save_data, merge
from format_data import draw_line_chart, convert_xlsx_to_pdf
from format_data import standardize_dir

args = sys.argv

# 应该搞一个返回代码的, 不是应该, 是必须

# --nc class_name, data_file_path, save_dir_path
# nc means new class
# print nothing

# --nt class_name, test_name, data_file_path, geo_bio_point_scale, save_dir_path
# nt means new test
# append new data to old data
# do nothing when class_name does not exist(perhaps)
# geo_bio_point_scale should be in [50, 100]
# print nothing

# --gc save_dir_path
# get class names table
# print string like 'classname1\nclassname2'

# --gt class_name, save_dir_path
# get test names table
# print string like 'testname1\ntestname2'

# --gsn class_name, save_dir_path
# get student names table
# print string like 'stuname1\nstuname2'

# --gsc class_name, test_name, student_name, save_dir_path
# get score of all subjects
# print string like '11\n22'(print -1 if corresponding subject has no data)

# --ep class_name, test_mask, subject_id, student_name, export_dir_path, export_file_name_without_suffix, export_format, geo_bio_point_scale, api_provider, save_dir_path
# export data
# test_mask should be like '1,1,0,1,0'
# export_format should be in ['pdf', 'xlsx', 'pdfxlsx']
# geo_bio_point_scale should be in [50, 100]
# api_provider should be in ['ms', 'wps'] if 'pdf' in export_format
# print nothing

# 我的设计和吃了屎一样, 应该把 save_dir_path 用作第二个参数的(第一个是 '--xx')
# 不对, 更重要的问题是, 我也许应该找一个参数解析器类似的东西

# 目录的路径表示有些麻烦, 必须转成符合要求的形式, 我还没搞太明白 \ 和 /, 不过所写的 standardize_dir 函数目前是够用的

command: str = args[1][2:]
save_dir_path: str = ''
my_class_name: str = ''

save_dir_path = args[-1]
save_dir_path = standardize_dir(save_dir_path)

if command != 'gc':
    my_class_name = args[2]

# 在实现中, 一个班级的所有信息都在一个 List[Student] 中, 所以一个文件足以存放一个班级的所有信息
# 或者也可以说只能用一个文件来存放比较合适, 无法拆成多个文件还易用
# 如果哪天重构, 重构成 对应的 gd4 项目里的那种数据结构, 就可以有比较优雅的存档文件了
save_file_path: str = save_dir_path + my_class_name + '.dat'
# 另外, 重构的时候注意区分 file_path 和 dir_path, 在参数名称里写明

if command == 'nc':
    data_file_path: str = args[3]
    new_data: List[str] = format_base_data_from_wookbook(data_file_path)
    save_data(save_file_path, new_data)
    for i in new_data:
        print(i)
    exit()

if command == 'nt':
    test_name: str = args[3]
    data_file_path: str = args[4]
    geo_bio_point_scale: int = int(args[5])
    new_data: List[str] = format_data_from_wookbook(data_file_path, geo_bio_point_scale, test_name)
    ori_data: List[str] = load_data(save_file_path)
    merge(ori_data, new_data)
    save_data(save_file_path, ori_data)
    for i in ori_data:
        print(i)
    exit()

if command == 'gc':
    class_name_list: List[str] = os.listdir(save_dir_path)
    # print(','.join(class_name_list))
    for i in class_name_list:
        if '.dat' in i:
            print(i.split('.')[0])
    exit()

if command == 'gt' or command == 'gsn':
    data = load_data(save_file_path)
    name_list: List[str]
    if command == 'gt':
        name_list = extract_test_name_from_data(data)[1:]
    else:
        name_list = extract_student_name_from_data(data)
    # print(','.join(name_list))
    for i in name_list:
        print(i)
    exit()

if command == 'gsc':
    test_name: str = args[3]
    stu_name: str = args[4]
    data = load_data(save_file_path)
    for stu in data:
        if stu.get_name() == stu_name:
            for i in range(1, stu.get_test_num()):
                if stu.get_test(i).get_name() == test_name:
                    score = stu.get_test(i).get_score()
                    print('\n'.join(str(score.get_score_by_id(i)) for i in range(SUBJECT_NUM)))

if command == 'ep':
    mask_str: str = args[3]
    sub_id: int = int(args[4])
    stu_name: str = args[5]
    dir_path: str = args[6]
    dir_path = standardize_dir(dir_path)
    print(dir_path, ' is dir_path')
    print(save_dir_path, ' is save_dir_path')
    
    file_name: str = args[7]
    format: str = args[8]
    geo_bio_point_scale: int = int(args[9])
    api_provider: str = args[10]

    stu: Student
    data = load_data(save_file_path)
    for i in data:
        if i.get_name() == stu_name:
            stu = i
            break
    if file_name == 'auto':
        file_name = stu_name + SUBJECT_NAME[sub_id] + '成绩分析'

    mask: List[int] = list(map(int, mask_str.split(',')))
    xlsx_file_path: str = dir_path + file_name + '.xlsx'
    pdf_file_path: str = dir_path + file_name + '.pdf'
    draw_line_chart(xlsx_file_path, stu, sub_id, mask, geo_bio_point_scale)
    if 'pdf' in format:
        convert_xlsx_to_pdf(xlsx_file_path, pdf_file_path, api_provider)
    if not 'xlsx' in format:
        os.remove(xlsx_file_path)

    exit()