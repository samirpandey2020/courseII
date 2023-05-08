*** Settings ***
Documentation       Translate audio from googe tansalate and save

Library             RPA.Browser.Selenium    auto_close=${False}
Library             BuiltIn
Library             OperatingSystem
# Task Teardown    Close All Browsers


*** Variables ***
${SONG_Name}=           back to december
${Source_language}=     %{Source_language=en}
${Target_language}=     %{Target_language=mai}
${original_file}=       ${OUTPUT_DIR}${/}${SONG_Name}-${Source_language}-original.txt
${tranalated_file}=     ${OUTPUT_DIR}${/}${SONG_Name}-${Target_language}-tranlasted.txt


*** Tasks ***
Get lyrics from websites and translate
    ${lyrics}=    Get lyrics
    ${tranlation}=    Translate    ${lyrics}
    Save the Translation    ${lyrics}    ${tranlation}


*** Keywords ***
Get lyrics
    Open Available Browser
    ...    https://www.lyrics.com/lyric/22055584/Taylor+Swift/Back+to+December

    Wait Until Element Is Visible    id=lyric-body-text
    ${lyrics_element}=    Set Variable    id=lyric-body-text
    Wait Until Element Is Visible    ${lyrics_element}
    ${lyrics}=    Get Text    ${lyrics_element}
    RETURN    ${lyrics}

Translate
    [Arguments]    ${lyrics}

    GO to    https://translate.google.com/?sl=${Source_language}&tl=${Target_language}&text=${lyrics}&op=translate
    ${translated_element}=    Set Variable    css:.lRu31
    Wait Until Element Is Visible    ${translated_element}
    ${tranlation}=    Get Text    ${translated_element}
    RETURN    ${tranlation}

Save the Translation
    [Arguments]    ${lyrics}    ${translation}
    Create File    ${OUTPUT_DIR}${/}${SONG_Name}-${Source_language}-original.txt    ${lyrics}
    Create File    ${OUTPUT_DIR}${/}${SONG_Name}-${Target_language}-tranlasted.txt    ${translation}
