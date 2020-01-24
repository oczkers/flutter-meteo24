import requests
import re
# import time
import json

try:
    with open('cities.json', 'r') as f:
        cities = json.load(f)
except FileNotFoundError:
    cities = {}


def save(cities):
    # cities = {key: value for key, value in sorted(cities.items())}  # sort alphabetically # done by sort_keys
    with open('cities.json', 'w', encoding='utf8') as f:
        json.dump(cities, f, ensure_ascii=False, sort_keys=True, indent=4)
        # f.write(json.dumps(cities))


rc = requests.get('https://www.meteo.pl/um/php/gpp/search.php')
rc.encoding = 'ISO-8859-2'
rc = rc.text
for province in re.findall(r'<option[selected\ ]*? value=([A-Z]{2})> (.+) \n', rc):
    data = {'woj': province[0],
            'litera': ''}
    rc = requests.post('https://www.meteo.pl/um/php/gpp/next.php', data=data)
    rc.encoding = 'ISO-8859-2'
    rc = rc.text
    for i in re.findall(r"onClick='show_mgram\(([0-9]+)\)'>(.+?)</a>", rc):
        id = i[0]
        try:
            cityname, county = i[1].split(',')
        except ValueError:
            cityname = i[1]
            county = ''

        # TODO: duplicates are here, pick one with more info
        if cityname in cities:
            continue

        params = {'ntype': '0u', 'id': i[0]}
        rc = requests.get('https://www.meteo.pl/um/php/meteorogram_id_um.php', params=params).text
        open('scrap.log', 'w').write(rc)  # logging for debug
        rcc = re.search('var act_x = ([0-9]+);var act_y = ([0-9]+);', rc)
        col = rcc.group(1)
        row = rcc.group(2)
        cities[cityname] = {'id': id,
                            'country': 'Polska',
                            'province_id': province[0],
                            'province': province[1],
                            'county': county,
                            'col': col,
                            'row': row}
        print(f'{cityname} {cities[cityname]}')
        save(cities)  # in case of unexpected error
        # time.sleep(1)

rc = requests.get('https://www.meteo.pl/meteorogram_um.php')
rc.encoding = 'ISO-8859-2'
rc = rc.text
for i in re.findall(r'"showMgram\([0-9]+,([0-9]+),([0-9]+),\'.+?\'\)">(.+?)</div>', rc):
    cityname = i[2]
    col = i[0]
    row = i[1]
    if cityname in cities:
        continue
    cities[cityname] = {'id': None,
                        'country': None,
                        'province_id': None,
                        'province': None,
                        'county': None,
                        'col': col,
                        'row': row}
    print(f'{cityname} {cities[cityname]}')

save(cities)
