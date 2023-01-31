import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import FEEDBACK_OBJECT from '@salesforce/schema/Feedback__c';
import SUBJECT_FIELD from '@salesforce/schema/Feedback__c.Subject__c';
import TOPIC_FIELD from '@salesforce/schema/Feedback__c.Topic__c';
import TEST_CASE_FIELD from '@salesforce/schema/Feedback__c.CFPC_Test_Case__c';
import SECTION_FIELD from '@salesforce/schema/Feedback__c.Section__c';
import CLIENT_PRIORITY_FIELD from '@salesforce/schema/Feedback__c.Client_Priority__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Feedback__c.Description__c';
import PM_NOTES_FIELD from '@salesforce/schema/Feedback__c.PM_Notes__c';
import RESOLUTION_FIELD from '@salesforce/schema/Feedback__c.Resolution__c';
import CLIENT_APPROVAL_STATUS_FIELD from '@salesforce/schema/Feedback__c.Client_Approval_Status__c';
import CLIENT_CLASSIFICATION_FIELD from '@salesforce/schema/Feedback__c.Client_Classification__c';
import PHASE_2_FIELD from '@salesforce/schema/Feedback__c.Phase_2__c';
import PM_APPROVAL_STATUS_FIELD from '@salesforce/schema/Feedback__c.Support_Approval_Status__c';
import SUPPORT_CLASSIFICATION_FIELD from '@salesforce/schema/Feedback__c.Support_Classification__c';

/**
 * Creates Feedback records.
 */

export default class CreateZAPFeedback extends LightningElement {
    feedbackObject = FEEDBACK_OBJECT;
    myFields = [SUBJECT_FIELD, TOPIC_FIELD, TEST_CASE_FIELD, SECTION_FIELD, CLIENT_PRIORITY_FIELD, DESCRIPTION_FIELD, PM_NOTES_FIELD,
    RESOLUTION_FIELD, CLIENT_APPROVAL_STATUS_FIELD, CLIENT_CLASSIFICATION_FIELD, PHASE_2_FIELD, PM_APPROVAL_STATUS_FIELD, SUPPORT_CLASSIFICATION_FIELD];

    handleFeedbackCreated(event) {
        const toastEvent = new ShowToastEvent({
            title: "Feedback created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);

        const editForm = this.template.querySelector('lightning-record-form');
        editForm.recordId = null;
    }
}