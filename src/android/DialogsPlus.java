package com.zrsoft.dialogsPlus;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

public class DialogsPlus extends CordovaPlugin {

    private static final String LOG_TAG = "DialogsPlus";
    
    private final int CHOOSE_FILE_REQUEST = 0X111; 

    public ProgressDialog loadingDialog = null;
    public ProgressDialog progressDialog = null;
    public CallbackContext progressDialogCallbackContext = null;
    
    public CallbackContext chooseFileCallbackContext = null;

    /**
     * Constructor.
     */
    public DialogsPlus() {
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action            The action to execute.
     * @param args              JSONArray of arguments for the plugin.
     * @param callbackContext   The callback context used when calling back into JavaScript.
     * @return                  True when the action was valid, false otherwise.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    	/*
    	 * Don't run any of these if the current activity is finishing
    	 * in order to avoid android.view.WindowManager$BadTokenException
    	 * crashing the app. Just return true here since false should only
    	 * be returned in the event of an invalid action.
    	 */
    	if(this.cordova.getActivity().isFinishing()) {
    		return true;
    	}
        else if (action.equals("showLoading")) {
            this.showLoading(args.getString(0), args.getString(1));
            callbackContext.success();
        }
        else if (action.equals("hideLoading")) {
            this.hideLoading();
            callbackContext.success();
        }
        else if (action.equals("showProgress")) {
            this.progressStart(args.getString(0), args.getString(1), args.getBoolean(2), args.getString(3),  callbackContext);
        }
        else if (action.equals("setProgressMessage")) {
            this.progressMessage(args.getString(0),  callbackContext);
        }
        else if (action.equals("setProgressValue")) {
            this.progressValue(args.getInt(0),  callbackContext);
        }
        else if (action.equals("hideProgress")) {
            this.progressStop(callbackContext);
        }
        else if (action.equals("chooseFile")) {
            this.chooseFile(args.getString(0),callbackContext);
        }
        else if (action.equals("showNotice")) {
            this.showNotice(args.getString(0),args.getInt(1),callbackContext);
        }
        else if (action.equals("download")) {
            this.download(args.getString(0),callbackContext);
        }
        else {
            return false;
        }
        
        return true;
    }

    //--------------------------------------------------------------------------
    // LOCAL METHODS
    //--------------------------------------------------------------------------

    /**
     * Show the loading.
     *
     * @param title     Title of the dialog
     * @param message   The message of the dialog
     */
    public synchronized void showLoading(final String title, final String message) {
        if (this.loadingDialog != null && this.loadingDialog.isShowing()) {
        	this.loadingDialog.setTitle(title);
        	this.loadingDialog.setMessage(message);
            return;
        }
        
        final DialogsPlus notification = this;
        final CordovaInterface cordova = this.cordova;
        Runnable runnable = new Runnable() {
            public void run() {
                notification.loadingDialog = createProgressDialog(cordova); // new ProgressDialog(cordova.getActivity(), AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
                notification.loadingDialog.setTitle(title);
                notification.loadingDialog.setMessage(message);
                notification.loadingDialog.setCancelable(false);
                notification.loadingDialog.setIndeterminate(true);
                notification.loadingDialog.setOnCancelListener(
                        new DialogInterface.OnCancelListener() {
                            public void onCancel(DialogInterface dialog) {
                                notification.loadingDialog = null;
                            }
                        });
                notification.loadingDialog.show();
            }
        };
        this.cordova.getActivity().runOnUiThread(runnable);
    }

    /**
     * Stop spinner.
     */
    public synchronized void hideLoading() {
        if (this.loadingDialog != null) {
            this.loadingDialog.dismiss();
            this.loadingDialog = null;
        }
    }

    /**
     * Show the progress dialog.
     *
     * @param title     Title of the dialog
     * @param message   The message of the dialog
     */
    public synchronized void progressStart(final String title, final String message,final Boolean cancelable,final String cancelableText,CallbackContext callbackContext) {
        if (this.progressDialog != null) {
            this.progressDialog.dismiss();
            this.progressDialog = null;
            this.progressDialogCallbackContext = null;
        }
        
        try{
        	final DialogsPlus dialogsPlus = this;
        	final CordovaInterface cordova = this.cordova;
            this.progressDialogCallbackContext = callbackContext;
        	Runnable runnable = new Runnable() {
        		public void run() {
        			dialogsPlus.progressDialog = createProgressDialog(cordova); 
        			dialogsPlus.progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        			dialogsPlus.progressDialog.setTitle(title);
        			dialogsPlus.progressDialog.setMessage(message);
        			dialogsPlus.progressDialog.setMax(100);
        			dialogsPlus.progressDialog.setProgress(0);
        			dialogsPlus.progressDialog.setCancelable(false);
        			dialogsPlus.progressDialog.setIndeterminate(false);
        			if(cancelable){
        				dialogsPlus.progressDialog.setButton(DialogInterface.BUTTON_POSITIVE, cancelableText,
        						new AlertDialog.OnClickListener() {
        					public void onClick(DialogInterface dialog, int which) {
        						try{
        							dialog.dismiss();
        							dialogsPlus.progressDialog = null;
        							if(dialogsPlus.progressDialogCallbackContext != null){
        								dialogsPlus.progressDialogCallbackContext.success();
        								dialogsPlus.progressDialogCallbackContext = null;
        							}
        						} catch(Exception e){
        							if(dialogsPlus.progressDialogCallbackContext != null){
        								dialogsPlus.progressDialogCallbackContext.error("cancel error");
        							}
        						}
        					}
        				});
        			}
        			dialogsPlus.progressDialog.show();
        		}
        	};
        	this.cordova.getActivity().runOnUiThread(runnable);
        } catch(Exception e){
        	Log.e(LOG_TAG,"progressStart error", e);
        	callbackContext.error("progressStart error");
        }
    }

    /**
     * Set value of progress bar.
     *
     * @param value     0-100
     * @param callbackContext 
     */
    public synchronized void progressValue(int value, CallbackContext callbackContext) {
        if (this.progressDialog != null) {
        	try{
        		this.progressDialog.setProgress(value);
        		callbackContext.success();
        	} catch(Exception e){
        		callbackContext.error(e.getMessage());
        	}
            
        }else {
        	callbackContext.error("Progress dialog does not open!");
        }
    }

    /**
     * Set message of progress bar.
     *
     * @param message    
     * @param callbackContext 
     */
    public synchronized void progressMessage(String message, CallbackContext callbackContext) {
        if (this.progressDialog != null) {
        	try{
        		final DialogsPlus dialogsPlus = this;
            	final String _message = message;
        		Runnable runnable = new Runnable() {
            		public void run() {
            			dialogsPlus.progressDialog.setMessage(_message);
            		}
            	};
            	this.cordova.getActivity().runOnUiThread(runnable);
        		
        		callbackContext.success();
        	} catch(Exception e){
        		callbackContext.error(e.getMessage());
        	}
            
        }else {
        	callbackContext.error("Progress dialog does not open!");
        }
    }

    /**
     * Stop progress dialog.
     * @param callbackContext 
     */
    public synchronized void progressStop(CallbackContext callbackContext) {
        if (this.progressDialog != null) {
        	try{
        		this.progressDialog.dismiss();
                this.progressDialog = null;
                this.progressDialogCallbackContext = null;
        		callbackContext.success();
        	} catch(Exception e){
        		callbackContext.error(e.getMessage());
        	}
            
        }else {
        	callbackContext.error("Progress dialog does not open!");
        }
    }

    /**
     * chooseFile.
     *
     * @param title     Title of the dialog
     * @param message   The message of the dialog
     */
    public synchronized void chooseFile(final String title,CallbackContext callbackContext) {
        if (this.chooseFileCallbackContext != null) {
        	this.chooseFileCallbackContext.error("cancel");
        	this.chooseFileCallbackContext = null;
        }

    	Intent intent = new Intent(Intent.ACTION_GET_CONTENT);  
        intent.setType("*/*");  
        intent.addCategory(Intent.CATEGORY_OPENABLE);  
        try {  
        	this.cordova.startActivityForResult(this,Intent.createChooser(intent, title),CHOOSE_FILE_REQUEST);
        	PluginResult mPlugin = new PluginResult(PluginResult.Status.NO_RESULT);  
            mPlugin.setKeepCallback(true);  
            this.chooseFileCallbackContext = callbackContext;
            callbackContext.sendPluginResult(mPlugin); 
        } catch (android.content.ActivityNotFoundException ex) {
        	callbackContext.error("error");
        }  
    }
    

    /**
     * Show notice
     *
     * @param message   The message of the notice
     * @param time      
     */
    public synchronized void showNotice(final String message, final int time,CallbackContext callbackContext) {
    	try{
	    	Toast toast=Toast.makeText(this.cordova.getActivity(), message, time); 
	    	toast.show();
        } catch(Exception e){
        	Log.e(LOG_TAG,"showNotice error", e);
        }
    }
    

    /**
     * download resource by system browser.
     *
     * @param resourceUrl   The url of the resource
     */
    public synchronized void download(final String resourceUrl,CallbackContext callbackContext) {
    	try{
	    	Uri uri = Uri.parse(resourceUrl);
	    	Intent intent = new Intent(Intent.ACTION_VIEW,uri);
	    	this.cordova.getActivity().startActivity(intent);
	    	callbackContext.success();
        } catch(Exception e){
        	Log.e(LOG_TAG,"showNotice error", e);
        	callbackContext.error(e.getMessage());
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent intent){    
        switch (resultCode) { 
            case Activity.RESULT_OK:
                Uri uri = intent.getData();
                if(CHOOSE_FILE_REQUEST == requestCode){
                	if(this.chooseFileCallbackContext != null){
                		this.chooseFileCallbackContext.success(uri.toString());
                	}
                }
            default:  
                break;  
        }  
    } 
    
    @SuppressWarnings("deprecation")
	@SuppressLint("InlinedApi")
    private ProgressDialog createProgressDialog(CordovaInterface cordova) {
        int currentapiVersion = android.os.Build.VERSION.SDK_INT;
        if (currentapiVersion >= android.os.Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
            return new ProgressDialog(cordova.getActivity(), AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
        } else {
            return new ProgressDialog(cordova.getActivity());
        }
    }
}