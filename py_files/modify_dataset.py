import json
#dataset taken from: https://www.kaggle.com/datasets/fronkongames/steam-games-dataset
#this script is used to dispose the unneeded content from the dataset


def sort_dataset():
    with open('games.json', 'r', encoding='utf-8') as file:
        data = json.load(file)

    keys_to_remove = [
        "release_date",
        "required_age",
        "dlc_count",
        "detailed_description",
        "about_the_game",
        "short_description",
        "reviews",
        "header_image",
        "website",
        "support_url",
        "support_email",
        "windows",
        "mac",
        "linux",
        "metacritic_score",
        "metacritic_url",
        "achievements",
        "recommendations",
        "notes",
        "user_score",
        "score_rank",
        "estimated_owners",
        "average_playtime_forever",
        "average_playtime_2weeks",
        "median_playtime_forever",
        "median_playtime_2weeks",
        "peak_ccu",
        "movies",
        "screenshots",
        "developers",
        "supported_languages",
        "full_audio_languages",
        "publishers",
        "categories",
        "positive",
        "negative",
        "tags",
        "packages"
    ]

    for key in keys_to_remove:
        for item in data.values():
            if key in item:
                del item[key]

    with open('games.json', 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=4)


if '__name__' == '__main__':
    sort_dataset()