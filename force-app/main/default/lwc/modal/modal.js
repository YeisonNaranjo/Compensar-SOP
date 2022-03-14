import { LightningElement, api } from 'lwc';

export default class Modal extends LightningElement {
    @api show;
    @api positiveLabel = 'Save';
    @api negativeLabel = 'Cancel';
    @api minheight;
    @api showfooter;
    @api showheader;
    @api showbutton;
    @api showbuttonnegative;
    @api showbuttonpositive;

    handleClose(e) {
        this.dispatchEvent(new CustomEvent('close', { detail:{ event: e }}));
    }

    handleNegative(e) {
        this.dispatchEvent(new CustomEvent('negative', { detail:{ event: e }}));
    }

    handlePositive(e) {
        this.dispatchEvent(new CustomEvent('positive', { detail:{ event: e }}));
    }
}