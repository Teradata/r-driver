# Copyright 2019 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert R Date values into a temporary table using the DBI::dbWriteTable method.
# This sample program demonstrates how to print the DDL of the table created by the DBI::dbWriteTable method.
# This sample program demonstrates how to prepare a query of the table and print the result set column metadata without
# executing the query.
# This sample program demonstrates how to query the table using the DBI::dbReadTable method and print the result.

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

  con <- DBI::dbConnect (teradatasql::TeradataDriver (), '{"host":"whomooz","user":"guest","password":"please"}')

  tryCatch ({

    DBI::dbBegin (con)
    DBI::dbExecute (con, "create volatile table voltab (c1 integer) on commit preserve rows")
    DBI::dbCommit (con)

    DBI::dbBegin (con)
    DBI::dbExecute (con, "insert into voltab values (1)")
    DBI::dbCommit (con)

    DBI::dbBegin (con)
    DBI::dbExecute (con, "insert into voltab values (2)")
    DBI::dbRollback (con)

    DBI::dbBegin (con)
    DBI::dbExecute (con, "insert into voltab values (3)")
    DBI::dbExecute (con, "insert into voltab values (4)")
    DBI::dbCommit (con)

    DBI::dbBegin (con)
    DBI::dbExecute (con, "insert into voltab values (5)")
    DBI::dbExecute (con, "insert into voltab values (6)")
    DBI::dbRollback (con)

    DBI::dbBegin (con)
    df <- DBI::dbGetQuery (con, "select * from voltab order by 1")
    DBI::dbCommit (con)

    cat ("Expected result set row values: 1, 3, 4\n")
    cat (paste0 ("Obtained result set row values: ", toString (df [, 1]), "\n"))

    invisible (TRUE)

  }, finally = {

    DBI::dbDisconnect (con)

  }) # end finally

} # end main

withCallingHandlers (main (), error = function (e) {
  listStackFrames <- head (tail (sys.calls (), -1), -2) # omit first one and last two
  nStackFrameCount <- length (listStackFrames)
  cat (paste0 ("[", 1 : nStackFrameCount, "/", nStackFrameCount, "] ", listStackFrames, "\n\n", collapse = ""))
})
