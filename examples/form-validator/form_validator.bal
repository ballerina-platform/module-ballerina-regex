// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/regex;
import ballerina/http;

// Regex for a username containing at between 4-20 alpha-numeric, period and underscore characters only
final string usernameRegex = "^(?=.{4,20}$)[a-zA-Z0-9._]+$";

// Regex for a password containing at least 8 characters, one number, and both uppercase and lowercase characters
final string passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$";

// Regex for a valid date string in the format YYYY-MM-DD
final string dateRegex = "^\\d{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$";

final string emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$";

// Regex for whitespace, '-', and '.' characters used to filter filler characters in phone numbers
final string phoneFilterRegex = "[\\s.-]";

// Regex for a international mobile phone number such as +94 12 345 6789
final string phoneRegex = "\\+[1-9]{1}[0-9]{3,14}";

public type User record {|
    string username;
    string password;
    string dob;
    string email;
    string phone;
|};

service /validate on new http:Listener(8080) {

    isolated resource function get username(string value) returns boolean|error {
        if !regex:matches(value, usernameRegex) {
            return error("Username does not meet the requirements");
        }
        return true;
    }

    isolated resource function get password(string value) returns boolean|error {
        if !regex:matches(value, passwordRegex) {
            return error("Password does not meet the requirements");
        }
        return true;
    }

    isolated resource function get dob(string value) returns boolean|error {
        return validateDob(value);
    }

    isolated resource function get email(string value) returns boolean|error {
        if !regex:matches(value, emailRegex) {
            return error("Invalid email address");
        }
        return true;
    }

    isolated resource function get phone(string value) returns boolean|error {
        if !validatePhone(value) {
            return error("Invalid phone number");
        }
        return true;
    }

    isolated resource function get user(@http:Payload User user) returns boolean|error {
        boolean errorFlag = false;
        string[] errorMessages = [];

        if !regex:matches(user.username, usernameRegex) {
            errorFlag = true;
            errorMessages.push("Username does not meet the requirements");
        }

        if !regex:matches(user.password, passwordRegex) {
            errorFlag = true;
            errorMessages.push("Password does not meet the requirements");
        }

        boolean|error dobValidation = validateDob(user.dob);
        if dobValidation is error {
            errorFlag = true;
            errorMessages.push(dobValidation.message());
        }

        if !regex:matches(user.email, emailRegex) {
            errorFlag = true;
            errorMessages.push("Invalid email address");
        }

        if !validatePhone(user.phone) {
            errorFlag = true;
            errorMessages.push("Invalid phone number");
        }

        if errorFlag {
            return error(errorMessages.toJsonString());
        }

        return true;
    }
}

isolated function validateDob(string value) returns boolean|error {
    if !regex:matches(value, dateRegex) {
        return error("Invalid date format");
    }

    // Obtain the year of birth
    string[] dateComponents = regex:split(value, "-");
    int yearComponent  = check 'int:fromString(dateComponents[0]);

    // Check whether the date of birth is after the year 2000
    if yearComponent > 2000 {
        return error("Year of birth is after the year 2000");
    }

    return true;
}

isolated function validatePhone(string value) returns boolean {
    // Strip all filler character from the phone number
    string phoneStripped = regex:replaceAll(value, phoneFilterRegex, "");
    return regex:matches(phoneStripped, phoneRegex);
}
