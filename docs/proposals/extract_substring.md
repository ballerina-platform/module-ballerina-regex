## Summary
The Ballerina Regex module doesn't have any API to extract a substring/s from the given string by using regex. So, this proposal introduces new APIs to extract a substring/s from the given string using regex.

## Goals

- Provide a way to extract a substring/s using regex.

## Motivation
As mentioned in the summary, at the moment, users have no way to extract a substring/s from the given string. But this is an important feature in string manipulation. So, this allows users to extract a substring/s easily by using Ballerina.

## Description

```ballerina
# Holds the matched substring and its position in the input string.
#
# + matched - Matched substring
# + startIndex - The start index of the match
# + endIndex - The last index of the match
type PartMatch record {|
string matched;
int startIndex;
int endIndex;
|};
```
```ballerina
# Holds information about matched regex groups
public type Groups readonly & object {
int count;
// Capture groups are indexed from 1
// Group 0 means whole regex
// Panics if i < 0 or > count
isolated function get(int i) returns PartMatch?;
};
```

```ballerina
# Holds the results of a match against a regular expression.
# It contains the match boundaries, groups and group boundaries.
#
# + groups - Information about matched regex groups
public type Match record {|
// The match for the whole regex
*PartMatch;
Groups groups;
|};
```

```ballerina
# Returns the first substring in str that matches the regex.
# ```ballerina
# regex:Match? result = regex:search("Betty Botter bought some butter but she said the butter’s bitter.", "\\b[bB].tt[a-z]*");
# ```
#
# + str - The string to be matched
# + regex - The regex value
# + startIndex - The starting index for the search
# + return - a `Match` record which holds the matched substring, or nil if there is no match
public isolated function search(string str, string regex, int startIndex = 0) returns Match?;
```

```ballerina
# Returns all substrings in str that match the regex.
# ```ballerina
# regex:Match[] result = regex:searchAll(""Betty Botter bought some butter but she said the butter’s bitter.", "\\b[bB].tt[a-z]*");
# ```
#
# + str - The string to be matched
# + regex - The regex value
# + return - An array of `Match` records
# Each member holds a matched substring
public isolated function searchAll(string str, string regex) returns Match[];
```
