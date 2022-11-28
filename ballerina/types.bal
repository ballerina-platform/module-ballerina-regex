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

# Holds the matched substring and its position in the input string.
#
# + matched - Matched substring
# + startIndex - The start index of the match
# + endIndex - The last index of the match
public type PartMatch record {|
    string matched;
    int startIndex;
    int endIndex;
|};

# Abstract object representation to hold information about matched regex groups.
public type Groups readonly & object {

    int count;

    // Capture groups are indexed from 1
    // Group 0 means whole regex
    // Panics if i < 0 or > count
    public isolated function get(int index) returns PartMatch?;
};

# Holds the results of a match against a regular expression. 
# It contains the match boundaries, groups, and group boundaries.
#
# + groups - Information about matched regex groups
public type Match record {|

    *PartMatch;
    Groups groups;
|};

# A function to be invoked to create the new substring to be used to replace the matches.
type ReplacerFunction isolated function (Match matched) returns string;

# A type to be used to get a replacement string.
public type Replacement ReplacerFunction|string;
