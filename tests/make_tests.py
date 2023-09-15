import argparse
import glob
import os
import json
import re
import subprocess
import shutil


build_dir = './build'
fixture_dir = './tests/fixtures'

build_aux_file = os.path.join(build_dir, 'test.aux')
build_bbl_file = os.path.join(build_dir, 'test.bbl')
build_bib_file = os.path.join(build_dir, 'test.bib')
build_bst_file = os.path.join(build_dir, 'bib2json.bst')

test_bst_file = os.path.join('./tests/bib2json.bst')

multiLineWarning = re.compile(
    r'^Warning--(.+)\n--line (\d+) of file (.+)$', re.DOTALL | re.MULTILINE)
singleLineWarning = re.compile(
    r'^Warning--(.+) in ([^\s]+)\s*$', re.DOTALL | re.MULTILINE)
multiLineError = re.compile(
    r'^([^\n]*?)---line (\d+) of file (.*?)\nI\'m skipping whatever remains of this (command|entry)$', re.DOTALL | re.MULTILINE)
badCrossReference = re.compile(
    r'^(A bad cross reference---entry ".+?"\nrefers to entry.+?, which doesn\'t exist)$', re.DOTALL | re.MULTILINE)
multiLineCommandError = re.compile(
    r'/^(.*)\n?---line (\d+) of file (.+?)\nI\'m skipping whatever remains of this command$', re.DOTALL | re.MULTILINE)


def format_bibtex_output(output_str: str):
    execeptions = []

    num_errors = 0
    num_warnings = 0

    for m in re.finditer(singleLineWarning, output_str):
        execeptions.append({
            'level': 'warning',
            'message': m.group(1),
            # 'line': int(m.group(2)),
        })

    for m in re.finditer(multiLineWarning, output_str):
        execeptions.append({
            'level': 'warning',
            'message': m.group(1),
            'line': int(m.group(2)),
        })

    for m in re.finditer(multiLineError, output_str):
        execeptions.append({
            'level': 'error',
            'message': m.group(1),
            'line': int(m.group(2)),
        })

    for m in re.finditer(multiLineCommandError, output_str):
        execeptions.append({
            'level': 'error',
            'message': m.group(1),
            'line': int(m.group(2)),
        })

    for m in re.finditer(badCrossReference, output_str):
        execeptions.append({
            'level': 'error',
            'message': m.group(1),
            'line': int(m.group(2)),
        })

    return execeptions


def run_test(bib_file, print_output):
    bib_path = os.path.join(fixture_dir, bib_file)
    output_path = os.path.splitext(bib_path)[0] + '.json'

    shutil.copy(bib_path, build_bib_file)
    bibtex_output = subprocess.run(
        f'cd {build_dir}; bibtex test', shell=True, capture_output=True)
    bibtex_output = bibtex_output.stdout.decode()

    if print_output:
        print(bibtex_output)
    exceptions = format_bibtex_output(bibtex_output)
    if bib_file.startswith('error_') or bib_file.startswith('warning_'):
        assert len(exceptions) > 0

    with open(build_bbl_file) as f:
        bbl_content = f.read()
    bbl_content = re.sub(r'\n\s*', ' ', bbl_content)
    out = dict()
    out = json.loads(bbl_content)

    out['exceptions'] = exceptions

    with open(output_path, 'w') as f:
        json.dump(out, f, ensure_ascii=False, indent=4)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('files', nargs='*')
    parser.add_argument('-a', '--all', action='store_true')
    args = parser.parse_args()

    files = args.files
    if args.all or not files:
        files = list(glob.glob("*.bib", root_dir=fixture_dir))

    if os.path.exists(build_dir):
        shutil.rmtree(build_dir)
    os.makedirs(build_dir)
    with open(build_aux_file, 'w') as f:
        f.write('\\bibstyle{bib2json}\n\\citation{*}\n\\bibdata{test}\n')
    shutil.copy(test_bst_file, build_bst_file)

    for bib_file in files:
        run_test(bib_file, print_output=len(files) == 1)


if __name__ == '__main__':
    main()
