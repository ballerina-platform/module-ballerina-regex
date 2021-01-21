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

import ballerina/jballerina.java;


# Checks whether the given string matches the provided regex.
# ```ballerina
# boolean isMatched = regex:matches("Ballerina is great", "Ba[a-z ]+");
# ```
#
# + stringToMatch - The string to match the regex
# + regex - The regex to match the string
# + return - `true` if the provided string matches the regex or else
#            `false`
public isolated function matches(string stringToMatch, string regex) returns boolean {
    return matchesExternal(java:fromString(stringToMatch), java:fromString(regex));
}

# Replaces each occurrence of the substrings, which match the provided
# regular expression from the given original string value with the
# provided replacement string.
# ```ballerina
# string result = regex:replaceAll("Ballerina is great", "\s+", "_");
# ```
#
# + originalString - The original string to replace the occurrences of the
#                    substrings that match the provided `regex`
# + regex - The regex to match the substrings in the `originalString` to be replaced
# + replacement - The `replacement` string to replace the subsgrings, which
#                 match the `regex`
# + return - The resultant string with the replaced substrings
public isolated function replaceAll(string originalString, string regex, string replacement) returns string {
    handle value = replaceAllExternal(java:fromString(originalString), java:fromString(regex),
                                      java:fromString(replacement));
    string? updatedString = java:toString(value);
    if (updatedString is string) {
        return updatedString;
    } else {
        // Should never reach here.
        error e = error(string `error occurred while replacing ${regex} in ${originalString}`);
        panic e;
    }
}

# Replaces the first substring that matches the given regular expression with
# the provided `replacement` string.
# ```ballerina
# string result = regex:replaceFirst("Ballerina is great", "\s+", "_");
# ```
#
# + originalString - The original string to replace the occurrences of the
#                    substrings that match the provided `regex`
# + regex - The regex to match the first substring in the `originalString` to
#           be replaced
# + replacement - The `replacement` string to replace the first substring, which
#                 matches the `regex`
# + return - The resultant string with the replaced substring
public isolated function replaceFirst(string originalString, string regex, string replacement) returns string {
    handle value = replaceFirstExternal(java:fromString(originalString), java:fromString(regex),
                                        java:fromString(replacement));
    string? updatedString = java:toString(value);
    if (updatedString is string) {
        return updatedString;
    } else {
        // Should never reach here.
        error e = error(string `error occurred while replacing ${regex} in ${originalString}`);
        panic e;
    }
}

# Returns an array of strings by splitting a string using the provided
# delimiter.
# ```ballerina
# string[] result = regex:split("Ballerina is great", " ");
# ```
#
# + receiver - The string to split
# + delimiter - The delimiter to split by
# + return - An array of strings containing the individual strings that are split
public isolated function split(string receiver, string delimiter) returns string[] {
    handle res = splitExternal(java:fromString(receiver), java:fromString(delimiter));
    return getBallerinaStringArray(res);
}


// Interoperable external functions.
isolated function matchesExternal(handle stringToMatch, handle regex) returns boolean = @java:Method {
    name: "matches",
    'class: "java.lang.String",
    paramTypes: ["java.lang.String"]
} external;

isolated function replaceAllExternal(handle originalString, handle regex, handle replacement) returns handle = @java:Method {
    name: "replaceAll",
    'class: "java.lang.String",
    paramTypes: ["java.lang.String", "java.lang.String"]
} external;

isolated function replaceFirstExternal(handle originalString, handle regex, handle replacement) returns handle = @java:Method {
    name: "replaceFirst",
    'class: "java.lang.String",
    paramTypes: ["java.lang.String", "java.lang.String"]
} external;

isolated function splitExternal(handle receiver, handle delimiter) returns handle = @java:Method {
    name: "split",
    'class: "java.lang.String",
    paramTypes: ["java.lang.String"]
} external;

isolated function getBallerinaStringArray(handle h) returns string[] = @java:Method {
    'class:"io.ballerina.runtime.api.utils.StringUtils",
    name:"fromStringArray",
    paramTypes:["[Ljava.lang.String;"]
} external;
