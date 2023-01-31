import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

/**
 * Displays a lightning tile with a link to a record.
 */

class CfpcNavigateToRecord extends NavigationMixin(LightningElement) {

	/**
	 * The title of the tile;
	 * @public
	 */
	@api title;

    /**
     * The salesforce lightning design system (slds) name of the icon.
     * @public
     */
	@api iconName;

    /**
     * The subtitle of the tile.
     * @public
     */
	@api subtitle;

    /**
     * The record id of the record to link to. 
     */
	@api recordId;

	url;

    connectedCallback() {

        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view',
            },
        }).then(url => {
            this.url = url;
        });
    }
}

export default CfpcNavigateToRecord;