# Copyright 2021 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to FastExport into a CSV file.

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "FastExportCSV"

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName)
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("\nIgnoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		sRequest <- paste0 ("\nCREATE TABLE ", sTableName, " (c1 INTEGER NOT NULL, c2 VARCHAR(10))")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({

			sInsert <- paste0 ("\nINSERT INTO ", sTableName, " VALUES (?, ?)")
			cat (paste0 (sInsert, "\n"))
			DBI::dbExecute (con, sInsert, data.frame (
				c1 = c (1, 2, 3, 4, 5, 6, 7, 8, 9),
				c2 = c (NA, "abc", "def", "mno", NA, "pqr", "uvw", "xyz", NA)
			))

			csvFileName <- "dataR.csv"

			sSelect <- paste0 ("{fn teradata_require_fastexport}{fn teradata_write_csv(",  csvFileName, ")}SELECT * FROM ", sTableName, " ORDER BY 1")
			cat (paste0 ("\n", sSelect, "\n"))
			res <- DBI::dbSendQuery (con, sSelect, immediate = TRUE)

			tryCatch ({

				cat (paste0 ("\nread ", csvFileName, "\n"))
				print (read.csv (file=csvFileName, sep=",", header=TRUE), right = TRUE, row.names = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sSelect)
				cat (paste0 ("\n", sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sSelect)
				cat (paste0 ("\n", sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_logon_sequence_number}", sSelect)
				cat (paste0 ("\n", sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

			}, finally = {

				cat (paste0 ("\nfile.remove(", csvFileName, ")\n"))
				file.remove(csvFileName)
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

withCallingHandlers (main (), error = function (e) {
	listStackFrames <- head (tail (sys.calls (), -1), -2) # omit first one and last two
	nStackFrameCount <- length (listStackFrames)
	cat (paste0 ("[", 1 : nStackFrameCount, "/", nStackFrameCount, "] ", listStackFrames, "\n\n", collapse = ""))
})
