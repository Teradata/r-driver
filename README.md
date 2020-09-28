## Teradata SQL Driver for R

This package enables R applications to connect to the Teradata Database.

This package implements the [DBI Specification](https://dbi.r-dbi.org/).

This package requires 64-bit R 3.4.3 or later, and runs on Windows, macOS, and Linux. 32-bit R is not supported.

For community support, please visit the [Teradata Community forums](https://community.teradata.com/).

For Teradata customer support, please visit [Teradata Access](https://access.teradata.com/).

Please note, this driver may contain beta/preview features ("Beta Features"). As such, by downloading and/or using the driver, in addition to agreeing to the licensing terms below, you acknowledge that the Beta Features are experimental in nature and that the Beta Features are provided "AS IS" and may not be functional on any machine or in any environment.

Copyright 2020 Teradata. All Rights Reserved.

### Table of Contents

* [Features](#Features)
* [Limitations](#Limitations)
* [Installation](#Installation)
* [License](#License)
* [Documentation](#Documentation)
* [Sample Programs](#SamplePrograms)
* [Using the Teradata SQL Driver for R](#Using)
* [Connection Parameters](#ConnectionParameters)
* [COP Discovery](#COPDiscovery)
* [Stored Password Protection](#StoredPasswordProtection)
* [Transaction Mode](#TransactionMode)
* [Auto-Commit](#AutoCommit)
* [Data Types](#DataTypes)
* [Null Values](#NullValues)
* [Character Export Width](#CharacterExportWidth)
* [Constructors](#Constructors)
* [Driver Methods](#DriverMethods)
* [Connection Methods](#ConnectionMethods)
* [Result Methods](#ResultMethods)
* [Escape Syntax](#EscapeSyntax)
* [FastLoad](#FastLoad)
* [Change Log](#ChangeLog)

<a name="Features"></a>

### Features

The *Teradata SQL Driver for R* is a DBI Driver that enables R applications to connect to the Teradata Database. The Teradata SQL Driver for R implements the [DBI Specification](https://dbi.r-dbi.org/).

The Teradata SQL Driver for R is a young product that offers a basic feature set. We are working diligently to add features to the Teradata SQL Driver for R, and our goal is feature parity with the Teradata JDBC Driver.

At the present time, the Teradata SQL Driver for R offers the following features.

* Supported for use with Teradata Database 14.10 and later releases.
* COP Discovery.
* Encrypted logon using the `TD2`, `JWT`, `LDAP`, `KRB5` (Kerberos), or `TDNEGO` logon mechanisms.
* Data encryption enabled via the `encryptdata` connection parameter.
* Unicode character data transferred via the UTF8 session character set.
* Auto-commit for ANSI and TERA transaction modes.
* 1 MB rows supported with Teradata Database 16.0 and later.
* Multi-statement requests that return multiple result sets.
* Most JDBC escape syntax.
* Parameterized SQL requests with question-mark parameter markers.
* Parameterized batch SQL requests with multiple rows of data bound to question-mark parameter markers.
* ElicitFile protocol support for DDL commands that create external UDFs or stored procedures and upload a file from client to database.
* `CREATE PROCEDURE` and `REPLACE PROCEDURE` commands.
* Stored Procedure Dynamic Result Sets.

<a name="Limitations"></a>

### Limitations

* The UTF8 session character set is always used. The `charset` connection parameter is not supported.
* The following complex data types are not supported yet: `JSON`, `DATASET STORAGE FORMAT AVRO`, and `DATASET STORAGE FORMAT CSV`.
* No support yet for data encryption that is governed by central administration. To enable data encryption, you must specify a `true` value for the `encryptdata` connection parameter.
* Laddered Concurrent Connect is not supported yet.
* No support yet for Recoverable Network Protocol and Redrive.
* FastExport is not available yet.
* Monitor partition support is not available yet.

<a name="Installation"></a>

### Installation

The Teradata SQL Driver for R contains binary code and cannot be offered from [CRAN](https://cran.r-project.org/). The Teradata SQL Driver for R is available from Teradata's R package repository.

The Teradata SQL Driver for R depends on the `bit64`, `DBI`, `digest`, and `hms` packages which are available from CRAN.

To download and install dependencies automatically, specify the Teradata R package repository and CRAN in the `repos` argument for `install.packages`.

    Rscript -e "install.packages('teradatasql',repos=c('https://teradata-download.s3.amazonaws.com','https://cloud.r-project.org'))"

<a name="License"></a>

### License

Use of the Teradata SQL Driver for R is governed by the *License Agreement for the Teradata SQL Driver for R*.

When the Teradata SQL Driver for R is installed, the `LICENSE` and `THIRDPARTYLICENSE` files are placed in the `teradatasql` directory under your R library directory. The following command prints the location of the `teradatasql` directory.

    Rscript -e "find.package('teradatasql')"

In addition to the license terms, the driver may contain beta/preview features ("Beta Features"). As such, by downloading and/or using the driver, in addition to the licensing terms, you acknowledge that the Beta Features are experimental in nature and that the Beta Features are provided "AS IS" and may not be functional on any machine or in any environment.

<a name="Documentation"></a>

### Documentation

When the Teradata SQL Driver for R is installed, the `README.md` file is placed in the `teradatasql` directory under your R library directory. This permits you to view the documentation offline, when you are not connected to the Internet. The following command prints the location of the `teradatasql` directory.

    Rscript -e "find.package('teradatasql')"

The `README.md` file is a plain text file containing the documentation for the Teradata SQL Driver for R. While the file can be viewed with any text file viewer or editor, your viewing experience will be best with an editor that understands Markdown format.

<a name="SamplePrograms"></a>

### Sample Programs

Sample programs are provided to demonstrate how to use the Teradata SQL Driver for R. When the Teradata SQL Driver for R is installed, the sample programs are placed in the `teradatasql/samples` directory under your R library directory.

The sample programs are coded with a fake Teradata Database hostname `whomooz`, username `guest`, and password `please`. Substitute your actual Teradata Database hostname and credentials before running a sample program.

Program                                                                                             | Purpose
--------------------------------------------------------------------------------------------------- | ---
[charpadding.R](https://github.com/Teradata/r-driver/blob/master/samples/charpadding.R)             | Demonstrates the Teradata Database's _Character Export Width_ behavior
[commitrollback.R](https://github.com/Teradata/r-driver/blob/master/samples/commitrollback.R)       | Demonstrates dbBegin, dbCommit, and dbRollback methods
[insertdate.R](https://github.com/Teradata/r-driver/blob/master/samples/insertdate.R)               | Demonstrates how to insert R Date values into a temporary table
[fakeresultsetcon.R](https://github.com/Teradata/r-driver/blob/master/samples/fakeresultsetcon.R)   | Demonstrates connection parameter for fake result sets
[fakeresultsetesc.R](https://github.com/Teradata/r-driver/blob/master/samples/fakeresultsetesc.R)   | Demonstrates escape function for fake result sets
[fastloadbatch.R](https://github.com/Teradata/r-driver/blob/master/samples/fastloadbatch.R)         | Demonstrates how to FastLoad batches of rows
[fetchmsr.R](https://github.com/Teradata/r-driver/blob/master/samples/fetchmsr.R)                   | Demonstrates fetching results from a multi-statement request
[fetchperftest.R](https://github.com/Teradata/r-driver/blob/master/samples/fetchperftest.R)         | Measures time to fetch rows from a large result set
[fetchsp.R](https://github.com/Teradata/r-driver/blob/master/samples/fetchsp.R)                     | Demonstrates fetching results from a stored procedure
[insertdifftime.R](https://github.com/Teradata/r-driver/blob/master/samples/insertdifftime.R)       | Demonstrates how to insert R difftime values into a temporary table
[inserthms.R](https://github.com/Teradata/r-driver/blob/master/samples/inserthms.R)                 | Demonstrates how to insert R hms values into a temporary table
[insertinteger.R](https://github.com/Teradata/r-driver/blob/master/samples/insertinteger.R)         | Demonstrates how to insert R integer values into a temporary table
[insertnumeric.R](https://github.com/Teradata/r-driver/blob/master/samples/insertnumeric.R)         | Demonstrates how to insert R numeric values into a temporary table
[insertposixct.R](https://github.com/Teradata/r-driver/blob/master/samples/insertposixct.R)         | Demonstrates how to insert R POSIXct values into a temporary table
[insertposixlt.R](https://github.com/Teradata/r-driver/blob/master/samples/insertposixlt.R)         | Demonstrates how to insert R POSIXlt values into a temporary table
[insertraw.R](https://github.com/Teradata/r-driver/blob/master/samples/insertraw.R)                 | Demonstrates how to insert R raw values into a temporary table
[inserttime.R](https://github.com/Teradata/r-driver/blob/master/samples/inserttime.R)               | Demonstrates how to insert teradatasql TimeWithTimeZone, Timestamp, and TimestampWithTimeZone values into a temporary table
[insertxml.R](https://github.com/Teradata/r-driver/blob/master/samples/insertxml.R)                 | Demonstrates how to insert and retrieve XML values
[TJEncryptPassword.R](https://github.com/Teradata/r-driver/blob/master/samples/TJEncryptPassword.R) | Creates encrypted password files

<a name="Using"></a>

### Using the Teradata SQL Driver for R

Your R script calls the `DBI::dbConnect` function to open a connection to the Teradata Database.

You may specify connection parameters as a JSON string, as named arguments, or using a combination of the two approaches. The `DBI::dbConnect` function's first argument is an instance of `teradatasql::TeradataDriver`. The `DBI::dbConnect` function's second argument is an optional JSON string. The `DBI::dbConnect` function's third and subsequent arguments are optional named arguments.

Connection parameters specified only as named arguments:

    con <- DBI::dbConnect(teradatasql::TeradataDriver(), host="whomooz", user="guest", password="please")

Connection parameters specified only as a JSON string:

    con <- DBI::dbConnect(teradatasql::TeradataDriver(), '{"host":"whomooz","user":"guest","password":"please"}')

Connection parameters specified using a combination:

    con <- DBI::dbConnect(teradatasql::TeradataDriver(), '{"host":"whomooz"}', user="guest", password="please")

When a combination of parameters are specified, connection parameters specified as named arguments take precedence over same-named connection parameters specified in the JSON string.

<a name="ConnectionParameters"></a>

### Connection Parameters

The following table lists the connection parameters currently offered by the Teradata SQL Driver for R.

Our goal is consistency for the connection parameters offered by the Teradata SQL Driver for R and the Teradata JDBC Driver, with respect to connection parameter names and functionality. For comparison, Teradata JDBC Driver connection parameters are [documented here](https://downloads.teradata.com/doc/connectivity/jdbc/reference/current/jdbcug_chapter_2.html#BGBHDDGB).

Parameter          | Default     | Type           | Description
------------------ | ----------- | -------------- | ---
`account`          |             | string         | Specifies the Teradata Database account. Equivalent to the Teradata JDBC Driver `ACCOUNT` connection parameter.
`column_name`      | `"false"`   | quoted boolean | Controls the `name` column returned by `DBI::dbColumnInfo`. Equivalent to the Teradata JDBC Driver `COLUMN_NAME` connection parameter. False specifies that the returned `name` column provides the AS-clause name if available, or the column name if available, or the column title. True specifies that the returned `name` column provides the column name if available, but has no effect when StatementInfo parcel support is unavailable.
`cop`              | `"true"`    | quoted boolean | Specifies whether COP Discovery is performed. Equivalent to the Teradata JDBC Driver `COP` connection parameter.
`coplast`          | `"false"`   | quoted boolean | Specifies how COP Discovery determines the last COP hostname. Equivalent to the Teradata JDBC Driver `COPLAST` connection parameter. When `coplast` is `false` or omitted, or COP Discovery is turned off, then no DNS lookup occurs for the coplast hostname. When `coplast` is `true`, and COP Discovery is turned on, then a DNS lookup occurs for a coplast hostname.
`database`         |             | string         | Specifies the initial database to use after logon, instead of the user's default database. Equivalent to the Teradata JDBC Driver `DATABASE` connection parameter.
`dbs_port`         | `"1025"`    | quoted integer | Specifies the Teradata Database port number. Equivalent to the Teradata JDBC Driver `DBS_PORT` connection parameter.
`encryptdata`      | `"false"`   | quoted boolean | Controls encryption of data exchanged between the Teradata Database and the Teradata SQL Driver for R. Equivalent to the Teradata JDBC Driver `ENCRYPTDATA` connection parameter.
`fake_result_sets` | `"false"`   | quoted boolean | Controls whether a fake result set containing statement metadata precedes each real result set.
`host`             |             | string         | Specifies the Teradata Database hostname.
`immediate`        | `"true"`    | quoted boolean | Controls whether `DBI::dbSendQuery` and `DBI::dbSendStatement` execute the SQL request when the `params` and `immediate` arguments are omitted.
`lob_support`      | `"true"`    | quoted boolean | Controls LOB support. Equivalent to the Teradata JDBC Driver `LOB_SUPPORT` connection parameter.
`log`              | `"0"`       | quoted integer | Controls debug logging. Somewhat equivalent to the Teradata JDBC Driver `LOG` connection parameter. This parameter's behavior is subject to change in the future. This parameter's value is currently defined as an integer in which the 1-bit governs function and method tracing, the 2-bit governs debug logging, the 4-bit governs transmit and receive message hex dumps, and the 8-bit governs timing. Compose the value by adding together 1, 2, 4, and/or 8.
`logdata`          |             | string         | Specifies extra data for the chosen logon authentication method. Equivalent to the Teradata JDBC Driver `LOGDATA` connection parameter.
`logmech`          | `"TD2"`     | string         | Specifies the logon authentication method. Equivalent to the Teradata JDBC Driver `LOGMECH` connection parameter. Possible values are `TD2` (the default), `JWT`, `LDAP`, `KRB5` for Kerberos, or `TDNEGO`.
`max_message_body` | `"2097000"` | quoted integer | Not fully implemented yet and intended for future usage. Equivalent to the Teradata JDBC Driver `MAX_MESSAGE_BODY` connection parameter.
`partition`        | `"DBC/SQL"` | string         | Specifies the Teradata Database Partition. Equivalent to the Teradata JDBC Driver `PARTITION` connection parameter.
`password`         |             | string         | Specifies the Teradata Database password. Equivalent to the Teradata JDBC Driver `PASSWORD` connection parameter.
`posixlt`          | `"false"`   | quoted boolean | Controls whether `POSIXlt` subclasses are used for certain result set column value types. Refer to the [Data Types](#DataTypes) table below for details.
`sip_support`      | `"true"`    | quoted boolean | Controls whether StatementInfo parcel is used. Equivalent to the Teradata JDBC Driver `SIP_SUPPORT` connection parameter.
`teradata_values`  | `"true"`    | quoted boolean | Controls whether `character` or a more specific R data type is used for certain result set column value types. Refer to the [Data Types](#DataTypes) table below for details.
`tmode`            | `"DEFAULT"` | string         | Specifies the transaction mode. Equivalent to the Teradata JDBC Driver `TMODE` connection parameter. Possible values are `DEFAULT` (the default), `ANSI`, or `TERA`.
`user`             |             | string         | Specifies the Teradata Database username. Equivalent to the Teradata JDBC Driver `USER` connection parameter.

<a name="COPDiscovery"></a>

### COP Discovery

The Teradata SQL Driver for R provides Communications Processor (COP) discovery behavior when the `cop` connection parameter is `true` or omitted. COP Discovery is turned off when the `cop` connection parameter is `false`.

A Teradata Database system can be composed of multiple Teradata Database nodes. One or more of the Teradata Database nodes can be configured to run the Teradata Database Gateway process. Each Teradata Database node that runs the Teradata Database Gateway process is termed a Communications Processor, or COP. COP Discovery refers to the procedure of identifying all the available COP hostnames and their IP addresses. COP hostnames can be defined in DNS, or can be defined in the client system's `hosts` file. Teradata strongly recommends that COP hostnames be defined in DNS, rather than the client system's `hosts` file. Defining COP hostnames in DNS provides centralized administration, and enables centralized changes to COP hostnames if and when the Teradata Database is reconfigured.

The `coplast` connection parameter specifies how COP Discovery determines the last COP hostname.
* When `coplast` is `false` or omitted, or COP Discovery is turned off, then the Teradata SQL Driver for R will not perform a DNS lookup for the coplast hostname.
* When `coplast` is `true`, and COP Discovery is turned on, then the Teradata SQL Driver for R will first perform a DNS lookup for a coplast hostname to obtain the IP address of the last COP hostname before performing COP Discovery. Subsequently, during COP Discovery, the Teradata SQL Driver for R will stop searching for COP hostnames when either an unknown COP hostname is encountered, or a COP hostname is encountered whose IP address matches the IP address of the coplast hostname.

Specifying `coplast` as `true` can improve performance with DNS that is slow to respond for DNS lookup failures, and is necessary for DNS that never returns a DNS lookup failure.

When performing COP Discovery, the Teradata SQL Driver for R starts with cop1, which is appended to the database hostname, and then proceeds with cop2, cop3, ..., copN. The Teradata SQL Driver for R supports domain-name qualification for COP Discovery and the coplast hostname. Domain-name qualification is recommended, because it can improve performance by avoiding unnecessary DNS lookups for DNS search suffixes.

The following table illustrates the DNS lookups performed for a hypothetical three-node Teradata Database system named "whomooz".

&nbsp; | No domain name qualification | With domain name qualification<br />(Recommended)
------ | ---------------------------- | ---
Application-specified<br />Teradata Database hostname | `whomooz` | `whomooz.domain.com`
Default: COP Discovery turned on, and `coplast` is `false` or omitted,<br />perform DNS lookups until unknown COP hostname is encountered | `whomoozcop1`&rarr;`10.0.0.1`<br />`whomoozcop2`&rarr;`10.0.0.2`<br />`whomoozcop3`&rarr;`10.0.0.3`<br />`whomoozcop4`&rarr;undefined | `whomoozcop1.domain.com`&rarr;`10.0.0.1`<br />`whomoozcop2.domain.com`&rarr;`10.0.0.2`<br />`whomoozcop3.domain.com`&rarr;`10.0.0.3`<br />`whomoozcop4.domain.com`&rarr;undefined
COP Discovery turned on, and `coplast` is `true`,<br />perform DNS lookups until COP hostname is found whose IP address matches the coplast hostname, or unknown COP hostname is encountered | `whomoozcoplast`&rarr;`10.0.0.3`<br />`whomoozcop1`&rarr;`10.0.0.1`<br />`whomoozcop2`&rarr;`10.0.0.2`<br />`whomoozcop3`&rarr;`10.0.0.3` | `whomoozcoplast.domain.com`&rarr;`10.0.0.3`<br />`whomoozcop1.domain.com`&rarr;`10.0.0.1`<br />`whomoozcop2.domain.com`&rarr;`10.0.0.2`<br />`whomoozcop3.domain.com`&rarr;`10.0.0.3`
COP Discovery turned off and round-robin DNS,<br />perform one DNS lookup that returns multiple IP addresses | `whomooz`&rarr;`10.0.0.1`, `10.0.0.2`, `10.0.0.3` | `whomooz.domain.com`&rarr;`10.0.0.1`, `10.0.0.2`, `10.0.0.3`

Round-robin DNS rotates the list of IP addresses automatically to provide load distribution. Round-robin is only possible with DNS, not with the client system `hosts` file.

The Teradata SQL Driver for R supports the definition of multiple IP addresses for COP hostnames and non-COP hostnames.

For the first connection to a particular Teradata Database system, the Teradata SQL Driver for R generates a random number to index into the list of COPs. For each subsequent connection, the Teradata SQL Driver for R increments the saved index until it wraps around to the first position. This behavior provides load distribution across all discovered COPs.

The Teradata SQL Driver for R masks connection failures to down COPs, thereby hiding most connection failures from the client application. An exception is thrown to the application only when all the COPs are down for that database. If a COP is down, the next COP in the sequence (including a wrap-around to the first COP) receives extra connections that were originally destined for the down COP. When multiple IP addresses are defined in DNS for a COP, the Teradata SQL Driver for R will attempt to connect to each of the COP's IP addresses, and the COP is considered down only when connection attempts fail to all of the COP's IP addresses.

If COP Discovery is turned off, or no COP hostnames are defined in DNS, the Teradata SQL Driver for R connects directly to the hostname specified in the `host` connection parameter. This permits load distribution schemes other than the COP Discovery approach. For example, round-robin DNS or a TCP/IP load distribution product can be used. COP Discovery takes precedence over simple database hostname lookup. To use an alternative load distribution scheme, either ensure that no COP hostnames are defined in DNS, or turn off COP Discovery with `cop` as `false`.

<a name="StoredPasswordProtection"></a>

### Stored Password Protection

#### Overview

Stored Password Protection enables an application to provide a connection password in encrypted form to the Teradata SQL Driver for R.

An encrypted password may be specified in the following contexts:
* A login password specified as the `password` connection parameter.
* A login password specified within the `logdata` connection parameter.

If the password, however specified, begins with the prefix `ENCRYPTED_PASSWORD(` then the specified password must follow this format:

`ENCRYPTED_PASSWORD(file:`*PasswordEncryptionKeyFileName*`,file:`*EncryptedPasswordFileName*`)`

Each filename must be preceded by the `file:` prefix. The *PasswordEncryptionKeyFileName* must be separated from the *EncryptedPasswordFileName* by a single comma.

The *PasswordEncryptionKeyFileName* specifies the name of a file that contains the password encryption key and associated information. The *EncryptedPasswordFileName* specifies the name of a file that contains the encrypted password and associated information. The two files are described below.

Stored Password Protection is offered by the Teradata JDBC Driver, the Teradata SQL Driver for Python, and the Teradata SQL Driver for R. These drivers use the same file format.

#### Program TJEncryptPassword

`TJEncryptPassword.R` is a sample program to create encrypted password files for use with Stored Password Protection. When the Teradata SQL Driver for R is installed, the sample programs are placed in the `teradatasql/samples` directory under your R library directory.

This program works in conjunction with Stored Password Protection offered by the Teradata JDBC Driver, the Teradata SQL Driver for Python, and the Teradata SQL Driver for R. This program creates the files containing the password encryption key and encrypted password, which can be subsequently specified via the `ENCRYPTED_PASSWORD(` syntax.

You are not required to use this program to create the files containing the password encryption key and encrypted password. You can develop your own software to create the necessary files. You may use the [`TJEncryptPassword.java`](https://downloads.teradata.com/doc/connectivity/jdbc/reference/current/samp/TJEncryptPassword.java.txt) sample program that is available with the [Teradata JDBC Driver Reference](https://downloads.teradata.com/doc/connectivity/jdbc/reference/current/frameset.html). You may also use the [`TJEncryptPassword.py`](https://github.com/Teradata/python-driver/blob/master/samples/TJEncryptPassword.py) sample program that is available with the Teradata SQL Driver for Python. The only requirement is that the files must match the format expected by the Teradata SQL Driver for R, which is documented below.

This program encrypts the password and then immediately decrypts the password, in order to verify that the password can be successfully decrypted. This program mimics the password decryption of the Teradata SQL Driver for R, and is intended to openly illustrate its operation and enable scrutiny by the community.

The encrypted password is only as safe as the two files. You are responsible for restricting access to the files containing the password encryption key and encrypted password. If an attacker obtains both files, the password can be decrypted. The operating system file permissions for the two files should be as limited and restrictive as possible, to ensure that only the intended operating system userid has access to the files.

The two files can be kept on separate physical volumes, to reduce the risk that both files might be lost at the same time. If either or both of the files are located on a network volume, then an encrypted wire protocol can be used to access the network volume, such as sshfs, encrypted NFSv4, or encrypted SMB 3.0.

This program accepts eight command-line arguments:

Argument                      | Example              | Description
----------------------------- | -------------------- | ---
Transformation                | `AES/CBC/NoPadding`  | Specifies the transformation in the form *Algorithm*`/`*Mode*`/`*Padding*. Supported transformations are listed in a table below.
KeySizeInBits                 | `256`                | Specifies the algorithm key size, which governs the encryption strength.
MAC                           | `HmacSHA256`         | Specifies the message authentication code (MAC) algorithm `HmacSHA1` or `HmacSHA256`.
PasswordEncryptionKeyFileName | `PassKey.properties` | Specifies a filename in the current directory, a relative pathname, or an absolute pathname. The file is created by this program. If the file already exists, it will be overwritten by the new file.
EncryptedPasswordFileName     | `EncPass.properties` | Specifies a filename in the current directory, a relative pathname, or an absolute pathname. The filename or pathname that must differ from the PasswordEncryptionKeyFileName. The file is created by this program. If the file already exists, it will be overwritten by the new file.
Hostname                      | `whomooz`            | Specifies the Teradata Database hostname.
Username                      | `guest`              | Specifies the Teradata Database username.
Password                      | `please`             | Specifies the Teradata Database password to be encrypted. Unicode characters in the password can be specified with the `\u`*XXXX* escape sequence.

#### Example Command

The TJEncryptPassword program uses the Teradata SQL Driver for R to log on to the specified Teradata Database using the encrypted password, so the Teradata SQL Driver for R must already be installed.

The following command assume that the `TJEncryptPassword.R` program file is located in the current directory. When the Teradata SQL Driver for R is installed, the sample programs are placed in the `teradatasql/samples` directory under your R library directory. Change your current directory to the `teradatasql/samples` directory under your R library directory.

The following example command illustrates using a 256-bit AES key, and using the HmacSHA256 algorithm.

    Rscript TJEncryptPassword.R AES/CBC/NoPadding 256 HmacSHA256 PassKey.properties EncPass.properties whomooz guest please

#### Password Encryption Key File Format

The password encryption key file is a text file in Java Properties file format, using the ISO 8859-1 character encoding.

The file must contain the following string properties:

Property                                          | Description
------------------------------------------------- | ---
`version=1`                                       | The version number must be `1`. This property is required.
`transformation=`*Algorithm*`/`*Mode*`/`*Padding* | Specifies the transformation in the form *Algorithm*`/`*Mode*`/`*Padding*. Supported transformations are listed in a table below. This property is required.
`algorithm=`*Algorithm*                           | This value must correspond to the *Algorithm* portion of the transformation. This property is required.
`match=`*MatchValue*                              | The password encryption key and encrypted password files must contain the same match value. The match values are compared to ensure that the two specified files are related to each other, serving as a "sanity check" to help avoid configuration errors. This property is required.
`key=`*HexDigits*                                 | This value is the password encryption key, encoded as hex digits. This property is required.
`mac=`*MACAlgorithm*                              | Specifies the message authentication code (MAC) algorithm `HmacSHA1` or `HmacSHA256`. Stored Password Protection performs Encrypt-then-MAC for protection from a padding oracle attack. This property is required.
`mackey=`*HexDigits*                              | This value is the MAC key, encoded as hex digits. This property is required.

The TJEncryptPassword program uses a timestamp as a shared match value, but a timestamp is not required. Any shared string can serve as a match value. The timestamp is not related in any way to the encryption of the password, and the timestamp cannot be used to decrypt the password.

#### Encrypted Password File Format

The encrypted password file is a text file in Java Properties file format, using the ISO 8859-1 character encoding.

The file must contain the following string properties:

Property                                          | Description
------------------------------------------------- | ---
`version=1`                                       | The version number must be `1`. This property is required.
`match=`*MatchValue*                              | The password encryption key and encrypted password files must contain the same match value. The match values are compared to ensure that the two specified files are related to each other, serving as a "sanity check" to help avoid configuration errors. This property is required.
`password=`*HexDigits*                            | This value is the encrypted password, encoded as hex digits. This property is required.
`params=`*HexDigits*                              | This value contains the cipher algorithm parameters, if any, encoded as hex digits. Some ciphers need algorithm parameters that cannot be derived from the key, such as an initialization vector. This property is optional, depending on whether the cipher algorithm has associated parameters.
`hash=`*HexDigits*                                | This value is the expected message authentication code (MAC), encoded as hex digits. After encryption, the expected MAC is calculated using the ciphertext, transformation name, and algorithm parameters if any. Before decryption, the Teradata SQL Driver for R calculates the MAC using the ciphertext, transformation name, and algorithm parameters if any, and verifies that the calculated MAC matches the expected MAC. If the calculated MAC differs from the expected MAC, then either or both of the files may have been tampered with. This property is required.

While `params` is technically optional, an initialization vector is required by all three block cipher modes `CBC`, `CFB`, and `OFB` that are supported by the Teradata SQL Driver for R. ECB (Electronic Codebook) does not require `params`, but ECB is not supported by the Teradata SQL Driver for R.

#### Transformation, Key Size, and MAC

A transformation is a string that describes the set of operations to be performed on the given input, to produce transformed output. A transformation specifies the name of a cryptographic algorithm such as DES or AES, followed by a feedback mode and padding scheme.

The Teradata SQL Driver for R supports the following transformations and key sizes.
However, `TJEncryptPassword.R` only supports AES with CBC or CFB, as indicated below.

Transformation              | Key Size | TJEncryptPassword.R
--------------------------- | -------- | ---
`DES/CBC/NoPadding`         | 64       |
`DES/CBC/PKCS5Padding`      | 64       |
`DES/CFB/NoPadding`         | 64       |
`DES/CFB/PKCS5Padding`      | 64       |
`DES/OFB/NoPadding`         | 64       |
`DES/OFB/PKCS5Padding`      | 64       |
`DESede/CBC/NoPadding`      | 192      |
`DESede/CBC/PKCS5Padding`   | 192      |
`DESede/CFB/NoPadding`      | 192      |
`DESede/CFB/PKCS5Padding`   | 192      |
`DESede/OFB/NoPadding`      | 192      |
`DESede/OFB/PKCS5Padding`   | 192      |
`AES/CBC/NoPadding`         | 128      | Yes
`AES/CBC/NoPadding`         | 192      | Yes
`AES/CBC/NoPadding`         | 256      | Yes
`AES/CBC/PKCS5Padding`      | 128      | Yes
`AES/CBC/PKCS5Padding`      | 192      | Yes
`AES/CBC/PKCS5Padding`      | 256      | Yes
`AES/CFB/NoPadding`         | 128      | Yes
`AES/CFB/NoPadding`         | 192      | Yes
`AES/CFB/NoPadding`         | 256      | Yes
`AES/CFB/PKCS5Padding`      | 128      | Yes
`AES/CFB/PKCS5Padding`      | 192      | Yes
`AES/CFB/PKCS5Padding`      | 256      | Yes
`AES/OFB/NoPadding`         | 128      |
`AES/OFB/NoPadding`         | 192      |
`AES/OFB/NoPadding`         | 256      |
`AES/OFB/PKCS5Padding`      | 128      |
`AES/OFB/PKCS5Padding`      | 192      |
`AES/OFB/PKCS5Padding`      | 256      |

Stored Password Protection uses a symmetric encryption algorithm such as DES or AES, in which the same secret key is used for encryption and decryption of the password. Stored Password Protection does not use an asymmetric encryption algorithm such as RSA, with separate public and private keys.

CBC (Cipher Block Chaining) is a block cipher encryption mode. With CBC, each ciphertext block is dependent on all plaintext blocks processed up to that point. CBC is suitable for encrypting data whose total byte count exceeds the algorithm's block size, and is therefore suitable for use with Stored Password Protection.

Stored Password Protection hides the password length in the encrypted password file by extending the length of the UTF8-encoded password with trailing null bytes. The length is extended to the next 512-byte boundary.

* A block cipher with no padding, such as `AES/CBC/NoPadding`, may only be used to encrypt data whose byte count after extension is a multiple of the algorithm's block size. The 512-byte boundary is compatible with many block ciphers. AES, for example, has a block size of 128 bits (16 bytes), and is therefore compatible with the 512-byte boundary.
* A block cipher with padding, such as `AES/CBC/PKCS5Padding`, can be used to encrypt data of any length. However, CBC with padding is vulnerable to a "padding oracle attack", so Stored Password Protection performs Encrypt-then-MAC for protection from a padding oracle attack. MAC algorithms `HmacSHA1` and `HmacSHA256` are supported.
* The Teradata SQL Driver for R does not support block ciphers used as byte-oriented ciphers via modes such as `CFB8` or `OFB8`.

The strength of the encryption depends on your choice of cipher algorithm and key size.

* AES uses a 128-bit (16 byte), 192-bit (24 byte), or 256-bit (32 byte) key.
* DESede uses a 192-bit (24 byte) key. The The Teradata SQL Driver for R does not support a 128-bit (16 byte) key for DESede.
* DES uses a 64-bit (8 byte) key.

#### Sharing Files with the Teradata JDBC Driver

The Teradata SQL Driver for R and the Teradata JDBC Driver can share the files containing the password encryption key and encrypted password, if you use a transformation, key size, and MAC algorithm that is supported by both drivers.

* Recommended choices for compatibility are `AES/CBC/NoPadding` and `HmacSHA256`.
* Use a 256-bit key if your Java environment has the Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files from Oracle.
* Use a 128-bit key if your Java environment does not have the Unlimited Strength Jurisdiction Policy Files.
* Use `HmacSHA1` for compatibility with JDK 1.4.2.

#### File Locations

For the `ENCRYPTED_PASSWORD(` syntax of the Teradata SQL Driver for R, each filename must be preceded by the `file:` prefix.
The *PasswordEncryptionKeyFileName* must be separated from the *EncryptedPasswordFileName* by a single comma. The files can be located in the current directory, specified with a relative path, or specified with an absolute path.


Example for files in the current directory:

    ENCRYPTED_PASSWORD(file:JohnDoeKey.properties,file:JohnDoePass.properties)

Example with relative paths:

    ENCRYPTED_PASSWORD(file:../dir1/JohnDoeKey.properties,file:../dir2/JohnDoePass.properties)

Example with absolute paths on Windows:

    ENCRYPTED_PASSWORD(file:c:/dir1/JohnDoeKey.properties,file:c:/dir2/JohnDoePass.properties)

Example with absolute paths on Linux:

    ENCRYPTED_PASSWORD(file:/dir1/JohnDoeKey.properties,file:/dir2/JohnDoePass.properties)

#### Processing Sequence

The two filenames specified for an encrypted password must be accessible to the Teradata SQL Driver for R and must conform to the properties file formats described above. The Teradata SQL Driver for R signals an error if the file is not accessible, or the file does not conform to the required file format.

The Teradata SQL Driver for R verifies that the match values in the two files are present, and match each other. The Teradata SQL Driver for R signals an error if the match values differ from each other. The match values are compared to ensure that the two specified files are related to each other, serving as a "sanity check" to help avoid configuration errors. The TJEncryptPassword program uses a timestamp as a shared match value, but a timestamp is not required. Any shared string can serve as a match value. The timestamp is not related in any way to the encryption of the password, and the timestamp cannot be used to decrypt the password.

Before decryption, the Teradata SQL Driver for R calculates the MAC using the ciphertext, transformation name, and algorithm parameters if any, and verifies that the calculated MAC matches the expected MAC. The Teradata SQL Driver for R signals an error if the calculated MAC differs from the expected MAC, to indicate that either or both of the files may have been tampered with.

Finally, the Teradata SQL Driver for R uses the decrypted password to log on to the Teradata Database.

<a name="TransactionMode"></a>

### Transaction Mode

The `tmode` connection parameter enables an application to specify the transaction mode for the connection.
* `"tmode":"ANSI"` provides American National Standards Institute (ANSI) transaction semantics. This mode is recommended.
* `"tmode":"TERA"` provides legacy Teradata transaction semantics. This mode is only recommended for legacy applications that require Teradata transaction semantics.
* `"tmode":"DEFAULT"` provides the default transaction mode configured for the Teradata Database, which may be either ANSI or TERA mode. `"tmode":"DEFAULT"` is the default when the `tmode` connection parameter is omitted.

While ANSI mode is generally recommended, please note that every application is different, and some applications may need to use TERA mode. The following differences between ANSI and TERA mode might affect a typical user or application:
1. Silent truncation of inserted data occurs in TERA mode, but not ANSI mode. In ANSI mode, the Teradata Database returns an error instead of truncating data.
2. Tables created in ANSI mode are `MULTISET` by default. Tables created in TERA mode are `SET` tables by default.
3. For tables created in ANSI mode, character columns are `CASESPECIFIC` by default. For tables created in TERA mode, character columns are `NOT CASESPECIFIC` by default.
4. In ANSI mode, character literals are `CASESPECIFIC`. In TERA mode, character literals are `NOT CASESPECIFIC`.

The last two behavior differences, taken together, may cause character data comparisons (such as in `WHERE` clause conditions) to be case-insensitive in TERA mode, but case-sensitive in ANSI mode. This, in turn, can produce different query results in ANSI mode versus TERA mode. Comparing two `NOT CASESPECIFIC` expressions is case-insensitive regardless of mode, and comparing a `CASESPECIFIC` expression to another expression of any kind is case-sensitive regardless of mode. You may explicitly `CAST` an expression to be `CASESPECIFIC` or `NOT CASESPECIFIC` to obtain the character data comparison required by your application.

The Teradata Database Reference / *SQL Request and Transaction Processing* recommends that ANSI mode be used for all new applications. The primary benefit of using ANSI mode is that inadvertent data truncation is avoided. In contrast, when using TERA mode, silent data truncation can occur when data is inserted, because silent data truncation is a feature of TERA mode.

A drawback of using ANSI mode is that you can only call stored procedures that were created using ANSI mode, and you cannot call stored procedures that were created using TERA mode. It may not be possible to switch over to ANSI mode exclusively, because you may have some legacy applications that require TERA mode to work properly. You can work around this drawback by creating your stored procedures twice, in two different users/databases, once using ANSI mode, and once using TERA mode.

Refer to the Teradata Database Reference / *SQL Request and Transaction Processing* for complete information regarding the differences between ANSI and TERA transaction modes.

<a name="AutoCommit"></a>

### Auto-Commit

The Teradata SQL Driver for R provides auto-commit on and off functionality for both ANSI and TERA mode.

When a connection is first established, it begins with the default auto-commit setting, which is on. When auto-commit is on, the driver is solely responsible for managing transactions, and the driver commits each SQL request that is successfully executed. An application should not execute any transaction management SQL commands when auto-commit is on. An application should not call the `dbCommit` method or the `dbRollback` method when auto-commit is on.

An application can manage transactions itself by calling the `dbBegin` method to turn off auto-commit.

    DBI::dbBegin(con)

When auto-commit is off, the driver leaves the current transaction open after each SQL request is executed, and the application is responsible for committing or rolling back the transaction by calling the `dbCommit` or the `dbRollback` method, respectively.

Auto-commit remains turned off until the application calls `dbCommit` or  `dbRollback`. Auto-commit is turned back on when the application calls `dbCommit` or  `dbRollback`.

Best practices recommend that an application avoid executing database-vendor-specific transaction management commands such as `BT`, `ET`, `ABORT`, `COMMIT`, or `ROLLBACK`, because such commands differ from one vendor to another. (They even differ between Teradata's two modes ANSI and TERA.) Instead, best practices recommend that an application only call the standard methods `dbCommit` and `dbRollback` for transaction management.
1. When auto-commit is on in ANSI mode, the driver automatically executes `COMMIT` after every successful SQL request.
2. When auto-commit is off in ANSI mode, the driver does not automatically execute `COMMIT`. When the application calls the `dbCommit` method, then the driver executes `COMMIT`.
3. When auto-commit is on in TERA mode, the driver does not execute `BT` or `ET`, unless the application explicitly executes `BT` or `ET` commands itself, which is not recommended.
4. When auto-commit is off in TERA mode, the driver executes `BT` before submitting the application's first SQL request of a new transaction. When the application calls the `dbCommit` method, then the driver executes `ET` until the transaction is complete.

As part of the wire protocol between the Teradata Database and Teradata client interface software (such as the Teradata SQL Driver for R), each message transmitted from the Teradata Database to the client has a bit designated to indicate whether the session has a transaction in progress or not. Thus, the client interface software is kept informed as to whether the session has a transaction in progress or not.

In TERA mode with auto-commit off, when the application uses the driver to execute a SQL request, if the session does not have a transaction in progress, then the driver automatically executes `BT` before executing the application's SQL request. Subsequently, in TERA mode with auto-commit off, when the application uses the driver to execute another SQL request, and the session already has a transaction in progress, then the driver has no need to execute `BT` before executing the application's SQL request.

In TERA mode, `BT` and `ET` pairs can be nested, and the Teradata Database keeps track of the nesting level. The outermost `BT`/`ET` pair defines the transaction scope; inner `BT`/`ET` pairs have no effect on the transaction because the Teradata Database does not provide actual transaction nesting. To commit the transaction, `ET` commands must be repeatedly executed until the nesting is unwound. The Teradata wire protocol bit (mentioned earlier) indicates when the nesting is unwound and the transaction is complete. When the application calls the `dbCommit` method in TERA mode, the driver repeatedly executes `ET` commands until the nesting is unwound and the transaction is complete.

In rare cases, an application may not follow best practices and may explicitly execute transaction management commands. Such an application must turn off auto-commit before executing transaction management commands such as `BT`, `ET`, `ABORT`, `COMMIT`, or `ROLLBACK`. The application is responsible for executing the appropriate commands for the transaction mode in effect. TERA mode commands are `BT`, `ET`, and `ABORT`. ANSI mode commands are `COMMIT` and `ROLLBACK`. An application must take special care when opening a transaction in TERA mode with auto-commit off. In TERA mode with auto-commit off, when the application executes a SQL request, if the session does not have a transaction in progress, then the driver automatically executes `BT` before executing the application's SQL request. Therefore, the application should not begin a transaction by executing `BT`.

    # TERA mode example showing undesirable BT/ET nesting
    DBI::dbBegin(con)
    DBI::dbExecute(con, "BT") # BT automatically executed by the driver before this, and produces a nested BT
    DBI::dbExecute(con, "insert into mytable1 values(1, 2)")
    DBI::dbExecute(con, "insert into mytable2 values(3, 4)")
    DBI::dbExecute(con, "ET") # unwind nesting
    DBI::dbExecute(con, "ET") # complete transaction

    # TERA mode example showing how to avoid BT/ET nesting
    DBI::dbBegin(con)
    DBI::dbExecute(con, "insert into mytable1 values(1, 2)") # BT automatically executed by the driver before this
    DBI::dbExecute(con, "insert into mytable2 values(3, 4)")
    DBI::dbExecute(con, "ET") # complete transaction

Please note that neither previous example shows best practices. Best practices recommend that an application only call the standard methods `dbCommit` and `dbRollback` for transaction management.

    # Example showing best practice
    DBI::dbBegin(con)
    DBI::dbExecute(con, "insert into mytable1 values(1, 2)")
    DBI::dbExecute(con, "insert into mytable2 values(3, 4)")
    DBI::dbCommit(con)

<a name="DataTypes"></a>

### Data Types

The table below lists the Teradata Database data types supported by the Teradata SQL Driver for R, and indicates the corresponding R data type returned in result set rows. Note that `teradata_values` as `false` takes precedence over `posixlt` as `true`.

Teradata Database data type        | Result set R data type | With `posixlt` as `true`             | With `teradata_values` as `false`
---------------------------------- | ---------------------- | ------------------------------------ | ---
`BIGINT`                           | `bit64::integer64`     |                                      |
`BLOB`                             | `raw`                  |                                      |
`BYTE`                             | `raw`                  |                                      |
`BYTEINT`                          | `raw`                  |                                      |
`CHAR`                             | `character`            |                                      |
`CLOB`                             | `character`            |                                      |
`DATE`                             | `Date`                 |                                      | `character`
`DECIMAL`                          | `double`               |                                      | `character`
`FLOAT`                            | `double`               |                                      |
`INTEGER`                          | `integer`              |                                      |
`INTERVAL YEAR`                    | `character`            |                                      |
`INTERVAL YEAR TO MONTH`           | `character`            |                                      |
`INTERVAL MONTH`                   | `character`            |                                      |
`INTERVAL DAY`                     | `character`            |                                      |
`INTERVAL DAY TO HOUR`             | `character`            |                                      |
`INTERVAL DAY TO MINUTE`           | `character`            |                                      |
`INTERVAL DAY TO SECOND`           | `character`            |                                      |
`INTERVAL HOUR`                    | `character`            |                                      |
`INTERVAL HOUR TO MINUTE`          | `character`            |                                      |
`INTERVAL HOUR TO SECOND`          | `character`            |                                      |
`INTERVAL MINUTE`                  | `character`            |                                      |
`INTERVAL MINUTE TO SECOND`        | `character`            |                                      |
`INTERVAL SECOND`                  | `character`            |                                      |
`NUMBER`                           | `double`               |                                      | `character`
`PERIOD(DATE)`                     | `character`            |                                      |
`PERIOD(TIME)`                     | `character`            |                                      |
`PERIOD(TIME WITH TIME ZONE)`      | `character`            |                                      |
`PERIOD(TIMESTAMP)`                | `character`            |                                      |
`PERIOD(TIMESTAMP WITH TIME ZONE)` | `character`            |                                      |
`SMALLINT`                         | `integer`              |                                      |
`TIME`                             | `hms::hms`             |                                      | `character`
`TIME WITH TIME ZONE`              | `character`            | `teradatasql::TimeWithTimeZone`      | `character`
`TIMESTAMP`                        | `POSIXct`              | `teradatasql::Timestamp`             | `character`
`TIMESTAMP WITH TIME ZONE`         | `character`            | `teradatasql::TimestampWithTimeZone` | `character`
`VARBYTE`                          | `raw`                  |                                      |
`VARCHAR`                          | `character`            |                                      |
`XML`                              | `character`            |                                      |

The table below lists the parameterized SQL bind-value R data types supported by the Teradata SQL Driver for R, and indicates the corresponding Teradata Database data type transmitted to the server.

Bind-value R data type               | Teradata Database data type
------------------------------------ | ---
`bit64::integer64`                   | `BIGINT`
`character`                          | `VARCHAR`
`Date`                               | `DATE`
`difftime`                           | `VARCHAR` format compatible with `INTERVAL DAY TO SECOND`
`double`                             | `FLOAT`
`integer`                            | `INTEGER`
`hms::hms`                           | `TIME`
`POSIXct`                            | `TIMESTAMP`
`POSIXlt` without `$gmtoff`          | `TIMESTAMP`
`POSIXlt` with `$gmtoff`             | `TIMESTAMP WITH TIME ZONE`
`raw`                                | `VARBYTE`
`teradatasql::TimeWithTimeZone`      | `TIME WITH TIME ZONE`
`teradatasql::Timestamp`             | `TIMESTAMP`
`teradatasql::TimestampWithTimeZone` | `TIMESTAMP WITH TIME ZONE`

The `tzone` attribute of `POSIXct` and `POSIXlt` is ignored. The `$gmtoff` vector of `POSIXlt` holds the time zone portion of `TIME WITH TIME ZONE` and `TIMESTAMP WITH TIME ZONE` values.

Transforms are used for SQL `ARRAY` data values, and they can be transferred to and from the database as `VARCHAR` values.

Transforms are used for structured UDT data values, and they can be transferred to and from the database as `VARCHAR` values.

<a name="NullValues"></a>

### Null Values

SQL `NULL` values received from the Teradata Database are returned in result set rows as R `NA` values.

An R `NA` value bound to a question-mark parameter marker is transmitted to the Teradata Database as a `NULL` `VARCHAR` value.

<a name="CharacterExportWidth"></a>

### Character Export Width

The Teradata SQL Driver for R always uses the UTF8 session character set, and the `charset` connection parameter is not supported. Be aware of the Teradata Database's _Character Export Width_ behavior that adds trailing space padding to fixed-width `CHAR` data type result set column values when using the UTF8 session character set.

The Teradata Database `CHAR(`_n_`)` data type is a fixed-width data type (holding _n_ characters), and the Teradata Database reserves a fixed number of bytes for the `CHAR(`_n_`)` data type in response spools and in network message traffic.

UTF8 is a variable-width character encoding scheme that requires a varying number of bytes for each character. When the UTF8 session character set is used, the Teradata Database reserves the maximum number of bytes that the `CHAR(`_n_`)` data type could occupy in response spools and in network message traffic. When the UTF8 session character set is used, the Teradata Database appends padding characters to the tail end of `CHAR(`_n_`)` values smaller than the reserved maximum size, so that the `CHAR(`_n_`)` values all occupy the same fixed number of bytes in response spools and in network message traffic.

Work around this drawback by using `CAST` or `TRIM` in SQL `SELECT` statements, or in views, to convert fixed-width `CHAR` data types to `VARCHAR`.

Given a table with fixed-width `CHAR` columns:

`CREATE TABLE MyTable (c1 CHAR(10), c2 CHAR(10))`

Original query that produces trailing space padding:

`SELECT c1, c2 FROM MyTable`

Modified query with either `CAST` or `TRIM` to avoid trailing space padding:

`SELECT CAST(c1 AS VARCHAR(10)), TRIM(TRAILING FROM c1) FROM MyTable`

Or wrap query in a view with `CAST` or `TRIM` to avoid trailing space padding:

`CREATE VIEW MyView (c1, c2) AS SELECT CAST(c1 AS VARCHAR(10)), TRIM(TRAILING FROM c2) FROM MyTable`

`SELECT c1, c2 FROM MyView`

This technique is also demonstrated in sample program `charpadding.R`.

<a name="Constructors"></a>

### Constructors

`teradatasql::TeradataDriver()`

Creates an instance of the Teradata SQL Driver for R to be specified as the first argument to `DBI::dbConnect`.

---

`teradatasql::TimeWithTimeZone(` *CharacterVector* `)`

Creates and returns a `TimeWithTimeZone` value subclass of `POSIXlt`. The `$gmtoff` vector of `POSIXlt` holds the time zone portion. The *CharacterVector* must contain string values in the Teradata Database `TIME WITH TIME ZONE` format.

* `HH:MM:SS+MM:SS` The time zone suffix specifies positive or negative offset from GMT
* `HH:MM:SS-MM:SS`
* `HH:MM:SS.SSSSSS+MM:SS` Optional 1 to 6 digits of fractional seconds
* `HH:MM:SS.SSSSSS-MM:SS`

---

`teradatasql::Timestamp(` *CharacterVector* `)`

Creates and returns a `Timestamp` value subclass of `POSIXlt`. The *CharacterVector* must contain string values in the Teradata Database `TIMESTAMP` format.

* `YYYY-MM-DD HH:MM:SS`
* `YYYY-MM-DD HH:MM:SS.SSSSSS` Optional 1 to 6 digits of fractional seconds

---

`teradatasql::TimestampWithTimeZone(` *CharacterVector* `)`

Creates and returns a `TimestampWithTimeZone` value subclass of `POSIXlt`. The `$gmtoff` vector of `POSIXlt` holds the time zone portion. The *CharacterVector* must contain string values in the Teradata Database `TIMESTAMP WITH TIME ZONE` format.

* `YYYY-MM-DD HH:MM:SS+MM:SS` The time zone suffix specifies positive or negative offset from GMT
* `YYYY-MM-DD HH:MM:SS-MM:SS`
* `YYYY-MM-DD HH:MM:SS.SSSSSS+MM:SS` Optional 1 to 6 digits of fractional seconds
* `YYYY-MM-DD HH:MM:SS.SSSSSS-MM:SS`

<a name="DriverMethods"></a>

### Driver Methods

`DBI::dbCanConnect(teradatasql::TeradataDriver(),` *JSONConnectionString* `)`

Returns `TRUE` or `FALSE` to indicate whether a connection to the database can be created. Specify connection parameters as a JSON string.

---

`DBI::dbConnect(teradatasql::TeradataDriver(),` *JSONConnectionString* `)`

Creates a connection to the database and returns a Connection object.

The first parameter is an instance of `teradatasql::TeradataDriver`. The second parameter is an optional JSON string that defaults to `NA`. The third and subsequent arguments are optional named arguments. Specify connection parameters as a JSON string, as named arguments, or a combination of the two.

When a combination of parameters are specified, connection parameters specified as named arguments take precedence over same-named connection parameters specified in the JSON string.

---

`DBI::dbDataType(teradatasql::TeradataDriver(),` *obj* `)`

Returns a string giving the SQL type name for *obj*.

---

`DBI::dbGetInfo(teradatasql::TeradataDriver())`

Returns a list with names `driver.version` and `client.version`.

---

`DBI::dbIsReadOnly(teradatasql::TeradataDriver())`

Returns `FALSE`.

---

`DBI::dbIsValid(teradatasql::TeradataDriver())`

Returns `TRUE`.

<a name="ConnectionMethods"></a>

### Connection Methods

`DBI::dbAppendTable(` *conn* `,` *name* `,` *value* `)`

Inserts rows contained in `data.frame` *value* into an existing table with *name*.
The `data.frame` column names must match the destination table column names.

---

`DBI::dbBegin(` *conn* `)`

Begins a transaction by turning off auto-commit.

---

`DBI::dbCommit(` *conn* `)`

Commits the current transaction and turns on auto-commit.

---

`DBI::dbCreateTable(` *conn* `,` *name* `,` *fields* `, temporary = FALSE)`

Creates a table with *name*.

If *fields* is a `data.frame`, column names and column types are derived from the `data.frame`.
If *fields* is a named `character` vector, the names specify column names, and the values specify column types.

If `temporary` is `FALSE` (the default), a permanent table is created.
If `temporary` is `TRUE`, a volatile table is created.

---

`DBI::dbDataType(` *conn* `,` *obj* `)`

Returns a string giving the SQL type name for *obj*.

---

`DBI::dbDisconnect(` *conn* `)`

Closes the connection.

---

`DBI::dbExecute(` *conn* `,` *statement* `, params = NULL)`

Executes the SQL request *statement* and returns the number of rows affected by the statement.

Parameterized SQL bind values can be specified as a `list` or `data.frame` for *params*.
Parameter values are bound to question-mark parameter markers in column order, not by name.
Single row or multiple row *params* may be specified.

---

`DBI::dbExistsTable(` *conn* `,` *name* `)`

Returns `TRUE` if a table with *name* exists. Returns `FALSE` otherwise.

---

`DBI::dbGetInfo(` *conn* `)`

Returns a list with names `db.version`, `dbname`, `username`, `host`, and `port`.

---

`DBI::dbGetQuery(` *conn* `,` *statement* `, params = NULL)`

Executes the SQL query *statement* and returns a `data.frame` containing the result set.

Parameterized SQL bind values can be specified as a `list` or `data.frame` for *params*.
Parameter values are bound to question-mark parameter markers in column order, not by name.

---

`DBI::dbIsReadOnly(` *conn* `)`

Returns `FALSE`.

---

`DBI::dbIsValid(` *conn* `)`

Returns `TRUE` if the connection is usable.
Returns `FALSE` otherwise.

---

`DBI::dbListFields(` *conn* `,` *name* `)`

Returns a `character` vector containing the column names of the table with *name*.

---

`DBI::dbListObjects(` *conn* `, prefix = NULL)`

Returns a `data.frame` containing column 1 `table` with data type `list` of `DBI::Id`, and column 2 `is_prefix` with data type `logical`.

Returns the list of databases in the system when `prefix` is `NULL`. Column 2 `is_prefix` will be all `TRUE` in this case.

Returns the list of tables in the specified database when `prefix` is a string or a `DBI:Id` with a `schema` component. Column 2 `is_prefix` will be all `FALSE` in this case.

Only returns information about databases, permanent tables, and views. Does not return any information about volatile tables or global temporary tables.

---

`DBI::dbListTables(` *conn* `)`

Returns a `character` vector containing the names of the tables and views in the current database.

---

`DBI::dbQuoteIdentifier(` *conn* `,` *x* `)`

Returns *x* quoted and escaped as a SQL identifier: the value is enclosed in double-quote characters ( `"` ) and any embedded double-quote characters are doubled.

---

`DBI::dbQuoteString(` *conn* `,` *x* `)`

Returns *x* quoted and escaped as a SQL character literal: the value is enclosed in single-quote characters ( `'` ) and any embedded single-quote characters are doubled.

---

`DBI::dbReadTable(` *conn* `,` *name* `)`

Returns a `data.frame` containing all the rows from the table with *name*.

---

`DBI::dbRemoveTable(` *conn* `,` *name* `, fail_if_missing = TRUE)`

Drops the table with *name*.

If `fail_if_missing` is `TRUE` (the default), stops with an error when the specified table does not exist.
If `fail_if_missing` is `FALSE`, ignores a missing table.

---

`DBI::dbRollback(` *conn* `)`

Rolls back the current transaction and turns on auto-commit.

---

`DBI::dbSendQuery(` *conn* `,` *statement* `, params = NULL, immediate = NA)`

Prepares or executes the SQL query *statement* and returns a `DBI::DBIResult`.

Parameterized SQL bind values can be specified as a `list` or `data.frame` for *params*.
Parameter values are bound to question-mark parameter markers in column order, not by name.
Single row or multiple row *params* may be specified.

* When bound parameter values are specified with *params*, the `immediate` argument is ignored, and the SQL request is executed immediately.

* When no bound parameter values are specified, and `immediate = NA` is specified (the default), then the behavior is controlled by the `immediate` connection parameter. When connection parameter `immediate` is `true` (the default), then the SQL request is executed immediately. When connection parameter `immediate` is `false`, then the SQL request is prepared but not executed.

* When no bound parameter values are specified, and `immediate = TRUE` is specified, then the SQL request is executed immediately.

* When no bound parameter values are specified, and `immediate = FALSE` is specified, then the SQL request is prepared but not executed.

---

`DBI::dbSendStatement(` *conn* `,` *statement* `, params = NULL, immediate = NA)`

Prepares or executes the SQL request *statement* and returns a `DBI::DBIResult`.

Parameterized SQL bind values can be specified as a `list` or `data.frame` for *params*.
Parameter values are bound to question-mark parameter markers in column order, not by name.
Single row or multiple row *params* may be specified.

* When bound parameter values are specified with *params*, the `immediate` argument is ignored, and the SQL request is executed immediately.

* When no bound parameter values are specified, and `immediate = NA` is specified (the default), then the behavior is governed by the `immediate` connection parameter. When connection parameter `immediate` is `true` (the default), then the SQL request is executed immediately. When connection parameter `immediate` is `false`, then the SQL request is prepared but not executed.

* When no bound parameter values are specified, and `immediate = TRUE` is specified, then the SQL request is executed immediately.

* When no bound parameter values are specified, and `immediate = FALSE` is specified, then the SQL request is prepared but not executed.

---

`DBI::dbWithTransaction(` *conn* `,` *code* `)`

Not implemented yet.

---

`DBI::dbWriteTable(` *conn* `,` *name* `,` *value* `, row.names = FALSE, overwrite = FALSE, append = FALSE, field.types = NULL, temporary = FALSE)`

Creates, replaces, or uses a table with *name* and inserts into the table the rows contained in the `list` or `data.frame` *value*.

If `row.names` is `NULL` or `FALSE` (the default), row names are ignored.
If `row.names` is `TRUE`, custom or natural row names are inserted into a column named `row_names`.
If `row.names` is `NA`, custom row names are inserted into a column named `row_names`, but natural row names are ignored.
If `row.names` is a string, then it specifies the name of the column that custom or natural row names are inserted into.

If `overwrite` is `TRUE`, replaces an existing table with *name*.
If `append` is `TRUE`, creates table with *name* if it does not exist.
Stops with an error if both `overwrite` and `append` are `TRUE`, because they are mutually exclusive.
Stops with an error if both `overwrite` and `append` are `FALSE` (the default) and the table does not exist.

To override the column names or column types derived from *value*, specify `field.types` as a named `character` vector whose names specify column names, and values specify column types.

If `temporary` is `FALSE` (the default), a permanent table is created.
If `temporary` is `TRUE`, a volatile table is created.

<a name="ResultMethods"></a>

### Result Methods

`DBI::dbBind(` *res* `,` *params* `)`

Binds values to parameter markers and executes the prepared SQL request.

Parameterized SQL bind values are specified as a `list` or `data.frame` for *params*.
Parameter values are bound to question-mark parameter markers in column order, not by name.
Single row or multiple row *params* may be specified.

---

`DBI::dbClearResult(` *res* `)`

Closes the result.

---

`DBI::dbColumnInfo(` *res* `)`

Returns a `data.frame` containing result column metadata, in which each row describes one result column.
The returned `data.frame` has columns `name` (type `character`), `Sclass` (R data type), `type` (type `character`), `len` (type `integer`), `precision` (type `integer`), `scale` (type `integer`), and `nullOK` (type `logical`).

---

`DBI::dbFetch(` *dbFetch* `, n = -1)`

Fetches rows from the result after the SQL request is executed.

Fetches all remaining rows when `n` is `Inf` or `-1` (the default).
Fetches *n* rows at most when *n* is a non-negative whole number.
Stops with an error when *n* is something other than `Inf`, `-1`, or a non-negative whole number.

---

`DBI::dbGetInfo(` *res* `)`

Returns a list with names `statement`, `row.count`, `rows.affected`, and `has.completed`.

---

`DBI::dbGetRowCount(` *res* `)`

Returns the number of rows fetched so far from the result.

---

`DBI::dbGetRowsAffected(` *res* `)`

Returns the number of rows affected by the SQL statement.

---

`DBI::dbGetStatement(` *res* `)`

Returns the SQL request text.

---

`DBI::dbHasCompleted(` *res* `)`

Returns `TRUE` if all rows have been fetched from the result.
Returns `FALSE` otherwise.

---

`DBI::dbIsReadOnly(` *res* `)`

Returns `FALSE`.

---

`DBI::dbIsValid(` *res* `)`

Returns `TRUE` to indicate that the result is usable.
Returns `FALSE` otherwise.

---

`teradatasql::dbNextResult(` *res* `)`

Advances to the next result returned by a multi-statement request.

Returns `TRUE` to indicate that the next result is available.
Returns `FALSE` otherwise.

<a name="EscapeSyntax"></a>

### Escape Syntax

The Teradata SQL Driver for R accepts most of the JDBC escape clauses offered by the Teradata JDBC Driver.

#### Date and Time Literals

Date and time literal escape clauses are replaced by the corresponding SQL literal before the SQL request text is transmitted to the database.

Literal Type | Format
------------ | ------
Date         | `{d '`*yyyy-mm-dd*`'}`
Time         | `{t '`*hh:mm:ss*`'}`
Timestamp    | `{ts '`*yyyy-mm-dd hh:mm:ss*`'}`
Timestamp    | `{ts '`*yyyy-mm-dd hh:mm:ss.f*`'}`

For timestamp literal escape clauses, the decimal point and fractional digits may be omitted, or 1 to 6 fractional digits *f* may be specified after a decimal point.

#### Scalar Functions

Scalar function escape clauses are replaced by the corresponding SQL expression before the SQL request text is transmitted to the database.

Numeric Function                       | Returns
-------------------------------------- | ---
`{fn ABS(`*number*`)}`                 | Absolute value of *number*
`{fn ACOS(`*float*`)}`                 | Arccosine, in radians, of *float*
`{fn ASIN(`*float*`)}`                 | Arcsine, in radians, of *float*
`{fn ATAN(`*float*`)}`                 | Arctangent, in radians, of *float*
`{fn ATAN2(`*y*`,`*x*`)}`              | Arctangent, in radians, of *y* / *x*
`{fn CEILING(`*number*`)}`             | Smallest integer greater than or equal to *number*
`{fn COS(`*float*`)}`                  | Cosine of *float* radians
`{fn COT(`*float*`)}`                  | Cotangent of *float* radians
`{fn DEGREES(`*number*`)}`             | Degrees in *number* radians
`{fn EXP(`*float*`)}`                  | *e* raised to the power of *float*
`{fn FLOOR(`*number*`)}`               | Largest integer less than or equal to *number*
`{fn LOG(`*float*`)}`                  | Natural (base *e*) logarithm of *float*
`{fn LOG10(`*float*`)}`                | Base 10 logarithm of *float*
`{fn MOD(`*integer1*`,`*integer2*`)}`  | Remainder for *integer1* / *integer2*
`{fn PI()}`                            | The constant pi, approximately equal to 3.14159...
`{fn POWER(`*number*`,`*integer*`)}`   | *number* raised to *integer* power
`{fn RADIANS(`*number*`)}`             | Radians in *number* degrees
`{fn RAND(`*seed*`)}`                  | A random float value such that 0 &le; value < 1, and *seed* is ignored
`{fn ROUND(`*number*`,`*places*`)}`    | *number* rounded to *places*
`{fn SIGN(`*number*`)}`                | -1 if *number* is negative; 0 if *number* is 0; 1 if *number* is positive
`{fn SIN(`*float*`)}`                  | Sine of *float* radians
`{fn SQRT(`*float*`)}`                 | Square root of *float*
`{fn TAN(`*float*`)}`                  | Tangent of *float* radians
`{fn TRUNCATE(`*number*`,`*places*`)}` | *number* truncated to *places*

String Function                                                | Returns
-------------------------------------------------------------- | ---
`{fn ASCII(`*string*`)}`                                       | ASCII code of the first character in *string*
`{fn CHAR(`*code*`)}`                                          | Character with ASCII *code*
`{fn CHAR_LENGTH(`*string*`)}`                                 | Length in characters of *string*
`{fn CHARACTER_LENGTH(`*string*`)}`                            | Length in characters of *string*
`{fn CONCAT(`*string1*`,`*string2*`)}`                         | String formed by concatenating *string1* and *string2*
`{fn DIFFERENCE(`*string1*`,`*string2*`)}`                     | A number from 0 to 4 that indicates the phonetic similarity of *string1* and *string2* based on their Soundex codes, such that a larger return value indicates greater phonetic similarity; 0 indicates no similarity, 4 indicates strong similarity
`{fn INSERT(`*string1*`,`*position*`,`*length*`,`*string2*`)}` | String formed by replacing the *length*-character segment of *string1* at *position* with *string2*, available beginning with Teradata Database 15.0
`{fn LCASE(`*string*`)}`                                       | String formed by replacing all uppercase characters in *string* with their lowercase equivalents
`{fn LEFT(`*string*`,`*count*`)}`                              | Leftmost *count* characters of *string*
`{fn LENGTH(`*string*`)}`                                      | Length in characters of *string*
`{fn LOCATE(`*string1*`,`*string2*`)}`                         | Position in *string2* of the first occurrence of *string1*, or 0 if *string2* does not contain *string1*
`{fn LTRIM(`*string*`)}`                                       | String formed by removing leading spaces from *string*
`{fn OCTET_LENGTH(`*string*`)}`                                | Length in octets (bytes) of *string*
`{fn POSITION(`*string1*` IN `*string2*`)}`                    | Position in *string2* of the first occurrence of *string1*, or 0 if *string2* does not contain *string1*
`{fn REPEAT(`*string*`,`*count*`)}`                            | String formed by repeating *string* *count* times, available beginning with Teradata Database 15.0
`{fn REPLACE(`*string1*`,`*string2*`,`*string3*`)}`            | String formed by replacing all occurrences of *string2* in *string1* with *string3*
`{fn RIGHT(`*string*`,`*count*`)}`                             | Rightmost *count* characters of *string*, available beginning with Teradata Database 15.0
`{fn RTRIM(`*string*`)}`                                       | String formed by removing trailing spaces from *string*
`{fn SOUNDEX(`*string*`)}`                                     | Soundex code for *string*
`{fn SPACE(`*count*`)}`                                        | String consisting of *count* spaces
`{fn SUBSTRING(`*string*`,`*position*`,`*length*`)}`           | The *length*-character segment of *string* at *position*
`{fn UCASE(`*string*`)}`                                       | String formed by replacing all lowercase characters in *string* with their uppercase equivalents

System Function                         | Returns
--------------------------------------- | ---
`{fn DATABASE()}`                       | Current default database name
`{fn IFNULL(`*expression*`,`*value*`)}` | *expression* if *expression* is not NULL, or *value* if *expression* is NULL
`{fn USER()}`                           | Logon user name, which may differ from the current authorized user name after `SET QUERY_BAND` sets a proxy user

Time/Date Function                                                 | Returns
------------------------------------------------------------------ | ---
`{fn CURDATE()}`                                                   | Current date
`{fn CURRENT_DATE()}`                                              | Current date
`{fn CURRENT_TIME()}`                                              | Current time
`{fn CURRENT_TIMESTAMP()}`                                         | Current date and time
`{fn CURTIME()}`                                                   | Current time
`{fn DAYOFMONTH(`*date*`)}`                                        | Integer from 1 to 31 indicating the day of month in *date*
`{fn EXTRACT(YEAR FROM `*value*`)}`                                | The year component of the date and/or time *value*
`{fn EXTRACT(MONTH FROM `*value*`)}`                               | The month component of the date and/or time *value*
`{fn EXTRACT(DAY FROM `*value*`)}`                                 | The day component of the date and/or time *value*
`{fn EXTRACT(HOUR FROM `*value*`)}`                                | The hour component of the date and/or time *value*
`{fn EXTRACT(MINUTE FROM `*value*`)}`                              | The minute component of the date and/or time *value*
`{fn EXTRACT(SECOND FROM `*value*`)}`                              | The second component of the date and/or time *value*
`{fn HOUR(`*time*`)}`                                              | Integer from 0 to 23 indicating the hour of *time*
`{fn MINUTE(`*time*`)}`                                            | Integer from 0 to 59 indicating the minute of *time*
`{fn MONTH(`*date*`)}`                                             | Integer from 1 to 12 indicating the month of *date*
`{fn NOW()}`                                                       | Current date and time
`{fn SECOND(`*time*`)}`                                            | Integer from 0 to 59 indicating the second of *time*
`{fn TIMESTAMPADD(SQL_TSI_YEAR,`*count*`,`*timestamp*`)}`          | Timestamp formed by adding *count* years to *timestamp*
`{fn TIMESTAMPADD(SQL_TSI_MONTH,`*count*`,`*timestamp*`)}`         | Timestamp formed by adding *count* months to *timestamp*
`{fn TIMESTAMPADD(SQL_TSI_DAY,`*count*`,`*timestamp*`)}`           | Timestamp formed by adding *count* days to *timestamp*
`{fn TIMESTAMPADD(SQL_TSI_HOUR,`*count*`,`*timestamp*`)}`          | Timestamp formed by adding *count* hours to *timestamp*
`{fn TIMESTAMPADD(SQL_TSI_MINUTE,`*count*`,`*timestamp*`)}`        | Timestamp formed by adding *count* minutes to *timestamp*
`{fn TIMESTAMPADD(SQL_TSI_SECOND,`*count*`,`*timestamp*`)}`        | Timestamp formed by adding *count* seconds to *timestamp*
`{fn TIMESTAMPDIFF(SQL_TSI_YEAR,`*timestamp1*`,`*timestamp2*`)}`   | Number of years by which *timestamp2* exceeds *timestamp1*
`{fn TIMESTAMPDIFF(SQL_TSI_MONTH,`*timestamp1*`,`*timestamp2*`)}`  | Number of months by which *timestamp2* exceeds *timestamp1*
`{fn TIMESTAMPDIFF(SQL_TSI_DAY,`*timestamp1*`,`*timestamp2*`)}`    | Number of days by which *timestamp2* exceeds *timestamp1*
`{fn TIMESTAMPDIFF(SQL_TSI_HOUR,`*timestamp1*`,`*timestamp2*`)}`   | Number of hours by which *timestamp2* exceeds *timestamp1*
`{fn TIMESTAMPDIFF(SQL_TSI_MINUTE,`*timestamp1*`,`*timestamp2*`)}` | Number of minutes by which *timestamp2* exceeds *timestamp1*
`{fn TIMESTAMPDIFF(SQL_TSI_SECOND,`*timestamp1*`,`*timestamp2*`)}` | Number of seconds by which *timestamp2* exceeds *timestamp1*
`{fn YEAR(`*date*`)}`                                              | The year of *date*

#### Conversion Functions

Conversion function escape clauses are replaced by the corresponding SQL expression before the SQL request text is transmitted to the database.

Conversion Function                                             | Returns
--------------------------------------------------------------- | ---
`{fn CONVERT(`*value*`, SQL_BIGINT)}`                           | *value* converted to SQL `BIGINT`
`{fn CONVERT(`*value*`, SQL_BINARY(`*size*`))}`                 | *value* converted to SQL `BYTE(`*size*`)`
`{fn CONVERT(`*value*`, SQL_CHAR(`*size*`))}`                   | *value* converted to SQL `CHAR(`*size*`)`
`{fn CONVERT(`*value*`, SQL_DATE)}`                             | *value* converted to SQL `DATE`
`{fn CONVERT(`*value*`, SQL_DECIMAL(`*precision*`,`*scale*`))}` | *value* converted to SQL `DECIMAL(`*precision*`,`*scale*`)`
`{fn CONVERT(`*value*`, SQL_DOUBLE)}`                           | *value* converted to SQL `DOUBLE PRECISION`, a synonym for `FLOAT`
`{fn CONVERT(`*value*`, SQL_FLOAT)}`                            | *value* converted to SQL `FLOAT`
`{fn CONVERT(`*value*`, SQL_INTEGER)}`                          | *value* converted to SQL `INTEGER`
`{fn CONVERT(`*value*`, SQL_LONGVARBINARY)}`                    | *value* converted to SQL `VARBYTE(64000)`
`{fn CONVERT(`*value*`, SQL_LONGVARCHAR)}`                      | *value* converted to SQL `LONG VARCHAR`
`{fn CONVERT(`*value*`, SQL_NUMERIC)}`                          | *value* converted to SQL `NUMBER`
`{fn CONVERT(`*value*`, SQL_SMALLINT)}`                         | *value* converted to SQL `SMALLINT`
`{fn CONVERT(`*value*`, SQL_TIME(`*scale*`))}`                  | *value* converted to SQL `TIME(`*scale*`)`
`{fn CONVERT(`*value*`, SQL_TIMESTAMP(`*scale*`))}`             | *value* converted to SQL `TIMESTAMP(`*scale*`)`
`{fn CONVERT(`*value*`, SQL_TINYINT)}`                          | *value* converted to SQL `BYTEINT`
`{fn CONVERT(`*value*`, SQL_VARBINARY(`*size*`))}`              | *value* converted to SQL `VARBYTE(`*size*`)`
`{fn CONVERT(`*value*`, SQL_VARCHAR(`*size*`))}`                | *value* converted to SQL `VARCHAR(`*size*`)`

#### LIKE Predicate Escape Character

Within a `LIKE` predicate's *pattern* argument, the characters `%` (percent) and `_` (underscore) serve as wildcards.
To interpret a particular wildcard character literally in a `LIKE` predicate's *pattern* argument, the wildcard character must be preceded by an escape character, and the escape character must be indicated in the `LIKE` predicate's `ESCAPE` clause.

`LIKE` predicate escape character escape clauses are replaced by the corresponding SQL clause before the SQL request text is transmitted to the database.

`{escape '`*EscapeCharacter*`'}`

The escape clause must be specified immediately after the `LIKE` predicate that it applies to.

#### Outer Joins

Outer join escape clauses are replaced by the corresponding SQL clause before the SQL request text is transmitted to the database.

`{oj `*TableName*` `*OptionalCorrelationName*` LEFT OUTER JOIN `*TableName*` `*OptionalCorrelationName*` ON `*JoinCondition*`}`

`{oj `*TableName*` `*OptionalCorrelationName*` RIGHT OUTER JOIN `*TableName*` `*OptionalCorrelationName*` ON `*JoinCondition*`}`

`{oj `*TableName*` `*OptionalCorrelationName*` FULL OUTER JOIN `*TableName*` `*OptionalCorrelationName*` ON `*JoinCondition*`}`

#### Stored Procedure Calls

Stored procedure call escape clauses are replaced by the corresponding SQL clause before the SQL request text is transmitted to the database.

`{call `*ProcedureName*`}`

`{call `*ProcedureName*`(`*CommaSeparatedParameterValues...*`)}`

#### Native SQL

When a SQL request contains the native SQL escape clause, all escape clauses are replaced in the SQL request text, and the modified SQL request text is returned to the application as a result set containing a single row and a single VARCHAR column. The SQL request text is not transmitted to the database, and the SQL request is not executed. The native SQL escape clause mimics the functionality of the JDBC API `Connection.nativeSQL` method.

`{fn teradata_nativesql}`

#### Connection Functions

The following table lists connection function escape clauses that are intended for use with the native SQL escape clause `{fn teradata_nativesql}`.

These functions provide information about the connection, or control the behavior of the connection.
Functions that provide information return locally-cached information and avoid a round-trip to the database.
Connection function escape clauses are replaced by the returned information before the SQL request text is transmitted to the database.

Connection Function                           | Returns
--------------------------------------------- | ---
`{fn teradata_amp_count}`                     | Number of AMPs of the Teradata Database system
`{fn teradata_database_version}`              | Version number of the Teradata Database
`{fn teradata_driver_version}`                | Version number of the Teradata SQL Driver for R
`{fn teradata_getloglevel}`                   | Current log level
`{fn teradata_logon_sequence_number}`         | Session's Logon Sequence Number, if available
`{fn teradata_provide(config_response)}`      | Config Response parcel contents in JSON format
`{fn teradata_provide(connection_id)}`        | Connection's unique identifier within the process
`{fn teradata_provide(default_connection)}`   | `false` indicating this is not a stored procedure default connection
`{fn teradata_provide(host_id)}`              | Session's host ID
`{fn teradata_provide(java_charset_name)}`    | `UTF8`
`{fn teradata_provide(lob_support)}`          | `true` or `false` indicating this connection's LOB support
`{fn teradata_provide(local_address)}`        | Local address of the connection's TCP socket
`{fn teradata_provide(local_port)}`           | Local port of the connection's TCP socket
`{fn teradata_provide(original_hostname)}`    | Original specified Teradata Database hostname
`{fn teradata_provide(redrive_active)}`       | `true` or `false` indicating whether this connection has Redrive active
`{fn teradata_provide(remote_address)}`       | Hostname (if available) and IP address of the connected Teradata Database node
`{fn teradata_provide(remote_port)}`          | TCP port number of the Teradata Database
`{fn teradata_provide(rnp_active)}`           | `true` or `false` indicating whether this connection has Recoverable Network Protocol active
`{fn teradata_provide(session_charset_code)}` | Session character set code `191`
`{fn teradata_provide(session_charset_name)}` | Session character set name `UTF8`
`{fn teradata_provide(sip_support)}`          | `true` or `false` indicating this connection's StatementInfo parcel support
`{fn teradata_provide(transaction_mode)}`     | Session's transaction mode, `ANSI` or `TERA`
`{fn teradata_session_number}`                | Session number
`{fn teradata_setloglevel(`*LogLevel*`)}`     | Empty string, and changes the connection's *LogLevel*

#### Request-Scope Functions

The following table lists request-scope function escape clauses that are intended for use with preparing or executing a SQL request.

These functions control the behavior of the prepare or execute operation, and are limited in scope to the particular SQL request in which they are specified.
Request-scope function escape clauses are removed before the SQL request text is transmitted to the database.

Request-Scope Function                                 | Effect
------------------------------------------------------ | ---
`{fn teradata_clobtranslate(`*Option*`)}`              | Executes the SQL request with CLOB translate *Option* `U` (unlocked) or the default `L` (locked)
`{fn teradata_failfast}`                               | Reject ("fail fast") this SQL request rather than delay by a workload management rule or throttle
`{fn teradata_fake_result_sets}`                       | A fake result set containing statement metadata precedes each real result set
`{fn teradata_lobselect(`*Option*`)}`                  | Executes the SQL request with LOB select *Option* `S` (spool-scoped LOB locators), `T` (transaction-scoped LOB locators), or the default `I` (inline materialized LOB values)
`{fn teradata_parameter(`*Index*`,`*DataType*`)`       | Transmits parameter *Index* bind values as *DataType*
`{fn teradata_posixlt_off}`                            | Does not use `POSIXlt` subclasses for result set column value types.
`{fn teradata_posixlt_on}`                             | Uses `POSIXlt` subclasses for certain result set column value types.
`{fn teradata_provide(request_scope_lob_support_off)}` | Turns off LOB support for this SQL request
`{fn teradata_provide(request_scope_refresh_rsmd)}`    | Executes the SQL request with the default request processing option `B` (both)
`{fn teradata_provide(request_scope_sip_support_off)}` | Turns off StatementInfo parcel support for this SQL request
`{fn teradata_rpo(`*RequestProcessingOption*`)}`       | Executes the SQL request with *RequestProcessingOption* `S` (prepare), `E` (execute), or the default `B` (both)
`{fn teradata_untrusted}`                              | Marks the SQL request as untrusted; not implemented yet

<a name="FastLoad"></a>

### FastLoad

The Teradata SQL Driver for R now offers FastLoad.

Please be aware that this is just the initial release of the FastLoad feature. Think of it as a beta or preview version. It works, but does not yet offer all the features that JDBC FastLoad offers. FastLoad is still under active development, and we will continue to enhance it in subsequent builds.

FastLoad has limitations and cannot be used in all cases as a substitute for SQL batch insert:
* FastLoad can only load into an empty permanent table.
* FastLoad cannot load additional rows into a table that already contains rows.
* FastLoad cannot load into a volatile table or global temporary table.
* FastLoad cannot load duplicate rows into a `MULTISET` table.
* Do not use FastLoad to load only a few rows, because FastLoad opens extra connections to the database, which is time consuming.
* Only use FastLoad to load many rows (at least 100,000 rows) so that the row-loading performance gain exceeds the overhead of opening additional connections.
* FastLoad does not support all Teradata Database data types. For example, `BLOB` and `CLOB` are not supported.
* FastLoad requires StatementInfo parcel support to be enabled.
* FastLoad locks the destination table.
* If Online Archive encounters a table being loaded with FastLoad, online archiving of that table will be bypassed.

Your application can bind a single row of data for FastLoad, but that is not recommended because the overhead of opening additional connections causes FastLoad to be slower than a regular SQL `INSERT` for a single row.

How to use FastLoad:
* Auto-commit should be turned off before beginning a FastLoad.
* FastLoad is intended for binding many rows at a time. Each batch of rows must be able to fit into memory.
* When auto-commit is turned off, your application can insert multiple batches in a loop for the same FastLoad.
* Each column's data type must be consistent across every row in every batch over the entire FastLoad.
* The column values of the first row of the first batch dictate what the column data types must be in all subsequent rows and all subsequent batches of the FastLoad.

FastLoad opens multiple data transfer connections to the database. FastLoad evenly distributes each batch of rows across the available data transfer connections, and uses overlapped I/O to send and receive messages in parallel.

To use FastLoad, your application must prepend one of the following escape functions to the `INSERT` statement:
* `{fn teradata_try_fastload}` tries to use FastLoad for the `INSERT` statement, and automatically executes the `INSERT` as a regular SQL statement when the `INSERT` is not compatible with FastLoad.
* `{fn teradata_require_fastload}` requires FastLoad for the `INSERT` statement, and fails with an error when the `INSERT` is not compatible with FastLoad.

Your application can prepend other optional escape functions to the `INSERT` statement:
* `{fn teradata_sessions(`n`)}` specifies the number of data transfer connections to be opened, and is capped at the number of AMPs. The default is the smaller of 8 or the number of AMPs. `CHECK WORKLOAD` is not yet used, meaning that the driver does not ask the database how many data transfer connections should be used.
* `{fn teradata_error_table_1_suffix(`suffix`)}` specifies what suffix to append to the name of FastLoad error table 1. The default suffix is `_ERR_1`.
* `{fn teradata_error_table_2_suffix(`suffix`)}` specifies what suffix to append to the name of FastLoad error table 2. The default suffix is `_ERR_2`.
* `{fn teradata_error_table_database(`dbname`)}` specifies the parent database name for FastLoad error tables 1 and 2. By default, the FastLoad error tables reside in the same database as the destination table.

After beginning a FastLoad, your application can obtain the Logon Sequence Number (LSN) assigned to the FastLoad by prepending the following escape functions to the `INSERT` statement:
* `{fn teradata_nativesql}{fn teradata_logon_sequence_number}` returns the string form of an integer representing the Logon Sequence Number (LSN) for the FastLoad. Returns an empty string if the request is not a FastLoad.

FastLoad does not stop for data errors such as constraint violations or unique primary index violations. After inserting each batch of rows, your application must obtain warning and error information by prepending the following escape functions to the `INSERT` statement:
* `{fn teradata_nativesql}{fn teradata_get_warnings}` returns in one string all warnings generated by FastLoad for the request.
* `{fn teradata_nativesql}{fn teradata_get_errors}` returns in one string all data errors observed by FastLoad for the most recent batch. The data errors are obtained from FastLoad error table 1, for problems such as constraint violations, data type conversion errors, and unavailable AMP conditions.

Your application ends FastLoad by committing or rolling back the current transaction. After commit or rollback, your application must obtain warning and error information by prepending the following escape functions to the `INSERT` statement:
* `{fn teradata_nativesql}{fn teradata_get_warnings}` returns in one string all warnings generated by FastLoad for the commit or rollback. The warnings are obtained from FastLoad error table 2, for problems such as duplicate rows.
* `{fn teradata_nativesql}{fn teradata_get_errors}` returns in one string all data errors observed by FastLoad for the commit or rollback. The data errors are obtained from FastLoad error table 2, for problems such as unique primary index violations.

Warning and error information remains available until the next batch is inserted or until the commit or rollback. Each batch execution clears the prior warnings and errors. Each commit or rollback clears the prior warnings and errors.

<a name="ChangeLog"></a>

### Change Log

`17.0.0.6` - September 28, 2020
* RDBI-70 change hms::as.hms to hms::as_hms

`17.0.0.5` - August 26, 2020
* GOSQL-64 improve error checking for FastLoad escape functions

`17.0.0.4` - August 18, 2020
* GOSQL-62 prevent nativesql from executing FastLoad
* GOSQL-63 prevent FastLoad panic

`17.0.0.3` - July 30, 2020
* Build DLL and shared library with Go 1.14.6
* Sample program `fetchperftest.R`

`17.0.0.2` - June 10, 2020
* GOSQL-60 CLOBTranslate=Locked workaround for DBS DR 194293

`17.0.0.1` - June 4, 2020
* GOSQL-61 FastLoad accommodate encryptdata true

`16.20.0.38` - May 12, 2020
* GOSQL-58 support multiple files for Elicit File protocol
* GOSQL-59 FastLoad accommodate dbscontrol change of COUNT(*) return type

`16.20.0.37` - Apr 30, 2020
* GOSQL-57 Deferred LOB values larger than 1MB

`16.20.0.36` - Mar 27, 2020
* GOSQL-22 enable insert of large LOB values over 64KB
* GOSQL-52 teradata_try_fastload consider bind value data types
* GOSQL-54 enforce Decimal value maximum precision 38
* RDBI-56 Teradata data types up to TD 14.10

`16.20.0.35` - Jan 8, 2020
* GOSQL-51 FastLoad fails when table is dropped and recreated

`16.20.0.34` - Dec 10, 2019
* GOSQL-50 provide FastLoad duplicate row errors with auto-commit on
* RDBI-62 allow NA in bound list of raw values

`16.20.0.33` - Nov 26, 2019
* GOSQL-15 add database connection parameter

`16.20.0.32` - Nov 25, 2019
* RDBI-9 TJEncryptPassword.R sample program

`16.20.0.31` - Nov 21, 2019
* GOSQL-49 FastLoad support for additional connection parameters

`16.20.0.30` - Nov 20, 2019
* GOSQL-33 CALL to stored procedure INOUT and OUT parameter output values
* RDBI-54 Implement method dbNextResult

`16.20.0.29` - Nov 19, 2019
* RDBI-53 Implement method dbListObjects

`16.20.0.28` - Nov 15, 2019
* GOSQL-36 segment and iterate parameter batches per batch row limit
* GOSQL-43 segment and iterate parameter batches per request message size limit for FastLoad

`16.20.0.27` - Oct 23, 2019
* RDBI-61 improve performance for batch bind values

`16.20.0.26` - Oct 16, 2019
* GOSQL-46 LDAP password special characters

`16.20.0.25` - Oct 3, 2019
* GOSQL-45 FastLoad interop with Stored Password Protection

`16.20.0.24` - Sep 6, 2019
* GOSQL-14 add support for FastLoad protocol
* GOSQL-34 negative scale for Number values
* RDBI-16 Data Transfer - FastLoad Protocol

`16.20.0.23` - Aug 27, 2019
* GOSQL-40 Skip executing empty SQL request text
* RDBI-59 dbConnect named arguments as connection parameters

`16.20.0.22` - Aug 16, 2019
* GOSQL-39 COP Discovery interop with Kerberos

`16.20.0.21` - Aug 12, 2019
* GOSQL-38 timestamp prefix log messages

`16.20.0.20` - Aug 7, 2019
* GOSQL-4 Support COP discovery
* RDBI-10 COP Discovery

`16.20.0.19` - Jul 29, 2019
* GOSQL-18 Auto-commit
* RDBI-58 dbBegin dbCommit dbRollback methods

`16.20.0.18` - May 13, 2019
* RDBI-52 dbWriteTable field.types column subset

`16.20.0.17` - Apr 25, 2019
* RDBI-51 immediate connection parameter

`16.20.0.16` - Apr 23, 2019
* RDBI-50 dbSendStatement and dbSendQuery immediate parameter

`16.20.0.15` - Apr 17, 2019
* RDBI-49 difftime bind values

`16.20.0.14` - Apr 15, 2019
* RDBI-48 posixlt connection parameter

`16.20.0.13` - Apr 11, 2019
* RDBI-47 hms package dependency

`16.20.0.12` - Apr 9, 2019
* RDBI-38 Result TIME and TIMESTAMP values as R data types
* RDBI-46 Move required packages from Imports to Depends

`16.20.0.11` - Apr 2, 2019
* RDBI-45 NaN bind value

`16.20.0.10` - Mar 26, 2019
* RDBI-43 Implement dbFetch row count argument
* RDBI-44 dbAppendTable and dbWriteTable POSIXlt bind values

`16.20.0.9` - Mar 25, 2019
* RDBI-37 NA value insertion to database as NULL
* RDBI-40 POSIXct value insertion to database as TIMESTAMP without time zone
* RDBI-41 POSIXlt value insertion to database with gmtoff specify time zone
* RDBI-42 Remove support for binding AsIs list of POSIXct values

`16.20.0.8` - Mar 22, 2019
* RDBI-39 dbWriteTable accept NULL row.names

`16.20.0.7` - Mar 14, 2019
* RDBI-36 POSIXct vector bind value

`16.20.0.6` - Mar 12, 2019
* RDBI-35 dbWriteTable accept and ignore field.types with append = TRUE

`16.20.0.5` - Mar 8, 2019
* RDBI-26 Implement method dbGetInfo
* RDBI-30 Implement method dbListFields

`16.20.0.4` - Mar 6, 2019
* RDBI-20 Parameterized SQL with bind values
* RDBI-21 New behavior to execute non-parameterized SQL requests
* RDBI-23 Implement method dbIsValid for connection
* RDBI-25 Implement method dbWriteTable
* RDBI-27 Implement method dbExistsTable
* RDBI-29 Implement method dbRemoveTable
* RDBI-34 BYTE BLOB VARBYTE result set values

`16.20.0.3` - Feb 26, 2019
* RDBI-28 Implement method dbListTables
* RDBI-32 Implement method dbGetRowsAffected

`16.20.0.2` - Feb 8, 2019
* GOSQL-11 JWT authentication method
* GOSQL-16 tmode connection parameter
* GOSQL-17 commit and rollback functions
* RDBI-7 Teradata Vantage User Logon mechanisms
* RDBI-14 Implement support for JWT logon mechanism
* RDBI-24 Empty result sets

`16.20.0.1` - Jan 3, 2019
* RDBI-2 OS Platforms (added Mac compatibility)

`16.20.0.0` - Nov 28, 2018
* RDBI-1 R driver connectivity
* RDBI-4 R Language Version
* RDBI-6 Teradata Vantage version support
* RDBI-8 Data Security
