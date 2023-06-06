*** Settings ***
Documentation
...                 Using steam API gather transfromed user data, generate a plot for game genres and make an HTML to show the results

Resource            shared.robot
Resource            owned_games.robot
Resource            player_summaries.robot
Resource            plot_data.robot
Resource            keys.robot


*** Tasks ***
Gather Data and Create a Document
    Produce API Data    ${STEAM_API_KEY}    ${USER_STEAM_ID}
    Produce Plot Data and Create HTML


*** Keywords ***
Produce API Data
    [Documentation]    Run functions from owned_games.robot and player_summaries.robot to call apis and transform user data
    [Arguments]    ${web_key}    ${id}
    Run Keyword    Produce Owned Games    ${web_key}    ${id}
    Run Keyword    Produce Player Summaries    ${web_key}    ${id}

Produce Plot Data and Create HTML
    [Documentation]    Run functions from plot_data.robot and make_html.py to create a plot and then an HTML afterwards
    ...    An HTML is generated accordingly if the user owned games data is private or not
    ${o_games_csv_exists}=    Does File Exist    ${OWNED_GAMES_CSV_PATH}
    IF    ${o_games_csv_exists} == ${True}
        ${genres_dict}=    Run Keyword    Extract Genre Count
        Generate Plot    ${genres_dict}
    END
    Create Html    ${PLAYER_SUMMARIES_CSV_PATH}    ${o_games_csv_exists}
