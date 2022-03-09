# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert R numeric values into a temporary table using the DBI::dbWriteTable method.
# This sample program demonstrates how to print the DDL of the table created by the DBI::dbWriteTable method.
# This sample program demonstrates how to prepare a query of the table and print the result set column metadata without
# executing the query.
# This sample program demonstrates how to query the table using the DBI::dbReadTable method and print the result.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), '{"host":"whomooz","user":"guest","password":"please"}')

	tryCatch ({

		df <- data.frame (
			c1 = c (12.3, NA),
			c2 = c (123.45, NA),
			c3 = c (1.23456, NA),
			c4 = c (1.2, NA)
		)

		sTableName <- "voltab"

		# override default destination column data types for the second, third, and fourth columns
		DBI::dbWriteTable (con, sTableName, df, field.types = c (c2 = "decimal(18,2)", c3 = "decimal(38,5)", c4 = "number"), temporary = TRUE)

		df <- DBI::dbGetQuery (con, paste0 ("show table ", sTableName))
		cat (gsub ("\r", "\n", df [1, 1]), "\n\n")

		# specify immediate = FALSE to prepare but not execute
		res <- DBI::dbSendQuery (con, paste0 ("select * from ", sTableName), immediate = FALSE)
		tryCatch ({
			print (DBI::dbColumnInfo (res), right = FALSE) # obtain result set column metadata from prepared statement
		}, finally = {
			DBI::dbClearResult (res)
		})

		cat ("\n")
		print (DBI::dbReadTable (con, sTableName), right = FALSE)

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
