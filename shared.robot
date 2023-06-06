*** Settings ***
Documentation    Strictly used as a way to not repeat variables and library imports in other robot files

Library     RPA.Robocorp.Vault
Library     RPA.HTTP
Library     RPA.JSON
Library     RPA.Tables
Library     Collections
Library     make_html
Library     generate_plot


*** Variables ***
${PLAYER_SUMMARIES_JSON_PATH}=          ${OUTPUT_DIR}${/}p_summaries.json
${OWNED_GAMES_JSON_PATH}=               ${OUTPUT_DIR}${/}o_games.json
${RECENTLY_PLAYED_GAMES_JSON_PATH}=     ${OUTPUT_DIR}${/}rp_games.json
${STORE_GAMES_JSON_PATH}=               ${OUTPUT_DIR}${/}store_games.json
${OWNED_GAMES_CSV_PATH}=                ${OUTPUT_DIR}${/}o_games.csv
${PLAYER_SUMMARIES_CSV_PATH}=           ${OUTPUT_DIR}${/}p_summaries.csv
${USER_DOCUMENTATION_HTML_PATH}=        ${OUTPUT_DIR}${/}user_doc.html
${PLOT_DATA_JSON_PATH}=                 games.json