import ast
import sys

try:
    with open('backendCoformacion/coformacion/views.py', 'r', encoding='utf-8') as f:
        code = f.read()
    ast.parse(code)
    print("✓ No syntax errors found")
except SyntaxError as e:
    print(f"✗ Syntax Error found:")
    print(f"  Line {e.lineno}: {e.msg}")
    if e.text:
        print(f"  Text: {e.text.rstrip()}")
        if e.offset:
            print(f"  {' ' * (e.offset - 1)}^")
    sys.exit(1)
