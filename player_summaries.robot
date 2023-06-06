*** Settings ***
Documentation    Call an API for player summaries (user details like name, avatar, country and etc.) and create a sorted CSV using the API data

Resource            shared.robot
Library             DateTime


*** Keywords ***
Produce Player Summaries
    [Documentation]    Calls other keywords in one place   
    [Arguments]    ${web_key}    ${steam_id}
    Download player summaries API data    ${web_key}    ${steam_id}
    Load player summaries as table, convert data and export as CSV

Download player summaries API data
    [Documentation]    Make an API call using API key and the user steam ID we are searching for
    [Arguments]    ${web_key}    ${steam_id}

    ${player_summaries}=
    ...    Set Variable
    ...    http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=${web_key}&steamids=${steam_id}

    Download
    ...    ${player_summaries}
    ...    ${PLAYER_SUMMARIES_JSON_PATH}
    ...    overwrite=True

Load player summaries as table, convert data and export as CSV
    [Documentation]    Load the data from JSON, create a table and pop the unneeded columns, move the image to the back column
    ...                convert the data on columns and create a CSV from the sorted data
    ${json}=    Load JSON from file    ${PLAYER_SUMMARIES_JSON_PATH}
    ${table}=    Create Table    ${json}[response][players]

    ${columns_to_pop}=    Create List
    ...    commentpermission
    ...    avatar
    ...    avatarmedium
    ...    avatarhash
    ...    primaryclanid
    ...    locstatecode
    ...    loccityid
    ...    personastateflags
    ...    profilestate
    ...    gameid
    ...    gameserverip
    ...    gameextrainfo
    ...    communityvisibilitystate

    FOR    ${column}    IN    @{columns_to_pop}
        Run Keyword And Ignore Error    Pop Table Column    ${table}    ${column}
    END

    ${avatar}=    RPA.Tables.Get Table Cell    ${table}    0    avatarfull
    Pop Table Column    ${table}    avatarfull
    Add Table Column    ${table}    avatar    <img src="${avatar}">

    ${profile_url}=    RPA.Tables.Get Table Cell    ${table}    0    profileurl
    Set Table Column    ${table}    profileurl    <a href="${profile_url}" target="_blank">User Profile</a>    

    Run Keyword    Convert Data    ${table}

    Write table to CSV    ${table}    ${OUTPUT_DIR}${/}p_summaries.csv    encoding=UTF-8

Convert Data
    [Documentation]
    ...    Convert online status state and unix time.
    [Arguments]    ${table}

    Run Keyword And Warn On Failure    Persona state convert    ${table}
    Run Keyword And Warn On Failure    Time created convert    ${table}
    Run Keyword And Warn On Failure    Last logoff convert    ${table}

    RETURN    ${table}

Persona state convert
    [Documentation]    API data gives person online status in numbers, so a dict is created where the numbers are keys and the state is a value
    [Arguments]    ${table}
    ${status}=    Create Dictionary
    ...    0=Offline/Private
    ...    1=Online
    ...    2=Busy
    ...    3=Away
    ...    4=Snooze
    ...    5=Looking to Trade
    ...    6=Looking to Play

    ${get_personastate}=    RPA.Tables.Get Table Cell    ${table}    0    personastate
    Set Table Cell    ${table}    0    personastate    ${status['${get_personastate}']}

Time created convert
    [Documentation]    API data gives the profile creation time in UNIX time, so it is converted to show the date
    [Arguments]    ${table}
    ${get_timecreated}=    RPA.Tables.Get Table Cell    ${table}    0    timecreated
    ${con_timecreated}=    Convert Date    ${get_timecreated}    exclude_millis=True
    Set Table Cell    ${table}    0    timecreated    ${con_timecreated}

Last logoff convert
    [Documentation]    API data gives the last log off time in UNIX time, so it is converted to show the date
    [Arguments]    ${table}
    ${get_lastlogoff}=    RPA.Tables.Get Table Cell    ${table}    0    lastlogoff
    ${con_lstlogoff}=    Convert Date    ${get_lastlogoff}    exclude_millis=True
    Set Table Cell    ${table}    0    lastlogoff    ${con_lstlogoff}