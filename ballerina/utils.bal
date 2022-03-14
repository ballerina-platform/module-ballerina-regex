// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

isolated function getSubstring(string str, int startIndex) returns string {
    if startIndex == 0 {
        return str;
    }
    return strings:substring(str, startIndex, str.length());
}

isolated function getReplacementString(string str, string regex, Replacement replacement, int startIndex = 0)
                            returns string|error {
    if replacement is string {
        return replacement;
    } else {
        Match?|error matched = trap search(str, regex, startIndex);
        if matched is Match {
            return replacement(matched);
        } else {
            return error("There is no matching substrig in the given string.");
        }
    }    
}

isolated function getStringFromReplacerFunction(Match matched, ReplacerFunction replacement) returns string {
    return replacement(matched);
}

isolated function getMatcher(string str, string regex) returns handle {
    return getMatcherFromPattern(regexCompile(java:fromString(regex)), java:fromString(str));
}

# This class is used to get the matched substring and its position in the input string which is matched with a
# particular index of a group.
readonly class MatchGroups {

    *Groups;
    private handle matcher;
    private int startIndex;
    private string? value;
    private string regex;
    int count;

    isolated function init(handle matcher, int startIndex, string regex = "", string? value = ()) {
        self.matcher = matcher;
        self.startIndex = startIndex;
        self.value = value;
        self.regex = regex;
        self.count = getGroupCount(matcher);
    }

    isolated function get(int index) returns PartMatch? {
        if (index < 0 || index > self.count) {
            panic error("There is no capturing group in the pattern with the given index " + index.toString() + ".");
        }
        if self.value is string { // Getting the group data for the`searchAll` group(i)
            Match? matched = search(self.value.toString(), self.regex.toString());
            if matched is Match {
                PartMatch? partMatched = matched.groups.get(index);
                if partMatched is PartMatch {
                    partMatched = {
                        matched: partMatched.matched,
                        startIndex: partMatched.startIndex + self.startIndex,
                        endIndex: partMatched.endIndex + self.startIndex
                    };
                }
                return partMatched;
            }
        } else {
            handle|error group = trap getGroup(self.matcher, index);
            if group is error {
                return null; // IllegalStateException(No match found)
            }
            string? valueInString = java:toString(group);
            if valueInString is string {
                PartMatch partMatch = {
                    matched: valueInString,
                    startIndex: getGroupStartIndex(self.matcher, index) + self.startIndex,
                    endIndex: getGroupEndIndex(self.matcher, index) + self.startIndex
                };
                return partMatch;
            }
        }
        return null;
    }
}

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
