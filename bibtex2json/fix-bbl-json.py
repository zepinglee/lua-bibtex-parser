import argparse
import json
import re


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('filename')
    args = parser.parse_args()

    with open(args.filename) as f:
        content = f.read()

    content = re.sub(r'\n\s*', ' ', content)

    data = json.loads(content)

    with open(args.filename, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        f.write('\n')


if __name__ == '__main__':
    main()
