import json
from dataclasses import dataclass

@dataclass
class Location:
    name: str
    lat: float
    lon: float


@dataclass
class Section:
    name: str
    locations: list[Location]


with open('data/map.json') as f:
    data = json.load(f)

sections = []
data_sections = data[1][6]

for data_section in data_sections:
    section = Section(name=data_section[2], locations=[])

    for data_location in data_section[4]:
        lat = data_location[4][4][0]
        lon = data_location[4][4][1]
        name = data_location[5][0]

        section.locations.append(Location(name=name, lat=lat, lon=lon))

    sections.append(section)

with open('data/map-parsed.json', 'w') as f:
    json.dump(sections, f, default=lambda o: o.__dict__)