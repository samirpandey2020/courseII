*** Settings ***
Documentation       Oder robot from robotsparebin industries save the oder html reciept in pdf according to order number saver preview image in png according to order number embed screenahot to robot to pdf reciept

# Library    RPA.Excel.Files
# Library    RPA.FTP
Library             RPA.Browser.Selenium    auto_close=${False}
Library             RPA.SAP
Library             RequestsLibrary
Library             RPA.Excel.Application
Library             RPA.HTTP
Library             RPA.Tables
Library             RPA.PDF
Library             RPA.Archive


*** Variables ***
${url_for_order_csv}=       https://robotsparebinindustries.com/orders.csv


*** Tasks ***
courseII
    # Reading CSV file
    Open Browser
    get data from order_csv
    Get order
    Archive


*** Keywords ***
get data from order_csv
    Download    ${url_for_order_csv}

Open Browser
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
    RPA.Browser.Selenium.Maximize Browser Window

Get order
    ${data}=    Read table from CSV    orders.csv

    FOR    ${each_data}    IN    @{data}
        Fill and submit the form for one person    ${each_data}
    END

Click Button for order
    Click Button    Order
    Wait Until Page Contains Element    id:order-completion

Fill and submit the form for one person
    [Arguments]    ${each_data}
    Close Annoying model
    Select From List By value    head    ${each_data}[Head]
    RPA.Browser.Selenium.Select Radio Button    body    ${each_data}[Body]
    RPA.Browser.Selenium.Input Text    class=form-control    ${each_data}[Legs]
    RPA.Browser.Selenium.Input Text    id=address    ${each_data}[Address]
    Click preview

    Wait Until Keyword Succeeds    5x    2s    Click Button for order

    Screenshot and pdf saving robot    ${each_data}

    Click Button    id=order-another

Click preview
    Click Button    Preview

Screenshot and pdf saving robot
    [Arguments]    ${each_data}
    Wait Until Page Contains Element    id:robot-preview
    Screenshot    id:robot-preview    ${OUTPUT_DIR}${/}merge${/}${each_data}[Order number].png

    Wait Until Page Contains Element    id:order-completion
    ${oder_invoce}=    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${oder_invoce}    ${OUTPUT_DIR}${/}merge${/}${each_data}[Order number].pdf

    Add Watermark Image To Pdf
    ...    ${OUTPUT_DIR}${/}merge${/}${each_data}[Order number].png
    ...    ${OUTPUT_DIR}${/}merge${/}${each_data}[Order number].pdf
    ...    ${OUTPUT_DIR}${/}merge${/}${each_data}[Order number].pdf

 Close Annoying model
    Click Button    OK
    ...

Archive
    Archive Folder With zip    ${OUTPUT_DIR}${/}merge    ${OUTPUT_DIR}${/}archive_file.zip
