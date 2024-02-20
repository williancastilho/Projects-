*** Settings ***
Force Tags    etsc6-regression    etsc6-week-regression    etsc6-fast-regression

Resource    ../../../Resources/navLoginAndMainPage_Browser.robot
Resource    ../../../Resources/navGeneral_Browser.robot
Resource    ../../../Resources/navConfigurationNetworkElements_Browser.robot
Resource    ../../../Resources/navConfigurationTrails_Browser.robot
Resource    ../../../Resources/EnvironmentKeywords_Browser.robot
Resource    ../../../Resources/navConfigurationOTNService_Browser.robot
Resource    ../../../Resources/navNetworks_Browser.robot
Resource    ../../../Resources/Helper_Keywords.robot
Resource    ../Variables_ETSc6.robot
Resource    ../../../../nso-validation-auto/Resources/HelperKeywords.robot
Resource    ../../../../nso-validation-auto/API/Resources/ets_device_keywords.robot
Library     Remote      http://${PWR_HOST3}:${PWR_PORT}
Library     DateTime


Suite Setup         Test Env Initializing
Suite Teardown      Test Env Teardown


*** Variables ***
${NSO_SERVER}       ${NSO_SERVER_ADDR}
${ITERATION}        1

*** Test Cases ***
Check ETSc6 NE Connectivity After Power-cycle
    [Tags]      QTL-612
    FOR    ${i}    IN RANGE    ${ITERATION}
        log     Checking NE conectivity before shutdown...      console=True
        Check Device Connectivity    ${NES_IP}[ne1]
        log     Performing power-cycle device...        console=True
        Power Cycle RPi Device    ${ETSc6#1_CHB}     10s    5
        log     Checking NE conectivity after power-up...   console=True
        Run Keyword And Continue On Failure    Wait Until Keyword Succeeds
        ...    5 min    10 sec    Check Device Connectivity    ${NES_IP}[ne1]
        log     Waiting for NE NMS sync...    console=True
        Sleep     120s
        Wait For Elements State
        ...    ${xpath_ne_table_row}//*[contains(text(),'${NES_NAME}[ne1]')]/../..//*[contains(@class,"l4")]//*[contains(text(),'Supervised')]
        ...    timeout=120s
    END

Check ETSc6 ConfD Inventory After Power-cycle
    [Tags]      QTL-1248
    Sleep    5min    #time to SC2000 rises
    ${inventory_after}=    Get inventory from ConfD    ${NES_IP}[ne1]
    Should Be Equal As Strings    ${ETSc6_INVENTORY_REF}   ${inventory_after}


Check ETSc6 NMS Inventory After Power-cycle
    Browser_Force NE Synchronize    etsc6_1
    Browser_Go To Tab   networks
    #Validate LC and SC inventory
    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_LC4-MP2-A/1
    Compare Inventory Data NSO-Celestis     ${nso_boards}[0]    ${hardware_values}      ${software_dicts}

    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_SC2000/2
    Compare Inventory Data NSO-Celestis     ${nso_boards}[1]    ${hardware_values}      ${software_dicts}

    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_LC4-MP2-A/3
    Compare Inventory Data NSO-Celestis     ${nso_boards}[2]    ${hardware_values}      ${software_dicts}

    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_LC4-MP2-A/4
    Compare Inventory Data NSO-Celestis     ${nso_boards}[3]    ${hardware_values}      ${software_dicts}

    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_SC2000/5
    Compare Inventory Data NSO-Celestis     ${nso_boards}[4]    ${hardware_values}      ${software_dicts}

    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_LC4-MP2-A/6
    Compare Inventory Data NSO-Celestis     ${nso_boards}[5]    ${hardware_values}      ${software_dicts}

    #Validate MNGT inventory
    # Test - CC Active
    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_MNGT_ETSc/7
    Compare Inventory Data NSO-Celestis     ${nso_boards}[6]    ${hardware_values}      ${software_dicts}
    # Test - CC Standby
    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_MNGT_ETSc/8
    Compare Inventory Data NSO-Celestis     ${nso_boards}[7]    ${hardware_values}      ${software_dicts}

    #Validate PU inventory
    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_PU_ETSc6/9
    Compare Inventory Data NSO-Celestis     ${nso_boards}[8]    ${hardware_values}      ${software_dicts}

    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_PU_ETSc6/10
    Compare Inventory Data NSO-Celestis     ${nso_boards}[9]    ${hardware_values}      ${software_dicts}

    #Validate FAN inventory
    ${hardware_values}      ${software_dicts}=      Read ETSc Board Inventory    ${NES_NAME}[ne1]    RM_ETSc6#1      PM_FAN_ETSc6/11
    Compare Inventory Data NSO-Celestis     ${nso_boards}[10]   ${hardware_values}      ${software_dicts}


*** Keywords ***
Test Env Initializing
    ${nso_boards}=      Get Boards Inventory NSO    ${NES_IP}[ne1]
    Set Suite Variable      ${nso_boards}
    ${ETSc6_INVENTORY_REF}=    Get inventory from ConfD    ${NES_IP}[ne1]
    Set Global Variable    ${ETSc6_INVENTORY_REF}
    Browser_Execute Login
    Browser_Go To Tab   configuration
    Browser_Open Configuration Network Elements Using Burger Menu
    Setup RPi Relay Pinout
    sleep    2

Test Env Teardown
    ${suite_result}=    Fetch From Left    ${SUITE MESSAGE}    :
    Skip If     "${suite_result}" == "Suite setup failed"     msg=${SUITE MESSAGE}