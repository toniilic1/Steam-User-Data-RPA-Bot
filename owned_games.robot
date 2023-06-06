*** Settings ***
Documentation    Call user owned games data using steam API and conver the data 

Resource    shared.robot
Library    RPA.FileSystem

*** Keywords ***
Produce Owned Games
    [Documentation]    Calls other keywords in one place
    [Arguments]    ${web_key}    ${steam_id}
    Download owned games API data    ${web_key}    ${steam_id}
    Load owned games as table and convert data

Download owned games API data
    [Documentation]    Make an API call using API key and the user steam ID we are searching for
    [Arguments]    ${web_key}    ${steam_id}

    ${owned_games}=    
    ...    Set Variable    
    ...    https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=${web_key}&steamid=${steam_id}&include_appinfo=true&include_played_free_games=true


    Download    
    ...    ${owned_games}
    ...    ${OWNED_GAMES_JSON_PATH}
    ...    overwrite=True
    
Load owned games as table and convert data
    [Documentation]    Tries to read the owned games data json file and to create a table, if however the user made their games private it fails
    ...                If its private the owned games data is removed if it was produced from a previous run on perhaps a different user
    ...                This is due to a issue where it would link the last users data to the one that has their games private
    ...                Else if the data isnt private we sort the table out by removing excess columns and then writting the data into a CSV
    TRY

        ${json}=    Load JSON from file    ${OWNED_GAMES_JSON_PATH}
        ${table}=    Create Table    ${json}[response][games]

    EXCEPT

        Log    Owned games data is private and will not be shown    WARN
        ${csv_exists}=    Does File Exist    ${OWNED_GAMES_CSV_PATH}
        IF    ${csv_exists} == ${True}
            Remove File    ${OWNED_GAMES_CSV_PATH}
        END 

    ELSE
         ${columns_to_pop}=    Create List    
    ...    has_community_visible_stats
    ...    playtime_windows_forever  
    ...    playtime_mac_forever
    ...    playtime_linux_forever
    ...    rtime_last_played
    ...    content_descriptorids
    ...    has_leaderboards
    ...    img_icon_url
    ...    playtime_2weeks   

        FOR    ${column}    IN    @{columns_to_pop}
            Run Keyword And Ignore Error    Pop Table Column    ${table}    ${column}
        END

        Sort Table By Column    ${table}    playtime_forever    ascending=${False}
        
        Run Keyword    Convert mins into hrs in Playtime column    ${table}

        Write table to CSV    ${table}    ${OUTPUT_DIR}${/}o_games.csv    encoding=UTF-8

    END

    
Convert mins into hrs in Playtime column
    [Documentation]    Gathers the playtime data column and converts all the playtime from minutes into hours
    [Arguments]    ${table}
    ${grouped}=    Get Table Column    ${table}    playtime_forever
    ${updated_playtime}=    Create List
    FOR    ${value}    IN    @{grouped}
        IF    ${value} > 0
            ${value}=    Evaluate    round(${value}/60, 2)
            Append To List    ${updated_playtime}    ${value}    
        ELSE
            Append To List    ${updated_playtime}    ${value} or Private
            CONTINUE
        END
    END
    Set Table Column    ${table}    playtime_forever    ${updated_playtime}