## Teradata SQL Driver for R

This package enables R applications to connect to the Teradata Database.

This package implements the [DBI Specification](https://dbi.r-dbi.org/).

This package requires 64-bit R 3.4.3 or later, and runs on Windows, macOS, and Linux. 32-bit R is not supported.

For community support, please visit the [Connectivity Forum](http://community.teradata.com/t5/Connectivity/bd-p/DevXConnectivityBoard).

For Teradata customer support, please visit [Teradata Access](https://access.teradata.com/).

Copyright 2019 Teradata. All Rights Reserved.

### Table of Contents

* [Features](#Features)
* [Limitations](#Limitations)
* [Installation](#Installation)
* [License](#License)
* [Documentation](#Documentation)
* [Sample Programs](#SamplePrograms)
* [Using the Teradata SQL Driver for R](#Using)
* [Connection Parameters](#ConnectionParameters)
* [Stored Password Protection](#StoredPasswordProtection)
* [Data Types](#DataTypes)
* [Null Values](#NullValues)
* [Character Export Width](#CharacterExportWidth)
* [Constructors](#Constructors)
* [Driver Methods](#DriverMethods)
* [Connection Methods](#ConnectionMethods)
* [Result Methods](#ResultMethods)
* [Escape Syntax](#EscapeSyntax)
* [Change Log](#ChangeLog)

<a name="Features"></a>

### Features

The *Teradata SQL Driver for R* is a DBI Driver that enables R applications to connect to the Teradata Database. The Teradata SQL Driver for R implements the [DBI Specification](https://dbi.r-dbi.org/).

The Teradata SQL Driver for R is a young product that offers a basic feature set. We are working diligently to add features to the Teradata SQL Driver for R, and our goal is feature parity with the Teradata JDBC Driver.

At the present time, the Teradata SQL Driver for R offers the following features.

* Supported for use with Teradata Database 14.10 and later releases.
* Encrypted logon using the `TD2`, `JWT`, `LDAP`, `KRB5` (Kerberos), or `TDNEGO` logon mechanisms.
* Data encryption enabled via the `encryptdata` connection parameter.
* Unicode character data transferred via the UTF8 session character set.
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
* The following complex data types are not supported yet: `XML`, `JSON`, `DATASET STORAGE FORMAT AVRO`, and `DATASET STORAGE FORMAT CSV`.
* COP Discovery is not supported yet. You must specify the hostname or IP address of a specific Teradata Database node to connect to.
* No support yet for data encryption that is governed by central administration. To enable data encryption, you must specify a `true` value for the `encryptdata` connection parameter.
* Laddered Concurrent Connect is not supported yet.
* No support yet for Recoverable Network Protocol and Redrive.
* Auto-commit for ANSI transaction mode is not offered yet. You must explicitly execute a `commit` command when using ANSI transaction mode.
* FastLoad is not available yet.
* FastExport is not available yet.
* Monitor partition support is not available yet.

<a name="Installation"></a>

### Installation

The Teradata SQL Driver for R contains binary code and cannot be offered from [CRAN](https://cran.r-project.org/). The Teradata SQL Driver for R is available from Teradata's R package repository.

The Teradata SQL Driver for R depends on the `bit64`, `DBI`, and `hms` packages which are available from CRAN.

To download and install dependencies automatically, specify the Teradata R package repository and CRAN in the `repos` argument for `install.packages`.

    Rscript -e "install.packages('teradatasql',repos=c('https://teradata-download.s3.amazonaws.com','https://cloud.r-project.org'))"

<a name="License"></a>

### License

Use of the Teradata SQL Driver for R is governed by the *License Agreement for the Teradata SQL Driver for R*.

When the Teradata SQL Driver for R is installed, the `LICENSE` and `THIRDPARTYLICENSE` files are placed in the `teradatasql` directory under your R library directory. The following command prints the location of the `teradatasql` directory.

    Rscript -e "find.package('teradatasql')"

<a name="Documentation"></a>

### Documentation

When the Teradata SQL Driver for R is installed, the `README.md` file is placed in the `teradatasql` directory under your R library directory. This permits you to view the documentation offline, when you are not connected to the Internet. The following command prints the location of the `teradatasql` directory.

    Rscript -e "find.package('teradatasql')"

The `README.md` file is a plain text file containing the documentation for the Teradata SQL Driver for R. While the file can be viewed with any text file viewer or editor, your viewing experience will be best with an editor that understands Markdown format.

<a name="SamplePrograms"></a>

### Sample Programs

Sample programs are provided to demonstrate how to use the Teradata SQL Driver for R. When the Teradata SQL Driver for R is installed, the sample programs are placed in the `teradatasql/samples` directory under your R library directory.

The sample programs are coded with a fake Teradata Database hostname `whomooz`, username `guest`, and password `please`. Substitute your actual Teradata Database hostname and credentials before running a sample program.

Program                     | Purpose
--------------------------- | ---
insertdate.R                | Demonstrates how to insert R Date values into a temporary table.
insertdifftime.R            | Demonstrates how to insert R difftime values into a temporary table.
inserthms.R                 | Demonstrates how to insert R hms values into a temporary table.
insertinteger.R             | Demonstrates how to insert R integer values into a temporary table.
insertnumeric.R             | Demonstrates how to insert R numeric values into a temporary table.
insertposixct.R             | Demonstrates how to insert R POSIXct values into a temporary table.
insertposixlt.R             | Demonstrates how to insert R POSIXlt values into a temporary table.
insertraw.R                 | Demonstrates how to insert R raw values into a temporary table.
inserttime.R                | Demonstrates how to insert teradatasql TimeWithTimeZone, Timestamp, and TimestampWithTimeZone values into a temporary table.

<a name="Using"></a>

### Using the Teradata SQL Driver for R

Your R script calls the `DBI::dbConnect` function to open a connection to the Teradata Database.

Specify connection parameters as a JSON string:

    con <- DBI::dbConnect(teradatasql::TeradataDriver(), '{"host":"whomooz","user":"guest","password":"please"}')

<a name="ConnectionParameters"></a>

### Connection Parameters

The following table lists the connection parameters currently offered by the Teradata SQL Driver for R.

Our goal is consistency for the connection parameters offered by the Teradata SQL Driver for R and the Teradata JDBC Driver, with respect to connection parameter names and functionality. For comparison, Teradata JDBC Driver connection parameters are [documented here](http://developer.teradata.com/doc/connectivity/jdbc/reference/current/jdbcug_chapter_2.html#BGBHDDGB).

Parameter          | Default     | Type           | Description
------------------ | ----------- | -------------- | ---
`account`          |             | string         | Specifies the Teradata Database account. Equivalent to the Teradata JDBC Driver `ACCOUNT` connection parameter.
`column_name`      | `"false"`   | quoted boolean | Controls the `name` column returned by `DBI::dbColumnInfo`. Equivalent to the Teradata JDBC Driver `COLUMN_NAME` connection parameter. False specifies that the returned `name` column provides the AS-clause name if available, or the column name if available, or the column title. True specifies that the returned `name` column provides the column name if available, but has no effect when StatementInfo parcel support is unavailable.
`dbs_port`         | `"1025"`    | quoted integer | Specifies the Teradata Database port number. Equivalent to the Teradata JDBC Driver `DBS_PORT` connection parameter.
`encryptdata`      | `"false"`   | quoted boolean | Controls encryption of data exchanged between the Teradata Database and the Teradata SQL Driver for R. Equivalent to the Teradata JDBC Driver `ENCRYPTDATA` connection parameter.
`fake_result_sets` | `"false"`   | quoted boolean | Controls whether a fake result set containing statement metadata precedes each real result set.
`host`             |             | string         | Specifies the Teradata Database hostname. Note that COP Discovery is not implemented yet.
`immediate`        | `"true"`    | quoted boolean | Controls whether `DBI::dbSendQuery` and `DBI::dbSendStatement` execute the SQL request when the `params` and `immediate` arguments are omitted.
`lob_support`      | `"true"`    | quoted boolean | Controls LOB support. Equivalent to the Teradata JDBC Driver `LOB_SUPPORT` connection parameter.
`log`              | `"0"`       | quoted integer | Controls debug logging. Somewhat equivalent to the Teradata JDBC Driver `LOG` connection parameter. This parameter's behavior is subject to change in the future. This parameter's value is currently defined as an integer in which the 1-bit governs function and method tracing, the 2-bit governs debug logging, and the 4-bit governs transmit and receive message hex dumps.
`logdata`          |             | string         | Specifies extra data for the chosen logon authentication method. Equivalent to the Teradata JDBC Driver `LOGDATA` connection parameter.
`logmech`          | `"TD2"`     | string         | Specifies the logon authentication method. Equivalent to the Teradata JDBC Driver `LOGMECH` connection parameter. Possible values are `TD2` (the default), `JWT`, `LDAP`, `KRB5` for Kerberos, or `TDNEGO`.
`max_message_body` | `"2097000"` | quoted integer | Not fully implemented yet and intended for future usage. Equivalent to the Teradata JDBC Driver `MAX_MESSAGE_BODY` connection parameter.
`partition`        | `"DBC/SQL"` | string         | Specifies the Teradata Database Partition. Equivalent to the Teradata JDBC Driver `PARTITION` connection parameter.
`password`         |             | string         | Specifies the Teradata Database password. Equivalent to the Teradata JDBC Driver `PASSWORD` connection parameter.
`posixlt`          | `"false"`   | quoted boolean | Controls whether `POSIXlt` subclasses are used for certain result set column value types. Refer to the table below for details.
`sip_support`      | `"true"`    | quoted boolean | Controls whether StatementInfo parcel is used. Equivalent to the Teradata JDBC Driver `SIP_SUPPORT` connection parameter.
`teradata_values`  | `"true"`    | quoted boolean | Controls whether `character` or a more specific R data type is used for certain result set column value types. Refer to the table below for details.
`tmode`            | `"DEFAULT"` | string         | Specifies the transaction mode. Equivalent to the Teradata JDBC Driver `TMODE` connection parameter. Possible values are `DEFAULT` (the default), `ANSI`, or `TERA`.
`user`             |             | string         | Specifies the Teradata Database username. Equivalent to the Teradata JDBC Driver `USER` connection parameter.

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

We offer example programs in Java and Python to create encrypted password files for use with Stored Password Protection.

* You may use the [`TJEncryptPassword.java`](http://developer.teradata.com/doc/connectivity/jdbc/reference/current/samp/TJEncryptPassword.java.txt) sample program that is available with the [Teradata JDBC Driver Reference](http://developer.teradata.com/connectivity/reference/jdbc-driver).

* You may use the `TJEncryptPassword.py` sample program that is available with the [Teradata SQL Driver for Python](https://pypi.org/project/teradatasql/).

These programs create the files containing the password encryption key and encrypted password, which can be subsequently specified via the `ENCRYPTED_PASSWORD(` syntax.

You are not required to use these programs to create the files containing the password encryption key and encrypted password. You can develop your own software to create the necessary files. The only requirement is that the files must match the format expected by the Teradata SQL Driver for R, which is documented below.

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

Transformation              | Key Size
--------------------------- | ---
`DES/CBC/NoPadding`         | 64
`DES/CBC/PKCS5Padding`      | 64
`DES/CFB/NoPadding`         | 64
`DES/CFB/PKCS5Padding`      | 64
`DES/OFB/NoPadding`         | 64
`DES/OFB/PKCS5Padding`      | 64
`DESede/CBC/NoPadding`      | 192
`DESede/CBC/PKCS5Padding`   | 192
`DESede/CFB/NoPadding`      | 192
`DESede/CFB/PKCS5Padding`   | 192
`DESede/OFB/NoPadding`      | 192
`DESede/OFB/PKCS5Padding`   | 192
`AES/CBC/NoPadding`         | 128
`AES/CBC/NoPadding`         | 192
`AES/CBC/NoPadding`         | 256
`AES/CBC/PKCS5Padding`      | 128
`AES/CBC/PKCS5Padding`      | 192
`AES/CBC/PKCS5Padding`      | 256
`AES/CFB/NoPadding`         | 128
`AES/CFB/NoPadding`         | 192
`AES/CFB/NoPadding`         | 256
`AES/CFB/PKCS5Padding`      | 128
`AES/CFB/PKCS5Padding`      | 192
`AES/CFB/PKCS5Padding`      | 256
`AES/OFB/NoPadding`         | 128
`AES/OFB/NoPadding`         | 192
`AES/OFB/NoPadding`         | 256
`AES/OFB/PKCS5Padding`      | 128
`AES/OFB/PKCS5Padding`      | 192
`AES/OFB/PKCS5Padding`      | 256

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

This technique is also demonstrated in sample program `CharPadding.py`.

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

Creates a connection to the database and returns a Connection object. Specify connection parameters as a JSON string.

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

Begins a transaction. Not implemented yet.

---

`DBI::dbCommit(` *conn* `)`

Commits the current transaction. Not implemented yet.

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

Not implemented yet.

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

Rolls back the current transaction. Not implemented yet.

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
`{fn RAND(`*seed*`)}`                  | A random float value such that 0 ≤ value < 1, and *seed* is ignored
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
`{fn teradata_failfast}`                               | Reject ("fail fast") this SQL request rather than delay by a workload management rule or throttle
`{fn teradata_fake_result_sets}`                       | A fake result set containing statement metadata precedes each real result set
`{fn teradata_lobselect(`*Option*`)}`                  | Executes the SQL request with LOB select *Option* `S` (spool-scoped LOB locators), `T` (transaction-scoped LOB locators), or the default `I` (inline materialized LOB values)
`{fn teradata_posixlt_off}`                            | Does not use `POSIXlt` subclasses for result set column value types.
`{fn teradata_posixlt_on}`                             | Uses `POSIXlt` subclasses for certain result set column value types.
`{fn teradata_provide(request_scope_lob_support_off)}` | Turns off LOB support for this SQL request
`{fn teradata_provide(request_scope_refresh_rsmd)}`    | Executes the SQL request with the default request processing option `B` (both)
`{fn teradata_provide(request_scope_sip_support_off)}` | Turns off StatementInfo parcel support for this SQL request
`{fn teradata_rpo(`*RequestProcessingOption*`)}`       | Executes the SQL request with *RequestProcessingOption* `S` (prepare), `E` (execute), or the default `B` (both)
`{fn teradata_untrusted}`                              | Marks the SQL request as untrusted; not implemented yet

<a name="ChangeLog"></a>

### Change Log

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
