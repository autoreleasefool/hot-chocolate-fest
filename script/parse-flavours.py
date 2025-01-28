from bs4 import BeautifulSoup
import re

with open('data/flavours.html', 'r') as file:
    html = file.read()

soup = BeautifulSoup(html, 'html.parser')

def is_flavour_h3(tag):
    contents = [tag.string] if tag.string is not None else tag.stripped_strings
    return any(re.match(r'\s*#\d{3}', content) for content in contents)

flavours = [h3 for h3 in soup.find_all('h3') if is_flavour_h3(h3)]


# Find all h3 tags where html content begings with #000 and find all of their siblings
# flavours = soup.find_all('h3', string=lambda text: text is not None and re.match(r'\s*#\d{3}', text))
# print(len(flavours))
# for flavour in flavours:
#     print(flavour)

# print(soup.find_all('h3'))

# # flavours = soup.find_all('h3', string=lambda text: text is not None and text.startswith('#001'))
# # flavours = [flavour.find_next_siblings() for flavour in flavours]
# # print(flavours)
# # print(flavours[0])