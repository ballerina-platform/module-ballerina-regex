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

import ballerina/test;

@test:Config{}
isolated function testMatches() {
    string stringToMatch = "This Should Match";
    string regex = "Th.*ch";
    boolean actualvalue = matches(stringToMatch, regex);
    test:assertTrue(actualvalue, msg = "AssertTrue failed");
}

@test:Config{}
isolated function testReplaceAll() {
    string original = "ReplaceTTTGGGThis";
    string regex = "T.*G";
    string replacement = " ";
    string actualvalue = replaceAll(original, regex, replacement);
    test:assertEquals(actualvalue, "Replace This", msg = "String values are not equal");
}

@test:Config{}
isolated function testReplaceFirst() {
    string original = "ReplaceThisThisTextThis";
    string regex = "This";
    string replacement = " ";
    string actualvalue = replaceFirst(original, regex, replacement);
    test:assertEquals(actualvalue, "Replace ThisTextThis", msg = "String values are not equal");
}

@test:Config{}
isolated function testSplit() {
    string testStr = "amal,,kamal,,nimal,,sunimal,";
    string[] actualvalue = split(testStr, ",,");
    test:assertEquals(actualvalue, ["amal", "kamal", "nimal", "sunimal,"], msg = "Array values are not equal");
}
