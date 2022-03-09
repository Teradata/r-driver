# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert R raw values into a temporary table using the DBI::dbWriteTable method.
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

		df <- data.frame (c1 = I (list ( # specify raw values in an AsIs list
			as.raw (0x1L:0x3L),
			as.raw (0x4L:0x5L),
			NA
		)))

		sTableName <- "voltab"
		DBI::dbWriteTable (con, sTableName, df, temporary = TRUE)

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
