import pandas as pd

#function that is imported in to the main robot file which handles creating a HTML doc out of the CSV files
def create_html(player_summaries_csv, o_games_existence):

    #using pandas user data CSV is rotated and converted to an HTML table
    summ_data = pd.read_csv(player_summaries_csv, header=None)
    summ_data_rotated = summ_data.transpose()
    user_html = summ_data_rotated.to_html(index=False, header=False, justify='justify-all', escape=False)

    #configuration of the looks of HTML table
    user_html = user_html.replace('<table', '<table style="width: 35%; height: 350px; margin-left: auto; margin-right: auto; text-align: center;"')

    #if owned games CSV exists then an HTML containing the plot and the list of owned games will be created
    if o_games_existence == True: 

        og_data = pd.read_csv('output/o_games.csv')
        og_data = og_data.to_html(index=False, justify='center')
        og_data = og_data.replace(
            '<table', '<table style="margin-left: auto; margin-right: auto; text-align: center;"')

        with open('output/o_games.html', 'w', encoding='UTF*8') as f:
            f.write(og_data)
        
        hyperlink = '<p style="text-align:center"><a href="o_games.html" target="_blank">List of all user owned games and their playtime in hours</a></p>'
        plotimage_genres = '<center><img src="playedgenres.png" alt="genre count"></center></br>'
        html = user_html + hyperlink + plotimage_genres

        with open('output/user_doc.html', 'w', encoding='UTF-8') as f:
            f.write(html)

    #otherwise if not then an HTML containing only user data will be created
    else:
        with open('output/user_doc.html', 'w', encoding='UTF-8') as f:
            f.write(user_html)
