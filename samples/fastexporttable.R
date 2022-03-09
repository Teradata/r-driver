# Copyright 2020 by Teradata Corporation. All rights reserved.

# This sample program demonstrates how to FastExport rows from a table.

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "FastExportTable"

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

			sInsert <- paste0 ("INSERT INTO ", sTableName, " VALUES (?, ?)")
			cat (paste0 (sInsert, "\n"))
			DBI::dbExecute (con, sInsert, data.frame (
				c1 = c (1, 2, 3, 4, 5, 6, 7, 8, 9),
				c2 = c (NA, "abc", "def", "mno", NA, "pqr", "uvw", "xyz", NA)
			))

			sSelect <- paste0 ("{fn teradata_try_fastexport}SELECT * FROM ", sTableName)
			cat (paste0 (sSelect, "\n"))
			res <- DBI::dbSendQuery (con, sSelect)

			tryCatch ({

				print (OrderByColumn (1, DBI::dbFetch (res)), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sSelect)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sSelect)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_logon_sequence_number}", sSelect)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

			}, finally = {

				DBI::dbClearResult (res)

			}) # end finally

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

OrderByColumn <- function (nSortColumn, df) {

	df <- df [order (df [, nSortColumn]), ]
	row.names (df) <- NULL # remove the disordered row.names
	return (df)

} # end OrderByColumn

withCallingHandlers (main (), error = function (e) {
	listStackFrames <- head (tail (sys.calls (), -1), -2) # omit first one and last two
	nStackFrameCount <- length (listStackFrames)
	cat (paste0 ("[", 1 : nStackFrameCount, "/", nStackFrameCount, "] ", listStackFrames, "\n\n", collapse = ""))
})
