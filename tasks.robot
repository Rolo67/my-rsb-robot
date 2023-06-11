*** Settings ***
Documentation       Playwright template.
Library             RPA.Browser.Playwright
Library           RPA.HTTP
Library           RPA.Excel.Files

*** Tasks ***
Insert the sales data for the week and export it as a PDF
    Open the intranet website
    Log in
    Download the Excel file
    Fill the form using the data from the Excel file

*** Keywords ***
Open the intranet website
    Open Browser    https://robotsparebinindustries.com/

Log in
    Fill Text   id=username    maria
    Fill Text   id=password    thoushallnotpass
    Click    css=button.btn-primary
    Wait For Elements State    id=sales-form    visible

Fill the form using the data from one person
    [Arguments]    ${sales_rep}
    ${string} =    Convert To String    ${sales_rep}[Sales Target]
    Fill Text   id=firstname    ${sales_rep}[First Name]
    Fill Text   id=lastname    ${sales_rep}[Last Name]
    Select Options By    id=salestarget    value    ${string}
    Fill Text   id=salesresult    ${sales_rep}[Sales]
    Click    text="Submit"

Download the Excel file
    RPA.HTTP.Download    https://robotsparebinindustries.com/SalesData.xlsx    overwrite=True

Fill the form using the data from the Excel file
    Open Workbook    SalesData.xlsx
    ${sales_reps}=    Read Worksheet As Table    header=True
    Close Workbook
    FOR    ${sales_rep}    IN    @{sales_reps}
        Fill the form using the data from one person    ${sales_rep}
    END
    