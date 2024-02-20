*** Settings ***
Force Tags    etsc6-regression

Resource    ../../../Resources/navLoginAndMainPage_Browser.robot
Resource    ../../../Resources/navGeneral_Browser.robot
Resource    ../../../Resources/navConfigurationNetworkElements_Browser.robot
Resource    ../../../Resources/navConfigurationTrails_Browser.robot
Resource    ../../../Resources/EnvironmentKeywords_Browser.robot
Resource    ../../../Resources/navConfigurationOTNService_Browser.robot
Resource    ../../../Resources/navMap_Browser.robot
Resource    ../../../Resources/navServices_Browser.robot
Resource    ../Variables_ETSc6.robot


Suite Setup         Test Env Initializing
Suite Teardown      Test Env Teardown

*** Variables ***
${ITERATION}        2
&{type}    on map=flx-ctr-row snabbdom-ne-marker-content
...        on elements tree=flx-it flx-ctr-row treeview__row-content s-networks-row

*** Test Cases ***


Validate NETSIM NE on map
    [Tags]    QTL-3571
    FOR    ${i}    IN RANGE    ${ITERATION}
        Check the NE    ${NES_IP}[ne2]    on map    alarm--clear
        Check the NE    ${NES_IP}[ne6]    on map    alarm--clear
    END

Validate NETSIM NE on elements tree
    [Tags]    QTL-3572
    FOR    ${i}    IN RANGE    ${ITERATION}
        Check the NE    ${NES_IP}[ne2]    on elements tree   alarm--clear
        Check the NE    ${NES_IP}[ne6]    on elements tree   alarm--clear
    END


Validate REAL NODE NE fail on map
    [Tags]    QTL-3575
    FOR    ${i}    IN RANGE    ${ITERATION}
        Check the NE    ${NES_IP}[ne1]    on map   alarm--critical
    END

Validate REAL NODE NE fail on elements tree
    [Tags]    QTL-3576
    FOR    ${i}    IN RANGE    ${ITERATION}
        Check the NE    ${NES_IP}[ne1]    on elements tree   alarm--critical
    END


*** Keywords ***
Test Env Initializing
    Browser_Execute Login
    Browser_Configuration OTN Env Cleanup
    Browser_Force NE Synchronize    etsc6_1
    Browser_Force NE Synchronize    v_etsc6_2
    Browser_Force NE Synchronize    v_etsc6_3
    Browser_Go To Tab   networks
    #Click With Options    //*[contains(@class, "treeview__row flx-ctr-row treeview__row--rank-1")]//*[contains(@class, "icon treeview__expansion-toggle clickable icon--collapsed")]
    Click With Options    ${xpath_map_zoom}    left    clickCount=2    delay=0.5

Check the NE
    [Arguments]    ${ne}   ${place}    ${alarm}
    ${current_place}=    get from dictionary    ${type}    ${place}
    Run Keyword And Continue On Failure    Wait For Elements State    //*[contains(@class, "${current_place}") and contains(@data-nms, "${ne}")]//*[contains(@class, "${alarm}")]
    ...    visible   timeout=2s    message="Check the NE on Map or in the elements tree."
    Run Keyword And Continue On Failure    Wait For Elements State    //*[contains(@class, "${current_place}") and contains(@data-nms, "${ne}")]//*[contains(@class, "${alarm}")]
    ...    attached   timeout=2s    message="Check the NE on Map or in the elements tree."


Test Env Teardown
    Browser_Configuration OTN Env Cleanup
    ${suite_result}=    Fetch From Left    ${SUITE MESSAGE}    :
    Browser_Close NMS Page
    Skip If     "${suite_result}" == "Suite setup failed"     msg=${SUITE MESSAGE}