var exec = require('cordova/exec');
var filePath = cordova.require('cordova-plugin-filepath.FilePath')

/**
 * Provides Android API.
 */
module.exports = {
    showLoading : function(title, message) {
        // If title and message not specified then mimic Android behavior of
        // using default strings.
		title = title || "";
		message = message || 'Please wait...';

        exec(null, null, 'DialogsPlus', 'showLoading', [ title, message ]);
    },

    /**
     * Close an activity dialog
     */
    hideLoading : function() {
        exec(null, null, 'DialogsPlus', 'hideLoading', []);
    },

    /**
     * Display a progress dialog with progress bar that goes from 0 to 100.
     *
     * @param {String}
     *            title Title of the progress dialog.
     * @param {String}
     *            message Message to display in the dialog.
     */
    progressStart : function(title, message,errorFn,cancelable,cancelableText,cancelFn) {
		//To determine whether the progress bar has been hidden 
		var hided = false;
		
		title = title || "";
		message = message || '';
		cancelable = !!cancelable;
		cancelableText = cancelableText || 'cancel';
		exec(function(){
			hided = true;
			if(typeof cancelFn == "function"){
				cancelFn();
			}
		},errorFn, 'DialogsPlus', 'showProgress', [ title, message,cancelable,cancelableText]);
		
		return {
			hide : function(successFn, errorFn){
				if(hided){
					return;
				}
				exec(function(){
					hided = true;
					if(typeof successFn == "function"){
						successFn();
					}
				}, errorFn, 'DialogsPlus', 'hideProgress', []);
			},
			setValue : function(value){
				if(hided){
					return;
				}
				exec(null, null, 'DialogsPlus', 'setProgressValue', [value]);				
			},
			setMessage : function(message){
				if(hided){
					return;
				}
				exec(null, null, 'DialogsPlus', 'setProgressMessage', [message]);
				
			}
		}
	},

    /**
     * choose file
     *
     * @param {String}
     *            title Title of the progress dialog.
     * @param {String}
     *            message Message to display in the dialog.
     */
    chooseFile : function(title, successFn, errorFn) {
		title = title || "";
		exec(function(path){
			filePath.resolveNativePath(path, function(path){
				successFn && successFn(path);
			}, function(err){
				errorFn && errorFn(err);
			});
		},function(err){
			errorFn && errorFn(err);
		}, 'DialogsPlus', 'chooseFile', [ title]);
	},

    /**
     * show notice by toast 
     *
     * @param {String}
     *            title Title of the progress dialog.
     * @param {int}
     *            notice show time.
     */
    showNotice : function(title, time) {
		title = title || "";
		time = time || 1000;
		exec(null,null, 'DialogsPlus', 'showNotice', [ title, time]);
	},

    /**
     * download resource
     *
     * @param {String}
     *            The url of the resource
     */
    download : function(resourceUrl, errorFn) {
		exec(null,errorFn, 'DialogsPlus', 'download', [ resourceUrl]);
	},
};
