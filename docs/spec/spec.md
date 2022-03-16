# Specification: Ballerina Regex Library

_Owners_: @daneshk @kalaiyarasiganeshalingam  
_Reviewers_: @daneshk  
_Created_: 2021/12/07  
_Updated_: 2022/02/17  
_Edition_: Swan Lake  
_Issue_: [#2323](https://github.com/ballerina-platform/ballerina-standard-library/issues/2323)

# Introduction  
This is the specification for the Regex standard library of [Ballerina language](https://ballerina.io/), which provides functionalities such as matching, replacing and splitting strings based on regular expressions.

The Regex library specification has evolved and may continue to evolve in the future. The released versions of the specification can be found under the relevant GitHub tag.

If you have any feedback or suggestions about the library, start a discussion via a [GitHub issue](https://github.com/ballerina-platform/ballerina-standard-library/issues) or in the [Slack channel](https://ballerina.io/community/). Based on the outcome of the discussion, the specification and implementation can be updated. Community feedback is always welcome. Any accepted proposal, which affects the specification is stored under `/docs/proposals`. Proposals under discussion can be found with the label `type/proposal` in GitHub.

The conforming implementation of the specification is released and included in the distribution. Any deviation from the specification is considered a bug.

# Contents
1. [Overview](#1-overview)
2. [Operations](#2-operations)
    * 2.1. [Matches](#21-matches)
    * 2.2. [Replace All](#22-replace-all)
    * 2.3. [Replace](#23-replace)
    * 2.4. [Split](#24-split)
    * 2.5. [Search All](#25-search-all)
    * 2.6. [Search](#26-search)

# 1. Overview
This library is based on [regular expressions](https://en.wikipedia.org/wiki/Regular_expression), which are notations 
for describing sets of character strings that specify a search pattern. It supports the [regular expression patterns of Java](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/util/regex/Pattern.html#sum).

# 2. Operations

## 2.1. Matches
This is used to check whether a string matches the provided regex.
```ballerina
public isolated function matches(string stringToMatch, string regex) returns boolean;
```

## 2.2. Replace All
This replaces all occurrences of substrings that matches the provided regex in the original string with the provided
replacement string.
```ballerina
public isolated function replaceAll(string originalString, string regex, string replacement) returns string;
```

## 2.3. Replace
This replaces only the first occurrence of the substring from the given `startIndex` that matches the provided regex in the original string with
the provided replacement string or string returned by the provided function.
```ballerina
public isolated function replace(string originalString, string regex, Replacement replacement, int startIndex = 0) returns string;
```

## 2.4. Split
This splits a string into an array of substrings, using the provided regex as the delimiter.
```ballerina
public isolated function split(string receiver, string delimiter) returns string[];
```

## 2.5. Search All
This is used to get all substrings in string that match the regex.
```ballerina
public isolated function searchAll(string str, string regex) returns Match[];
```

## 2.6. Search
This is used to get the first substring from the start index in the given string that matches the regex.
```ballerina
public isolated function search(string str, string regex, int startIndex = 0) returns Match?;
```
