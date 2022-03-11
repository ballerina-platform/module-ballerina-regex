# Proposal: Improve the replacement functions

_Owners_: @daneshk @kalaiyarasiganeshalingam  
_Reviewers_: @daneshk  
_Created_: 2022/03/11   
_Updated_: 2022/03/11  
_Issues_: [#2772](https://github.com/ballerina-platform/ballerina-standard-library/issues/2772) 

## Summary
The existing replacement functions don't support the following functionalities:
- There is no way to replace the matches from the particular string index of the given string.
- There isn't any mechanism to replace the matches with a dynamic value.

So, this proposal improves the replacement functions to support the above functionalities.

## Goals
Provide a way to support the above functionalities.

## Motivation
This allows users to get the above functionalities when using replacement functions.

## Description
API improvements are:

- Introduce a function to create the new substring to be used to replace the matches. 
    ```ballerina
    # A function to be invoked to create the new substring to be used to replace the matches.
    type ReplacerFunction function(Match matched) returns string;
    ```

- Introduce a new type to get the replacement value.  
    ```ballerina
    # A function to be invoked to create the new substring or string value to be used to replace the matches.
    public type Replacement ReplacerFunction|string;
    ```

- Change the type of replacement param from string to `Replacement` type.
    ```ballerina
    # Replaces each occurrence of the substrings, which match the provided
    # regex from the given original string value with the
    # provided replacement string.
    # ```ballerina
    # string result = regex:replaceAll("Ballerina is great", "\\s+", "_");
    # ```
    #
    # + originalString - The original string to replace the occurrences of the
    #                    substrings that match the provided regex
    # + regex - The regex to match the substrings in the `originalString` , which is to be replaced
    # + replacement - The replacement string or function to replace the substrings, which
    #                 match the regex
    # + return - The resultant string with the replaced substrings
    public isolated function replaceAll(string originalString, string regex, Replacement replacement) returns string;
    ```

- Change the type of replacement param from string to `Replacement` type and introduce a new param `startIndex`.
    ```ballerina
    # Replaces the first substring that matches the given regex with
    # the provided replacement string or function.
    # ```ballerina
    # string result = regex:replace("Ballerina is great", "\\s+", "_");
    # ```
    #
    # + originalString - The original string to replace the first occurrence of the
    #                    substring that matches the provided regex
    # + regex - The regex to match the first substring in the `originalString` to
    #           be replaced
    # + replacement - The replacement string or function to replace the first substring, which
    #                 matches the regex
    # + startIndex - The starting index for the search
    # + return - The resultant string with the replaced substring
    public isolated function replace(string originalString, string regex, Replacement replacement, int startIndex = 0) 
                             returns string;
    ```
