import matplotlib.pyplot as plt

#function imported into plot_data.robot
#made to take a dictionary as argument containing genre name as key and number amount as value to create a plot and save it as png
def genres_plot(extracted_data):
    genre_dict = extracted_data

    genre_keys = list(genre_dict.keys())
    genre_values = list(genre_dict.values())

    fig, ax = plt.subplots(figsize=(11, 5))

    genres = genre_keys
    genre_counts = genre_values

    bar_container = ax.bar(genres, genre_counts)
    ax.set(ylabel='Genre Frequency', title='Most Played Genres')
    ax.bar_label(bar_container, fmt='{:,.0f}')

    plt.xticks(rotation=45, ha='right')

    plt.tight_layout()

    plt.savefig('output\playedgenres.png')