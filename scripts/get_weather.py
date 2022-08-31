import urllib.request
import json
import math

weather_codes = {
    "sun"       : [0],
    "clouds1"   : [1],
    "clouds2"   : [2],
    "clouds3"   : [3],
    "fog"       : [45,48],
    "rain1"     : [51,56,61,66,80],
    "rain2"     : [53,   63,   81],
    "rain3"     : [55,57,65,67,82],
    "snow1"     : [71,85   ],
    "snow2"     : [73,   77],
    "snow3"     : [75,86   ],
    "storm2"    : [95],
    "storm3"    : [96,99]
}

def process_weather_code(code):
    code = int(code)

    for (key, valid_codes) in weather_codes.items():
        if code in valid_codes:
            return key

    return "WHAT"


def process_current_weather(response):
    current = response["current_weather"]
    temperature = current["temperature"]
    wind_speed = current["windspeed"]
    wind_direction_degrees = current["winddirection"]
    weather_code = current["weathercode"]

    wind_direction = [
        "N","NE","E","SE","S","SW","W","NW"
    ] [math.floor(((wind_direction_degrees+22.5) % 360) / 45)]

    return f"{temperature},{wind_speed},{wind_direction},{process_weather_code(weather_code)},"


if __name__ == "__main__":
    url = [
        "https://api.open-meteo.com/v1/",
        "forecast?latitude=59.3328&longitude=18.0645",
        "&",
        "daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum",
        "&",
        "current_weather=true",
        "&",
        "timezone=Europe%2FBerlin"
    ]

    response = urllib.request.urlopen("".join(url))

    response = json.load(response)

    print(process_current_weather(response))
