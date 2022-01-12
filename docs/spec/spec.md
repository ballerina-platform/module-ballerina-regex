# Specification: Ballerina Regex Library

_Owners_: @daneshk @kalaiyarasiganeshalingam  
_Reviewers_: @daneshk  
_Created_: 2021/12/07   
_Updated_: 2021/01/11  
_Issue_: [#2323](https://github.com/ballerina-platform/ballerina-standard-library/issues/2323)

# Introduction
This is the specification for the Regex standard library, which provides functionalities such as matching, 
replacing and splitting strings based on regular expressions in the 
[Ballerina programming language](https://ballerina.io/), which is an open-source programming language for the cloud that
makes it easier to use, combine, and create network services.

# Contents
1. [Overview](#1-overview)
2. [Operations](#2-operations)
    * 2.1. [Matches](#21-matches)
    * 2.2. [Replace All](#22-replace-all)
    * 2.3. [Replace First](#23-replace-first)
    * 2.4. [Split](#24-split)

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

## 2.3. Replace First
This replaces only the first occurrence of the substring that matches the provided regex in the original string with 
the provided replacement string.
```ballerina
public isolated function replaceFirst(string originalString, string regex, string replacement) returns string;
```

## 2.4. Split
This splits a string into an array of substrings, using the provided regex as the delimiter.
```ballerina
public isolated function split(string receiver, string delimiter) returns string[];
```
