#!/usr/bin/env python3

from pathlib import Path
import re
import urllib.request as request
import os
import shutil

SCRIPT = Path(__file__).parent.absolute()
BUILD = SCRIPT.joinpath('build')
WHITELIST = SCRIPT.joinpath('whitelist.txt')
EXTERNAL = SCRIPT.joinpath('external.txt')

DOMAINS = BUILD.joinpath('domains.txt')
ADGUARD = BUILD.joinpath('adguard.txt')
UBLOCK = BUILD.joinpath('ublock.txt')

DOMAIN_PATTERN = re.compile(r'^((([a-zA-Z0-9\*]|[a-zA-Z0-9\*][a-zA-Z0-9\-\*]*[a-zA-Z0-9\*])\.)*([A-Za-z0-9\*]|[A-Za-z0-9\*][A-Za-z0-9\-\*]*[A-Za-z0-9\*]))$')
ABP_PATTERN = re.compile(r'^\|\|(.*)\^$')
COMMENT_PATTERN = re.compile(r'\s*([\!\#]|\/{2}).*$')

def download(url):
    response = request.urlopen(url)
    data = response.read()      # a `bytes` object
    text = data.decode('utf-8')
    return text

def read(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

def add_domains(domains, skipped, text):
    for line in text.splitlines(): 

        stripped = re.sub(COMMENT_PATTERN, '', line).strip()

        if stripped:
            m = re.match(DOMAIN_PATTERN, stripped)
            if m:
                domains.add(m.group(1))
                continue

            m = re.match(ABP_PATTERN, stripped)
            if m:
                domains.add(m.group(1))
                continue
            
            skipped.add(f'{url}: {stripped}')


domains = set()
skipped_ext = set()
skipped_int = set()

with open(EXTERNAL, 'r', encoding="utf-8") as f:
    for url in f:
        add_domains(domains, skipped_ext, download(url))
add_domains(domains, skipped_int, read(WHITELIST))

valid = set()
invalid = set()
for domain in domains:
    m = re.match(DOMAIN_PATTERN, domain)
    if m:
        valid.add(m.group(1))
    else:
        invalid.add(domain)


print(f'Valid: {len(valid)}')
print(f'Skipped (External): {len(skipped_ext)}')
print(f'Skipped (Internal): {len(skipped_int)}')
print(f'Invalid: {len(invalid)}')

if BUILD.is_dir():
    # BUILD.rmdir()
    shutil.rmtree(BUILD)
elif BUILD.is_file():
    BUILD.unlink()

BUILD.mkdir()

with open(UBLOCK, 'w', encoding="utf-8") as f:
    f.write('! Title: Personal Whitelist (Combined)\n')
    for domain in valid:
        f.write(f'@@||{domain}$document')
        f.write('\n')

with open(ADGUARD, 'w', encoding="utf-8") as f:
    f.write('! Title: Personal Whitelist (Combined)\n')
    for domain in valid:
        f.write(f'@@||{domain}$document')
        f.write('\n')

with open(DOMAINS, 'w', encoding="utf-8") as f:
    f.write('# Title: Personal Whitelist (Combined)\n')
    for domain in valid:
        f.write(domain)
        f.write('\n')

print()
# print("Skipped (External):")
# for x in skipped_ext:
#     print(x)
# print()
print("Skipped (Internal):")
for x in skipped_int:
    print(x)
print()
print("Invalid:")
for x in invalid:
    print(x)
