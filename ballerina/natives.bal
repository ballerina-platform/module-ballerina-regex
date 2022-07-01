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
import ballerina/lang.'string as strings;

# Checks whether the given string matches the provided regex.
# Note that `\\` is used as for escape sequence and `\\\\` is used to insert a backslash
# character in the string or regular expression. The following special characters should be escaped
# in the regex definition.
# Special Characters: `.`, `+`, `*`, `?`, `^`, `$`, `(`, `)`, `[`, `]`,` {`, `}`
#
# ```ballerina
# boolean isMatched = regex:matches("Ballerina is great", "Ba[a-z ]+");
# ```
#
# + stringToMatch - The string to match the regex
# + regex - The regex to match the string
# + return - `true` if the provided string matches the regex or else `false`
public isolated function matches(string stringToMatch, string regex) returns boolean {
    return matchesExternal(java:fromString(stringToMatch), java:fromString(regex));
}

# Replaces the first substring that matches the given regex with
# the provided replacement string or string returned by the provided function.
# Note that `\\` is used as for escape sequence and `\\\\` is used to insert a backslash
# character in the string or regular expression. The following special characters should be escaped
# in the regex definition.
# Special Characters: `.`, `+`, `*`, `?`, `^`, `$`, `(`, `)`, `[`, `]`,` {`, `}`
#
# ```ballerina
# string result = regex:replace("Ballerina is great", "\\s+", "_");
# ```
#
# + originalString - The original string to replace the first occurrence of the
#                    substring that matches the provided regex
# + regex - The regex to match the first substring in the `originalString` to be replaced
# + replacement - The replacement string or a function to be invoked to create the new substring to be
#                 used to replace the first match to the given regex
# + startIndex - The starting index for the search
# + return - The resultant string with the replaced substring
public isolated function replace(string originalString, string regex, Replacement replacement,
                                int startIndex = 0) returns string {
    Match? matched = search(originalString, regex, startIndex);
    if matched is () {
        return originalString;
    }
    int index = 0;
    int length = originalString.length();
    string updatedString = strings:substring(originalString, index, matched.startIndex) +
                                        getReplacementString(matched, replacement);
    index = matched.endIndex;
    if index < length {
        updatedString += strings:substring(originalString, index, length);
    }
    return updatedString;
}

# Replaces each occurrence of the substrings, which match the provided
# regex from the given original string value with the provided replacement string.
# Note that `\\` is used as for escape sequence and `\\\\` is used to insert a backslash
# character in the string or regular expression. The following special characters should be escaped
# in the regex definition.
# Special Characters: `.`, `+`, `*`, `?`, `^`, `$`, `(`, `)`, `[`, `]`,` {`, `}`
#
# ```ballerina
# string result = regex:replaceAll("Ballerina is great", "\\s+", "_");
# ```
#
# + originalString - The original string to replace the occurrences of the
#                    substrings that match the provided regex
# + regex - The regex to match the substrings in the `originalString` , which is to be replaced
# + replacement - The replacement string or a function to be invoked to create the new substring to be
#                 used to replace the first match to the given regex
# + return - The resultant string with the replaced substrings
public isolated function replaceAll(string originalString, string regex, Replacement replacement) returns string {
    Match[] matchedArray = searchAll(originalString, regex);
    if matchedArray.length() == 0 {
        return originalString;
    }
    string updatedString = "";
    int startIndex = 0;
    foreach Match matched in matchedArray {
        updatedString += strings:substring(originalString, startIndex, matched.startIndex) +
                                           getReplacementString(matched, replacement);
        startIndex = matched.endIndex;
    }
    if startIndex < originalString.length() {
        updatedString += strings:substring(originalString, startIndex, originalString.length());
    }
    return updatedString;
}

# Replaces the first substring that matches the given regex with
# the provided replacement string.
# Note that `\\` is used as for escape sequence and `\\\\` is used to insert a backslash
# character in the string or regular expression. The following special characters should be escaped
# in the regex definition.
# Special Characters: `.`, `+`, `*`, `?`, `^`, `$`, `(`, `)`, `[`, `]`,` {`, `}`
#
# ```ballerina
# string result = regex:replaceFirst("Ballerina is great", "\\s+", "_");
# ```
#
# + originalString - The original string to replace the first occurrence of the
#                    substring that matches the provided regex
# + regex - The regex to match the first substring in the `originalString` to
#           be replaced
# + replacement - The replacement string to replace the first substring, which
#                 matches the regex
# + return - The resultant string with the replaced substring
# # Deprecated
# This function will be removed in a later. Use `replace` instead.
@deprecated
public isolated function replaceFirst(string originalString, string regex, string replacement) returns string {
    return replace(originalString, regex, replacement);
}

# Returns an array of strings by splitting a string using the provided
# regex as the delimiter.
# Note that `\\` is used as for escape sequence and `\\\\` is used to insert a backslash
# character in the string or regular expression. The following special characters should be escaped
# in the regex definition.
# Special Characters: `.`, `+`, `*`, `?`, `^`, `$`, `(`, `)`, `[`, `]`,` {`, `}`
#
# ```ballerina
# string[] result = regex:split("Ballerina is great", " ");
# ```
#
# + receiver - The string to split
# + delimiter - The delimiter is a regex, which splits the given string
# + return - An array of strings containing the individual strings that are split
public isolated function split(string receiver, string delimiter) returns string[] {
    handle res = splitExternal(java:fromString(receiver), java:fromString(delimiter));
    return getBallerinaStringArray(res);
}

# Returns the first substring in str that matches the regex.
# Note that `\\` is used as for escape sequence and `\\\\` is used to insert a backslash
# character in the string or regular expression. The following special characters should be escaped
# in the regex definition.
# Special Characters: `.`, `+`, `*`, `?`, `^`, `$`, `(`, `)`, `[`, `]`,` {`, `}`
#
# ```ballerina
# regex:Match? result = regex:search("Betty Botter bought some butter but she said the butter’s bitter.",
#                                    "\\b[bB].tt[a-z]*");
# ```
#
# + str - The string to be matched
# + regex - The regex value
# + startIndex - The starting index for the search
# + return - a `Match` record which holds the matched substring, or nil if there is no match
public isolated function search(string str, string regex, int startIndex = 0) returns Match? {
    string extractedString = getSubstring(str, startIndex);
    handle matcher = getMatcher(extractedString, regex);
    int groupCount = getGroupCount(matcher);
    if isMatched(matcher) {
        PartMatch[] partMatch = getPartMatch(matcher, groupCount, startIndex);
        Match matched = {
            matched: partMatch[0].matched,
            startIndex: partMatch[0].startIndex,
            endIndex: partMatch[0].endIndex,
            groups: new MatchGroups(partMatch, groupCount)
        };
        return matched;
    }
    return ();
}

# Returns all substrings in string that match the regex.
# Note that `\\` is used as for escape sequence and `\\\\` is used to insert a backslash
# character in the string or regular expression. The following special characters should be escaped
# in the regex definition.
# Special Characters: `.`, `+`, `*`, `?`, `^`, `$`, `(`, `)`, `[`, `]`,` {`, `}`
#
# ```ballerina
# regex:Match[] result = regex:searchAll("Betty Botter bought some butter but she said the butter’s bitter.",
#                                      "\\b[bB].tt[a-z]*");
# ```
#
# + str - The string to be matched
# + regex - The regex value
# + return - An array of `Match` records
public isolated function searchAll(string str, string regex) returns Match[] {
    handle matcher = getMatcher(str, regex);
    Match[] matched = [];
    int groupCount = getGroupCount(matcher);
    while isMatched(matcher) {
        PartMatch[] partMatch = getPartMatch(matcher, groupCount);
        matched.push(
            {
            matched: partMatch[0].matched,
            startIndex: partMatch[0].startIndex,
            endIndex: partMatch[0].endIndex,
            groups: new MatchGroups(partMatch, groupCount)
        });
    }
    return matched;
}

// Interoperable external functions.
isolated function matchesExternal(handle stringToMatch, handle regex) returns boolean = @java:Method {
    name: "matches",
    'class: "java.lang.String",
    paramTypes: ["java.lang.String"]
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
    'class: "io.ballerina.runtime.api.utils.StringUtils",
    name: "fromStringArray",
    paramTypes: ["[Ljava.lang.String;"]
} external;

isolated function getMatcherFromPattern(handle patternJObj, handle input) returns handle = @java:Method {
    name: "matcher",
    'class: "java.util.regex.Pattern"
} external;

isolated function isMatched(handle matcherObj) returns boolean = @java:Method {
    name: "find",
    'class: "java.util.regex.Matcher"
} external;

isolated function getGroup(handle matcherObj, int index) returns handle = @java:Method {
    name: "group",
    'class: "java.util.regex.Matcher",
    paramTypes: ["int"]
} external;

isolated function getStartIndex(handle matcherObj) returns int = @java:Method {
    name: "start",
    'class: "java.util.regex.Matcher"
} external;

isolated function getEndIndex(handle matcherObj) returns int = @java:Method {
    name: "end",
    'class: "java.util.regex.Matcher"
} external;

isolated function regexCompile(handle regex) returns handle = @java:Method {
    name: "compile",
    'class: "java.util.regex.Pattern"
} external;

isolated function getGroupStartIndex(handle matcherObj, int index) returns int = @java:Method {
    name: "start",
    'class: "java.util.regex.Matcher",
    paramTypes: ["int"]
} external;

isolated function getGroupEndIndex(handle matcherObj, int index) returns int = @java:Method {
    name: "end",
    'class: "java.util.regex.Matcher",
    paramTypes: ["int"]
} external;

isolated function getGroupCount(handle matcherObj) returns int = @java:Method {
    name: "groupCount",
    'class: "java.util.regex.Matcher"
} external;
