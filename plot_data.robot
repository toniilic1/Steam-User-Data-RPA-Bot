*** Settings ***
Documentation    Gather the needed data from games.json, and return it in a dictionary
Resource    shared.robot


*** Keywords ***
Extract Genre Count
    [Documentation]    Get all the user owned games appids and find them inside the games.json dataset 
    ...    Count games for each genre and place it in a dictionary for plot generation
    ${table}=    Read table from CSV    ${OWNED_GAMES_CSV_PATH}    encoding=UTF-8
    ${user_appids}=    Get Table Column    ${table}    appid
    ${dataset_json}=    Load JSON from file    ${PLOT_DATA_JSON_PATH}
    ${library}=    Create Dictionary
    FOR    ${appid}    IN    @{user_appids}
        TRY
            ${app_genre_list}=    Set Variable    ${dataset_json}[${appid}][genres]
            FOR    ${index}    ${genre}    IN ENUMERATE    @{app_genre_list}
                TRY
                    Get From Dictionary    ${library}    ${genre}
                    ${addittion}=    Evaluate    ${library}[${genre}] + 1
                    Set To Dictionary    ${library}    ${genre}    ${addittion}
                EXCEPT
                    ${creation}=    Evaluate    int(1)
                    Set To Dictionary    ${library}    ${genre}    ${creation}
                END
            END
        EXCEPT
            CONTINUE
        END
    END
    RETURN    ${library}

Generate Plot
    [Documentation]    Run a function from generate_plot.py to create a plot comparing the game count of each genre
    [Arguments]    ${genres_dict}
    Genres Plot    ${genres_dict}