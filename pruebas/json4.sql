declare
   l_json     varchar2 (32767) := '{
    "type": "Campaign",
    "currentStatus": "Active",
    "id": "206",
    "createdAt": "1488438112",
    "createdBy": "370",
    "depth": "complete",
    "folderId": "1428",
    "name": "Car Loan",
    "elements": [
        {
            "type": "CampaignAddToProgramBuilderAction",
            "id": "1197",
            "name": "Create Lead",
            "memberCount": "0"
        }
    ],
    "isReadOnly": "false",
    "runAsUserId": "372",
    "actualCost": "2500.00",
    "budgetedCost": "0.00",
    "campaignCategory": "contact",
    "campaignType": "GB",
    "crmId": "",
    "endAt": "1496289599",
    "fieldValues": [
        {
            "type": "FieldValue",
            "id": "8",
            "value": "test"
        },
        {
            "type": "FieldValue",
            "id": "9",
            "value": "APAC"
        },
        {
            "type": "FieldValue",
            "id": "11",
            "value": ""
        },
        {
            "type": "FieldValue",
            "id": "12",
            "value": "Direct Mail Campaigns"
        },
        {
            "type": "FieldValue",
            "id": "13",
            "value": ""
        }
    ],
    "firstActivation": "1488439250",
    "isEmailMarketingCampaign": "false",
    "isIncludedInROI": "true"
}';
   l_number   number;
begin
   apex_json.parse (l_json);
   --actualCost
   l_number   := to_number (apex_json.get_varchar2 ('actualCost'), '999999999990D00', 'NLS_NUMERIC_CHARACTERS=''.,''');
   dbms_output.put_line ('Actual cost: ' || l_number);

   -- fieldValues
   for i in 1 .. apex_json.get_count ('fieldValues') loop
      dbms_output.put_line ('Item number ' || i);
      dbms_output.put_line (chr (9) || ' * Type: ' || apex_json.get_varchar2 ('fieldValues[%d].type', i));
      dbms_output.put_line (chr (9) || ' * Id: ' || apex_json.get_varchar2 ('fieldValues[%d].id', i));
      dbms_output.put_line (chr (9) || ' * Value: ' || apex_json.get_varchar2 ('fieldValues[%d].value', i));
   end loop;
end;