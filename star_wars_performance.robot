*** Settings ***
Library           RequestsLibrary
Library           Process
Library           DateTime
Library           Collections

Suite Setup       Start Flask Server
Suite Teardown    Stop Flask Server

*** Variables ***
${SERVER_URL}    http://localhost:5000
${DURATION}      1 minutes

*** Test Cases ***
Access Endpoint Continuously
    [Documentation]    Access the get endpoint '/people' continuously for a duration of time
    [Tags]             stress-test
    ${start_time}      Get Current Date    result_format=epoch
    ${end_time}        Get Future Date    ${start_time}    ${DURATION}
    ${current_time}    Get Current Date    result_format=epoch
    ${response_times}  Create List
    WHILE    ${current_time} < ${end_time}
        ${response_start}    Get Current Date    result_format=epoch
        ${response}    Get    ${SERVER_URL}/people
        ${response_end}    Get Current Date    result_format=epoch
        ${response_time}    Subtract Date From Date    ${response_end}    ${response_start}
        Should Be Equal As Strings    ${response.status_code}    200
        ${response_time}  Convert To Milliseconds  ${response_time}
        Append To List  ${response_times}  ${response_time}
        ${current_time}    Get Current Date    result_format=epoch
        Sleep    1s
    END

    ${elapsed_time}    Get Elapsed Time    ${start_time}
    Log    Elapsed time: ${elapsed_time}
    ${mean_time}=    Mean Deviation    ${response_times}
    ${std_dev}=    Standard Deviation    ${response_times}
    Log    Mean response time: ${mean_time} ms
    Log    Standard deviation of response time: ${std_dev} ms

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

Get Future Date
    [Documentation]    Get the time in the future by a specified duration
    [Arguments]       ${start_time}    ${duration}
    ${future_time}=    Add Time To Date    ${start_time}    ${duration}    result_format=epoch
    [Return]    ${future_time}

Get Elapsed Time
    [Documentation]    Get the elapsed time between two times
    [Arguments]       ${start_time}
    ${end_time}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S.%f
    ${elapsed_time}=    Subtract Date From Date    ${end_time}    ${start_time}
    ${time}=    Convert Date    ${elapsed_time}    epoch
    [Return]    ${elapsed_time}

Convert To Milliseconds
    [Arguments]    ${seconds}
    [Return]       ${seconds*1000}

Mean Deviation
    [Arguments]    ${list}
    ${sum} =    Set Variable    0
    ${N} =    Get Length    ${list}
    FOR    ${resp_time}    IN    @{list}
        ${sum} =    Evaluate    ${resp_time}+${sum}
    END
    ${result} =    Evaluate    ${sum}/${N}
    Log    ${result}
    [Return]    ${result}

Standard Deviation
    [Arguments]    ${list}
    ${mean} =    Mean Deviation    ${list}
    ${sum} =    Set Variable    0
    ${N} =    Get Length    ${list}
    FOR    ${resp_time}    IN    @{list}
        ${diff} =    Evaluate    ${resp_time} - ${mean}
        ${sq_diff} =    Evaluate    ${diff} * ${diff}
        ${sum} =    Evaluate    ${sum} + ${sq_diff}
    END
    ${variance} =    Evaluate    ${sum} / (${N} - 1)
    Log    ${variance}
    ${std_dev} =    Evaluate    math.sqrt(${variance})
    Log    ${std_dev}
    [Return]    ${std_dev}