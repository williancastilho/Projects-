*** Settings ***
Resource    ../../../Resources/ets_device_keywords.robot
Resource    ../../../Util/input_loader_keywords.robot
Resource    ../../../Resources/ets_interface_keywords.robot

*** Variables ***
${interface_csv_file}     ${CURDIR}/../../../TestData/etsc_test_data/etsc6_interfaces_common.csv

*** Test Cases ***
ets:create_interfaces
    [Tags]      QTL-3127
    ${interface_list}=    Load Input      ${interface_csv_file}
    FOR     ${interface_info}    IN  @{interface_list}
        Create Interface NSO
        ...    ${interface_info}[device]
        ...    ${interface_info}[interface]
        ...    ${interface_info}[pm_mode]
        ...    ${interface_info}[tcm_mode]
    END

ets:change_laser_enabled_state
    [Tags]      QTL-3128
    ${interface_list}=    Load Input      ${interface_csv_file}
    FOR     ${interface_info}    IN  @{interface_list}
        Change Laser State NSO
        ...    ${interface_info}[device]
        ...    ${interface_info}[interface]
        ...    true
        Get Laser State NSO
        ...    ${interface_info}[device]
        ...    ${interface_info}[interface]
        ...    Enable
    END

*** Keywords ***

Create Interface NSO
    [Arguments]     ${device}   ${interface}    ${pm_mode}=pm-disabled    ${tcm_mode}=transparent    ${rate}=0
    ${result}=      action_create_interface     ${device}    ${interface}    ${rate}    ${pm_mode}    ${tcm_mode}
    Should Be True  '${default_interface_success_result}' in '${result}'

def action_create_interface(device, interface, rate, pm_mode, tcm_mode):
    param = '"device": "' + device + '",'
    param += '"interface": "' + interface + '",'
    param += '"rate": ' + rate + ','
    param += '"pm-mode": "' + pm_mode + '",'
    param += '"tcm": [{"level": 3,"tcm-mode": "' + tcm_mode + '"}]'
    params = '{"th": 1, "path": "/ets:interface/create-interface/", "format": "json", "params": {' + param + '}}'
    return run_action(params)

Change Laser State NSO
    [Arguments]     ${device}   ${interface}    ${laser_state}
    ${result}=      action_change_laser_state     ${device}     ${interface}    ${laser_state}
    Should Be True  '${default_check_state}' in '${result}'

def action_change_laser_state(device, interface, laser_state):
    param = '"device": "'+device+'", '
    param += '"laser-enabled": "'+laser_state+'", '
    param += '"interface-list": [{"interface": "'+interface+'"}]'

    params = '{"th": 1, "path": "/ets:interface/change-interface-laser-state/", "format": "json", "params": {' + param + '}}'
    print(params)
    return run_action(params)

Get Laser State NSO
    [Arguments]     ${device}   ${interface}    ${laser_state}
    ${result}=      action_get_interface_by_id    ${device}      ${interface}
    Should Be True  '"laser-enabled":"${laser_state}"' in '${result}'

def action_get_interface_by_id(device, interface):
    param = '"device": "'+device+'", "interface": "'+interface+'"'
    params = '{"th": 1, "path": "/ets:interface/get-interface-by-id/", "format": "json", "params": {' + param + '}}'
    return run_action(params)

