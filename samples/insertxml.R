# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert and retrieve XML values.
# Use the escape function teradata_parameter to override the data type for a parameter marker bind value.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "voltab"

		DBI::dbCreateTable (con, sTableName, c (c1 = "integer", c2 = "xml"), temporary = TRUE)

		DBI::dbExecute (con,
			paste0 ("{fn teradata_parameter(2,XML)}insert into ", sTableName, " values (?, ?)"),
			data.frame (
				c1 = 1L : 2L,
				c2 = c ("<hello>world</hello>", "<hello>moon</hello>")
			)
		)

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
