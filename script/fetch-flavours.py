import requests
from bs4 import BeautifulSoup
import re
from dataclasses import dataclass

directory_url = 'https://hotchocolatefest.com/vendor-directory/'
headers = { 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36' }
page = requests.get(directory_url, headers=headers)

soup = BeautifulSoup(page.content, 'html.parser')

vendor_names = soup.find_all('h4', class_='elementor-heading-title')
vendor_links = []
for vendor_name in vendor_names:
    vendor = vendor_name
    while vendor and not vendor.has_attr('href'):
        vendor = vendor.parent
    if vendor:
        vendor_links.append(vendor['href'])

def is_flavour_h3(tag):
    contents = [tag.string] if tag.string is not None else tag.stripped_strings
    return any(re.match(r'\s*#\d{3}', content) for content in contents)

@dataclass
class Flavour:
    name: str
    description: str
    vendor_name: str
    vendor_url: str

flavours = []

for vendor_link in vendor_links:
    vendor_page = requests.get(vendor_link, headers=headers)
    vendor_soup = BeautifulSoup(vendor_page.content, 'html.parser')

    flavour_title_tags = [tag for tag in vendor_soup.find_all('h3') if is_flavour_h3(tag)]
    for title_tag in flavour_title_tags:
        title = title_tag.get_text(strip=True)
        description = ''
        description_tag = title_tag.next_sibling
        while description_tag is not None and description_tag.name != 'h3':
            description += description_tag.get_text(strip=True) + '\n'
            description_tag = description_tag.next_sibling

        flavour = Flavour(
            name=title,
            description=description,
            vendor_name=vendor_soup.find('h1', class_='elementor-heading-title').string,
            vendor_url=vendor_link
        )

        print(flavour)
        flavours.append(flavour)

print(flavours)

# Output flavours to JSON
import json

with open('data/flavours-parsed.json', 'w') as f:
    json.dump(flavours, f, default=lambda o: o.__dict__)
