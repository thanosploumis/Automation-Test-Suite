*** Settings ***
Library           RequestsLibrary
Library           Process

Suite Setup       Start Flask Server
Suite Teardown    Stop Flask Server

*** Variables ***
${SERVER_URL}    http://localhost:5000

*** Test Cases ***
Get Person By Id Success 200
    [Documentation]    Verify that the correct person is returned when querying the API with a specific ID
    [Tags]             people
    ${id}              Set Variable    1
    ${response}        Get    http://localhost:5000/people/${id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${person}          Set Variable    ${response.json()}
    Should Be Equal As Strings    ${person['id']}    ${id}
    Should Be Equal As Strings    ${person['name']}    Luke Skywalker
    Should Be Equal As Strings    ${person['height']}    172
    Should Be Equal As Strings    ${person['mass']}    77
    Should Be Equal As Strings    ${person['hair_color']}    blond

Get Persons with Id Not Found Fail 404
    [Documentation]    Verify that the person with missing id is not returned but a specific message error instead
    [Tags]             people
    ${missing_id}      Set Variable    3
    ${response}        Get    http://localhost:5000/people/${missing_id}    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404
    ${response_body}          Set Variable    ${response.json()}
    Should Be Equal As Strings    ${response_body['error']}    Person with id ${missing_id} not found

Get Planets with Id Not Found Fail 404
    [Documentation]    Verify that the correct planet is returned when querying the API with a specific ID
    ${missing_id}      Set Variable    3
    ${response}        Get    http://localhost:5000/planets/${missing_id}    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404
    ${response_body}          Set Variable    ${response.json()}
    Should Be Equal As Strings    ${response_body['error']}    Planet with id ${missing_id} not found

Get Starships with Id Not Found Fail 404
    [Documentation]    Verify that the correct person is returned when querying the API with a specific ID
    ${missing_id}      Set Variable    3
    ${response}        Get    http://localhost:5000/starships/${missing_id}    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404
    ${response_body}          Set Variable    ${response.json()}
    Should Be Equal As Strings    ${response_body['error']}    Starship with id ${missing_id} not found

*** Keywords ***
Start Flask Server
    [Documentation]    Start the Flask server
    ${process}=    Start Process    flask run    cwd=${CURDIR}    shell=True
    Wait For Process    ${process}    timeout=5s
    Process Should Be Running    ${process}

Stop Flask Server
    [Documentation]    Stop the Flask server
    ${output}=    Run Process    ps aux | grep "flask run" | grep -v grep | awk '{print $2}'    shell=True
    Log   Flask PID: ${output.stdout.strip()}
    Run Process    kill -9 ${output.stdout.strip()}    shell=True

Get Flask PID
    ${output}=    Run Process    ps aux | grep "flask run" | grep -v grep | awk '{print $2}'    shell=True
    Log   Flask PID: ${output.stdout.strip()}
    Log To Console    Flask PID: ${output.stdout.strip()}
