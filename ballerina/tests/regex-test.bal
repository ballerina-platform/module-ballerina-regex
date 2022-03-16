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

@test:Config {}
isolated function testMatches() {
    string stringToMatch = "This Should Match";
    string regex = "Th.*ch";
    boolean actualvalue = matches(stringToMatch, regex);
    test:assertTrue(actualvalue, msg = "AssertTrue failed");
}

@test:Config {}
isolated function testReplaceAll() {
    string original = "ReplaceTTTGGGThis";
    string regex = "T.*G";
    string replacement = " ";
    string actualvalue = replaceAll(original, regex, replacement);
    test:assertEquals(actualvalue, "Replace This", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceAll1() {
    string original = "100100011";
    string regex = "0+";
    string replacement = "*";
    string actualvalue = replaceAll(original, regex, replacement);
    test:assertEquals(actualvalue, "1*1*11", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceAllWithNoMatches() {
    string original = "100100011";
    string regex = "95";
    string replacement = "*";
    string actualvalue = replaceAll(original, regex, replacement);
    test:assertEquals(actualvalue, original, msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceAllWithEmptyReplacementValue() {
    string original = "100100011";
    string regex = "0+";
    string replacement = "";
    string actualvalue = replaceAll(original, regex, replacement);
    test:assertEquals(actualvalue, "1111", msg = "String values are not equal");
}

isolated function replacementFuctionForReplaceAll(Match matched) returns string {
    return matched.matched.length().toString();
}

@test:Config {}
isolated function testReplaceAllWithReplacementFuction() {
    string original = "100000100011";
    string regex = "0+";
    string actualvalue = replaceAll(original, regex, replacementFuctionForReplaceAll);
    test:assertEquals(actualvalue, "151311", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceAllWithReplacementFuction1() {
    string original = "10000010001";
    string regex = "0+";
    string actualvalue = replaceAll(original, regex, replacementFuctionForReplaceAll);
    test:assertEquals(actualvalue, "15131", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceFirst() {
    string original = "ReplaceThisThisTextThis";
    string regex = "This";
    string replacement = " ";
    string actualvalue = replaceFirst(original, regex, replacement);
    test:assertEquals(actualvalue, "Replace ThisTextThis", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceFirst1() {
    string original = "ReplaceThisThisTextThis";
    string regex = "This";
    string replacement = "$ ";
    string actualvalue = replaceFirst(original, regex, replacement);
    test:assertEquals(actualvalue, "Replace$ ThisTextThis", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceFirst2() {
    string original = "ReplaceThisThisTextThis";
    string regex = "This";
    string replacement = "$1 ";
    string actualvalue = replaceFirst(original, regex, replacement);
    test:assertEquals(actualvalue, "Replace$1 ThisTextThis", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceFirst3() {
    string original = "ReplaceThisThisTextThis";
    string regex = "This";
    string replacement = "$this ";
    string actualvalue = replaceFirst(original, regex, replacement);
    test:assertEquals(actualvalue, "Replace$this ThisTextThis", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplace() {
    string original = "10010011";
    string regex = "0+";
    string replacement = "*";
    string actualvalue = replace(original, regex, replacement);
    test:assertEquals(actualvalue, "1*10011", msg = "String values are not equal");
}

isolated function replacementFuctionForReplace(Match matched) returns string {
    return matched.endIndex.toString();
}

@test:Config {}
isolated function testReplaceWithReplacementFuction() {
    string original = "100100011";
    string regex = "0+";
    string actualvalue = replace(original, regex, replacementFuctionForReplace);
    test:assertEquals(actualvalue, "13100011", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceWithReplacementFuction1() {
    string original = "100100011";
    string regex = "2";
    string actualvalue = replace(original, regex, replacementFuctionForReplace);
    test:assertEquals(actualvalue, "100100011", msg = "String values are not equal");
}

@test:Config {}
isolated function testReplaceWithStartIndex() {
    string original = "100100011";
    string regex = "0+";
    string actualvalue = replace(original, regex, replacementFuctionForReplace, 4);
    test:assertEquals(actualvalue, "1001711", msg = "String values are not equal");
}

@test:Config {}
isolated function testSplit() {
    string testStr = "amal,,kamal,,nimal,,sunimal,";
    string[] actualvalue = split(testStr, ",,");
    test:assertEquals(actualvalue, ["amal", "kamal", "nimal", "sunimal,"], msg = "Array values are not equal");
}

@test:Config {}
isolated function testSearchWithGroupIndex() {
    string original = "1001100011";
    string regex = "(0)(1+)";
    Match? actualvalue = search(original, regex);
    if (actualvalue is Match) {
        test:assertEquals(actualvalue.matched, "011", msg = "Incorrect string value");
        test:assertEquals(actualvalue.startIndex, 2, msg = "Incorrect string value");
        test:assertEquals(actualvalue.endIndex, 5, msg = "Incorrect string value");
        Groups group = actualvalue.groups;
        PartMatch? partMatch = group.get(1);
        if partMatch is PartMatch {
            test:assertEquals(partMatch.matched, "0", msg = "Incorrect string value");
            test:assertEquals(partMatch.startIndex, 2, msg = "Incorrect string value");
            test:assertEquals(partMatch.endIndex, 3, msg = "Incorrect string value");
        }
        PartMatch? partMatch1 = group.get(2);
        if partMatch1 is PartMatch {
            test:assertEquals(partMatch1.matched, "11", msg = "Incorrect string value");
            test:assertEquals(partMatch1.startIndex, 3, msg = "Incorrect string value");
            test:assertEquals(partMatch1.endIndex, 5, msg = "Incorrect string value");
        }
    } else {
        test:assertFail("Output is an empty");
    }
}

@test:Config {}
isolated function testSearchWithStartIndex() {
    string original = "100110001111111";
    string regex = "(0)(1+)";
    Match? actualvalue = search(original, regex, 5);
    if (actualvalue is Match) {
        test:assertEquals(actualvalue.matched, "01111111", msg = "Incorrect string value");
        test:assertEquals(actualvalue.startIndex, 7, msg = "Incorrect string value");
        test:assertEquals(actualvalue.endIndex, 15, msg = "Incorrect string value");
        Groups group = actualvalue.groups;
        PartMatch? partMatch = group.get(0);
        if partMatch is PartMatch {
            test:assertEquals(partMatch.matched, "01111111", msg = "Incorrect string value");
            test:assertEquals(partMatch.startIndex, 7, msg = "Incorrect string value");
            test:assertEquals(partMatch.endIndex, 15, msg = "Incorrect string value");
        }
        partMatch = group.get(1);
        if partMatch is PartMatch {
            test:assertEquals(partMatch.matched, "0", msg = "Incorrect string value");
            test:assertEquals(partMatch.startIndex, 7, msg = "Incorrect string value");
            test:assertEquals(partMatch.endIndex, 8, msg = "Incorrect string value");
        }
        partMatch = group.get(2);
        if partMatch is PartMatch {
            test:assertEquals(partMatch.matched, "1111111", msg = "Incorrect string value");
            test:assertEquals(partMatch.startIndex, 8, msg = "Incorrect string value");
            test:assertEquals(partMatch.endIndex, 15, msg = "Incorrect string value");
        }
        PartMatch?|error err = trap group.get(3);
        test:assertTrue(err is error);
        if err is error {
            test:assertEquals(err.message(), "There is no capturing group in the pattern with the given index 3.",
                            msg = "Outputs are not equal");
        }
    } else {
        test:assertFail("Output is an empty");
    }
}

@test:Config {}
isolated function testSearchWithInvalidGroupIndex() {
    string original = "100100011";
    string regex = "0+";
    Match? actualvalue = search(original, regex);
    if (actualvalue is Match) {
        test:assertEquals(actualvalue.matched, "00", msg = "Incorrect string value");
        test:assertEquals(actualvalue.startIndex, 1, msg = "Incorrect string value");
        test:assertEquals(actualvalue.endIndex, 3, msg = "Incorrect string value");
        Groups group = actualvalue.groups;
        PartMatch?|error err = trap group.get(1);
        test:assertTrue(err is error);
        if err is error {
            test:assertEquals(err.message(), "There is no capturing group in the pattern with the given index 1.",
                            msg = "Outputs are not equal");
        }
    } else {
        test:assertFail("Output is an empty");
    }
}

@test:Config {}
isolated function testSearchAll() {
    string original = "10010001";
    string regex = "0+";
    Match[] actualvalue = searchAll(original, regex);
    test:assertEquals(actualvalue.length(), 2, msg = "Incorrect match");
    test:assertEquals(actualvalue[0].matched, "00", msg = "Incorrect string value");
    test:assertEquals(actualvalue[0].startIndex, 1, msg = "Incorrect start index");
    test:assertEquals(actualvalue[0].endIndex, 3, msg = "Incorrect end index");
    test:assertEquals(actualvalue[1].matched, "000", msg = "Incorrect string value");
    test:assertEquals(actualvalue[1].startIndex, 4, msg = "Incorrect start index value");
    test:assertEquals(actualvalue[1].endIndex, 7, msg = "Incorrect end index value");
}

@test:Config {}
isolated function testSearchAllWithGroupIndex() {
    string original = "10011000111";
    string regex = "(0)(1+)";
    Match[] actualvalue = searchAll(original, regex);
    test:assertEquals(actualvalue.length(), 2, msg = "Incorrect match");
    test:assertEquals(actualvalue[0].matched, "011", msg = "Incorrect string value");
    test:assertEquals(actualvalue[0].startIndex, 2, msg = "Incorrect start index");
    test:assertEquals(actualvalue[0].endIndex, 5, msg = "Incorrect end index");
    Groups group = actualvalue[0].groups;
    PartMatch? value = group.get(0);
    test:assertTrue(value is PartMatch);
    if value is PartMatch {
        test:assertEquals(value.matched, "011", msg = "Incorrect string value");
        test:assertEquals(value.startIndex, 2, msg = "Incorrect start index");
        test:assertEquals(value.endIndex, 5, msg = "Incorrect end index");
    }
    value = group.get(1);
    test:assertTrue(value is PartMatch);
    if value is PartMatch {
        test:assertEquals(value.matched, "0", msg = "Incorrect string value");
        test:assertEquals(value.startIndex, 2, msg = "Incorrect start index");
        test:assertEquals(value.endIndex, 3, msg = "Incorrect end index");
    }
    value = group.get(2);
    test:assertTrue(value is PartMatch);
    if value is PartMatch {
        test:assertEquals(value.matched, "11", msg = "Incorrect string value");
        test:assertEquals(value.startIndex, 3, msg = "Incorrect start index");
        test:assertEquals(value.endIndex, 5, msg = "Incorrect end index");
    }
    test:assertEquals(actualvalue[1].matched, "0111", msg = "Incorrect string value");
    test:assertEquals(actualvalue[1].startIndex, 7, msg = "Incorrect start index value");
    test:assertEquals(actualvalue[1].endIndex, 11, msg = "Incorrect end index value");
    group = actualvalue[1].groups;
    value = group.get(0);
    test:assertTrue(value is PartMatch);
    if value is PartMatch {
        test:assertEquals(value.matched, "0111", msg = "Incorrect string value");
        test:assertEquals(value.startIndex, 7, msg = "Incorrect start index");
        test:assertEquals(value.endIndex, 11, msg = "Incorrect end index");
    }
    value = group.get(1);
    test:assertTrue(value is PartMatch);
    if value is PartMatch {
        test:assertEquals(value.matched, "0", msg = "Incorrect string value");
        test:assertEquals(value.startIndex, 7, msg = "Incorrect start index");
        test:assertEquals(value.endIndex, 8, msg = "Incorrect end index");
    }
    value = group.get(2);
    test:assertTrue(value is PartMatch);
    if value is PartMatch {
        test:assertEquals(value.matched, "111", msg = "Incorrect string value");
        test:assertEquals(value.startIndex, 8, msg = "Incorrect start index");
        test:assertEquals(value.endIndex, 11, msg = "Incorrect end index");
    }
}
