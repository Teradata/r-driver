# Copyright 2020 by Teradata Corporation. All rights reserved.

# This sample program demonstrates how to work with the Teradata Database's Character Export Width behavior.

# The Teradata SQL Driver for R always uses the UTF8 session character set, and the charset connection parameter
# is not supported. Be aware of the Teradata Database's Character Export Width behavior that adds trailing space
# padding to fixed-width CHAR data type result set column values when using the UTF8 session character set.

# Work around this drawback by using CAST or TRIM in SQL SELECT statements, or in views, to convert fixed-width CHAR
# data types to VARCHAR.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), '{"host":"whomooz","user":"guest","password":"please"}')

	tryCatch ({

		DBI::dbExecute (con, "CREATE TABLE MyTable (c1 CHAR(10), c2 CHAR(10))")
		tryCatch ({
			DBI::dbExecute (con, "INSERT INTO MyTable VALUES ('a', 'b')")

			cat ("Original query that produces trailing space padding:\n")
			print (DBI::dbGetQuery (con, "SELECT c1, c2 FROM MyTable"), right = FALSE)

			cat ("Modified query with either CAST or TRIM to avoid trailing space padding:\n")
			print (DBI::dbGetQuery (con, "SELECT CAST(c1 AS VARCHAR(10)), TRIM(TRAILING FROM c2) FROM MyTable"), right = FALSE)

			DBI::dbExecute (con, "CREATE VIEW MyView (c1, c2) AS SELECT CAST(c1 AS VARCHAR(10)), TRIM(TRAILING FROM c2) FROM MyTable")
			tryCatch ({
				cat ("Or query view with CAST or TRIM to avoid trailing space padding:\n")
				print (DBI::dbGetQuery (con, "SELECT c1, c2 FROM MyView"), right = FALSE)
			}, finally = {
				DBI::dbExecute (con, "DROP VIEW MyView")
			}) # end finally
		}, finally = {
			DBI::dbExecute (con, "DROP TABLE MyTable")
		}) # end finally

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
