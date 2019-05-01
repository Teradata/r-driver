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
