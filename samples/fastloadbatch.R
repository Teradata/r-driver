# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to FastLoad batches of rows.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), '{"host":"whomooz","user":"guest","password":"please"}')

	tryCatch ({

		sTableName <- "FastLoadBatch"

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName)
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		sRequest <- paste0 ("CREATE TABLE ", sTableName, " (c1 INTEGER NOT NULL, c2 VARCHAR(10))")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({
			cat ("DBI::dbBegin\n")
			DBI::dbBegin (con)

			tryCatch ({
				df <- data.frame (
					c1 = c (1, 2, 3),
					c2 = c (NA, "ABC", "DEF")
				)

				sInsert <- paste0 ("{fn teradata_try_fastload}INSERT INTO ", sTableName, " (?, ?)")
				cat (paste0 (sInsert, "\n"))
				DBI::dbExecute (con, sInsert, df)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_logon_sequence_number}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				df <- data.frame (
					c1 = c (4, 5, 6),
					c2 = c ("MNO", NA, "PQR")
				)

				cat (paste0 (sInsert, "\n"))
				DBI::dbExecute (con, sInsert, df)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				df <- data.frame (
					c1 = c (7, 8, 9),
					c2 = c ("UVW", "XYZ", NA)
				)

				cat (paste0 (sInsert, "\n"))
				DBI::dbExecute (con, sInsert, df)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

			}, finally = {
				cat ("DBI::dbCommit\n")
				DBI::dbCommit (con)
			}) # end finally

			sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
			cat (paste0 (sRequest, "\n"))
			print (DBI::dbGetQuery (con, sRequest), right = FALSE)

			sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
			cat (paste0 (sRequest, "\n"))
			print (DBI::dbGetQuery (con, sRequest), right = FALSE)

			sRequest <- paste0 ("SELECT * FROM ", sTableName, " ORDER BY 1")
			cat (paste0 (sRequest, "\n"))
			print (DBI::dbGetQuery (con, sRequest), right = FALSE)

		}, finally = {
			sRequest <- paste0 ("DROP TABLE ", sTableName)
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
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
