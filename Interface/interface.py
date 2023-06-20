from typing import List
from os import listdir, remove
from argparse import ArgumentParser

from score_structure import SUBJECT_NUM, SUBJECT_NAME, Student
from format_data import save_data, load_data, merge, standardize_dir
from format_data import extract_base_data_from_wookbook, extract_data_from_wookbook
from format_data import extract_test_name_from_data, extract_student_name_from_data
from format_data import export_line_chart, convert_xlsx_to_pdf

# 在实现中, 一个班级的所有信息都在一个 List[Student] 中, 所以一个文件足以存放一个班级的所有信息
# 或者也可以说只能用一个文件来存放比较合适, 无法拆成多个文件还易用
# 如果哪天重构, 重构成 对应的 gd4 项目里的那种数据结构, 就可以有比较优雅的存档文件了
# 另外, 重构的时候注意区分 file_path 和 dir_path, 在参数名称里写明

save_file_suffix: str = '.dat'
# 以后可以考虑使用 pathlib 来处理路径相关

def new_class(args: List):
    base_data: List[str] = extract_base_data_from_wookbook(args.data_file_path)
    save_data(args.save_file_path, base_data)


def new_test(args: List):
    new_data: List[str] = extract_data_from_wookbook(args.data_file_path, args.geo_bio_point_scale, args.test_name)
    ori_data: List[str] = load_data(args.save_file_path)
    merge(ori_data, new_data)
    save_data(args.save_file_path, ori_data)


def get_class(args: List):
    for file_name in listdir(args.save_dir_path):
        if save_file_suffix in file_name:
            print(file_name.split('.')[0])


def get_test(args: List):
    data = load_data(args.save_file_path)
    name_list: List[str] = extract_test_name_from_data(data)[1:]
    # print(','.join(name_list))
    for i in name_list:
        print(i)

# 应该把 get test 和 get stu name 合并成一个函数, 即使对数据结构进行了重构
def get_student_name(args: List):
    data = load_data(args.save_file_path)
    name_list: List[str] = extract_student_name_from_data(data)
    for i in name_list:
        print(i)


def get_score(args: List):
    data = load_data(args.save_file_path)
    for stu in data:
        if stu.get_name() == args.stu_name:
            for i in range(1, stu.get_test_num()):
                if stu.get_test(i).get_name() == args.test_name:
                    score = stu.get_test(i).get_score()
                    print('\n'.join(str(score.get_score_by_id(i)) for i in range(SUBJECT_NUM)))


def export(args: List):
    # 可以考虑把寻找 stu 的功能抽离成单独的函数
    # 可以考虑在 argparse 解析时就准备好 stu 和 mask
    stu: Student
    data = load_data(args.save_file_path)
    for i in data:
        if i.get_name() == args.stu_name:
            stu = i
            break

    if args.export_file_basename == 'auto':
        args.export_file_basename = args.stu_name + SUBJECT_NAME[args.sub_id] + '成绩分析'
    # 以后可以加一个功能, 允许输出的图表不包含标题

    mask: List[int] = list(map(int, args.mask_str.split(',')))
    xlsx_file_path: str = args.export_dir_path + args.export_file_basename + '.xlsx'
    pdf_file_path: str = args.export_dir_path + args.export_file_basename + '.pdf'

    export_line_chart(xlsx_file_path, stu, args.sub_id, mask, args.geo_bio_point_scale)
    if 'pdf' in args.export_format:
        convert_xlsx_to_pdf(xlsx_file_path, pdf_file_path, args.api_provider)
    if not 'xlsx' in args.export_format:
        remove(xlsx_file_path)


def main():
    parser: ArgumentParser = ArgumentParser(description = 'Interface used by DisplayScoreInLineChart.exe. Developing in python.')

    parser.add_argument('save_dir_path', type=standardize_dir)
    sub_parser = parser.add_subparsers()

    nc = sub_parser.add_parser('nc')
    nc.add_argument('class_name')
    nc.add_argument('data_file_path', type=standardize_dir)
    nc.set_defaults(func=new_class)

    nt = sub_parser.add_parser('nt', help='create new class')
    nt.add_argument('class_name')
    nt.add_argument('test_name')
    nt.add_argument('data_file_path', type=standardize_dir)
    nt.set_defaults(func=new_test)

    gc = sub_parser.add_parser('gc', help='get class names')
    gc.set_defaults(func=get_class)

    gt = sub_parser.add_parser('gt', help='get test names of a certain class')
    gt.add_argument('class_name')
    gt.set_defaults(func=get_test)

    gsn = sub_parser.add_parser('gsn', help='get student names of a certain class')
    gsn.add_argument('class_name')
    gsn.set_defaults(func=get_student_name)

    gsc = sub_parser.add_parser('gsc', help='get a student''s score of all subjects')
    gsc.add_argument('class_name')
    gsc.add_argument('test_name')
    gsc.add_argument('stu_name')        # 位置参数似乎不支持手动再设置一个 dest, 这有点不好用, 也许还有其它参数可以达到这个目的>?
    gsc.set_defaults(func=get_score)

    ep = sub_parser.add_parser('ep', help='export specified data to xlsx or pdf')
    ep.add_argument('class_name')
    ep.add_argument('mask_str', help='test mask, 1 for yes and 0 for no, should be like 1,0,0,1,1')
    ep.add_argument('sub_id', type=int)
    ep.add_argument('stu_name')
    ep.add_argument('export_dir_path', type=standardize_dir)
    ep.add_argument('export_file_basename')
    ep.add_argument('export_format')
    ep.add_argument('geo_bio_point_scale', type=int)
    ep.add_argument('api_provider', choices=['ms', 'wps'])
    ep.set_defaults(func=export)

    args = parser.parse_args()
    if not hasattr(args, 'class_name'):
        args.class_name = ''
    args.save_file_path = args.save_dir_path + args.class_name + save_file_suffix
    args.func(args)
    # 如果哪天闲得想重构, 可以把 args 解包(这样用: args.func(**args)), 然后修改相应函数的函数头


if __name__ == '__main__':
    main()