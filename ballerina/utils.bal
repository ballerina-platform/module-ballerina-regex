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

isolated function getReplacementString(Match matched, Replacement replacement) returns string {
    if replacement is string {
        return replacement;
    }
    return replacement(matched);
}

isolated function getMatcher(string str, string regex) returns handle {
    return getMatcherFromPattern(regexCompile(java:fromString(regex)), java:fromString(str));
}

# This class is used to get the matched substring and its position in the input string which is matched with a
# particular index of a group.
readonly class MatchGroups {

    *Groups;
    private PartMatch[] partMatch;

    isolated function init(PartMatch[] partMatch, int groupCount) {
        self.partMatch = partMatch.cloneReadOnly();
        self.count = groupCount;
    }

    public isolated function get(int index) returns PartMatch? {
        if index < 0 || index > self.count {
            panic error("There is no capturing group in the pattern with the given index " + index.toString() + ".");
        }
        if self.partMatch.length() == 0 {
            return ();
        }
        return self.partMatch[index];
    }
}

isolated function getPartMatch(handle matcher, int groupCount, int startIndex = 0) returns PartMatch[] {
    int i = 0;
    PartMatch[] partMatch = [];
    while i <= groupCount {
        handle group = getGroup(matcher, i);
        string? valueInString = java:toString(group);
        if valueInString is string {
            partMatch.push(
                {
                matched: valueInString,
                startIndex: getGroupStartIndex(matcher, i) + startIndex,
                endIndex: getGroupEndIndex(matcher, i) + startIndex
            });
        }
        i += 1;
    }
    return partMatch;
}
