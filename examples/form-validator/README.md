# Ballerina Regex Module Example Use Case - Form Input Validator

## Overview
This example demonstrates how to use the Ballerina `Regex` module to to perform basic functions using regular expressions.

This example consists of an HTTP service is created with multiple endpoints to validate various user inputs such as `username`, `password`, `date of birth`, `email address` and `phone number`. Please note the process outlined here is for example purposes only, and is not the recommended method to implement a secure form validation service.

Here, the following methods in the Ballerina `Regex` module are used,
* `matches`
* `replaceAll`
* `split`

## Running the service

The example service can be run by executing the command `bal run`, which should produce the following output.
```shell
Compiling source
        wso2/form_validator:0.1.0

Running executable

[ballerina/http] started HTTP/WS listener 0.0.0.0:8080
```

This creates an HTTP service with the endpoint `/validate` on port 8080 that can be used to validate user provided inputs.

## Validation Methods

### Validate Username - method:`GET`
* This would validate a provided value to ensure it meets the required criteria for a username. For this example, the requirements are:
    * Must contain between 4-20 characters
    * Can only contain alpha-numeric characters, periods and underscores
* Example CURL request:
    ```shell
    curl --location --request GET 'localhost:8080/validate/username?value=test_username'
    ```

### Validate Password - method:`GET`
* This would validate a provided value to ensure it meets the required criteria for a password. For this example, the requirements are:
    * Must contain at least 8 characters
    * Must contain at least one uppercase 
    * Must contain at least one lowercase character
    * Must contain at least one number
* Example CURL request:
    ```shell
    curl --location --request GET 'localhost:8080/validate/password?value=TestPass123'
    ```

### Validate Date of Birth - method:`GET`
* This would validate a provided value to ensure it meets the required criteria for a date of birth. For this example, the requirements are:
    * Must be a string in the format `YYYY-MM-DD`
    * Year of birth must be before the year 2000
* Example CURL request:
    ```shell
    curl --location --request GET 'localhost:8080/validate/dob?value=1990-11-11'
    ```

### Validate Date of Email Address - method:`GET`
* This would validate a provided value to ensure it meets the standard email address format.
* Example CURL request:
    ```shell
    curl --location --request GET 'localhost:8080/validate/email?value=test@example.com'
    ```

### Validate Phone Number - method:`GET`
* This would validate a provided value to ensure it meets the standard international phone number format. All filler character such as whitespace, "-" and "." are removed before the check is done.
* Example CURL request:
    ```shell
    curl --location --request GET 'localhost:8080/validate/phone?value=%2B947719522226'
    ```


### Validate User - method:`POST`
* This would validate a provided JSON string to ensure it meets all the criteria needed for each field.
* Example CURL request:
    ```shell
    curl --location --request POST 'localhost:8080/validate/user' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "username":"test_usernmae",
        "password": "TestPass123",
        "dob": "1990-11-11",
        "email":"test@example.com",
        "phone": "+94 77 195 2226"
    }'
    ```