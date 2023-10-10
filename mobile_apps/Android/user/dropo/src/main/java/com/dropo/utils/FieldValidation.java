package com.dropo.utils;

import android.content.Context;
import android.text.InputFilter;
import android.text.TextUtils;
import android.util.Patterns;
import android.widget.EditText;

import com.dropo.user.R;
import com.dropo.models.validations.Validator;

public class FieldValidation {

    public static Validator isEmailValid(Context context, String email) {
        if (TextUtils.isEmpty(email)) {
            return new Validator(context.getString(R.string.msg_enter_email), false);
        } else if (!eMailValidation(email)) {
            return new Validator(context.getString(R.string.msg_enter_valid_email), false);
        } else if (email.length() < 12) {
            return new Validator(context.getString(R.string.msg_enter_valid_email_min_max_length), false);
        } else if (email.length() > 64) {
            return new Validator(context.getString(R.string.msg_enter_valid_email_min_max_length), false);
        } else {
            return new Validator("", true);
        }
    }

    public static Validator isPasswordValid(Context context, String password) {
        if (TextUtils.isEmpty(password)) {
            return new Validator(context.getString(R.string.msg_enter_password), false);
        } else if (password.length() < 6) {
            return new Validator(context.getString(R.string.msg_enter_valid_password), false);
        } else if (password.length() > 20) {
            return new Validator(context.getString(R.string.msg_enter_valid_password), false);
        } else {
            return new Validator("", true);
        }
    }

    public static boolean eMailValidation(String email) {
        return (!TextUtils.isEmpty(email) && Patterns.EMAIL_ADDRESS.matcher(email).matches());
    }

    public static boolean isValidPhoneNumber(Context context, String mobileNumber) {
        PreferenceHelper preferenceHelper = PreferenceHelper.getInstance(context);
        return mobileNumber.trim().length() < preferenceHelper.getMinimumPhoneNumberLength() || mobileNumber.trim().length() > preferenceHelper.getMaximumPhoneNumberLength();
    }

    public static String getPhoneNumberValidationMessage(Context context) {
        PreferenceHelper preferenceHelper = PreferenceHelper.getInstance(context);
        return context.getString(R.string.msg_please_enter_valid_phone_number_length_between) + " " + preferenceHelper.getMinimumPhoneNumberLength() + " " + context.getString(R.string.text_and) + " " + preferenceHelper.getMaximumPhoneNumberLength();
    }

    public static void setMaxPhoneNumberInputLength(Context context, EditText editText) {
        PreferenceHelper preferenceHelper = PreferenceHelper.getInstance(context);
        InputFilter[] inputFilters = new InputFilter[1];
        inputFilters[0] = new InputFilter.LengthFilter(preferenceHelper.getMaximumPhoneNumberLength());
        editText.setFilters(inputFilters);
    }
}