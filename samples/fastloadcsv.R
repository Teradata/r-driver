# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to FastLoad a CSV file.

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "FastLoadCSV"

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName)
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName, "_ERR_1")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName, "_ERR_2")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		df <- data.frame (
			c1 = c ("1", "2", "3", "4", "5", "6", "7", "8", "9"),
			c2 = c ("", "ABC", "DEF", "MNO", "" ,"PQR", "UVW", "XYZ", "")
		)
		print(df, right = TRUE, row.names = FALSE)

		csvFileName <- "dataR.csv"
		cat (paste0 ("write ", csvFileName, "\n"))
		write.csv(df, csvFileName, quote = FALSE, row.names = FALSE)

		tryCatch ({

			sRequest <- paste0 ("CREATE TABLE ", sTableName, " (c1 INTEGER NOT NULL, c2 VARCHAR(10))")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			tryCatch ({

				cat ("DBI::dbBegin\n")
				DBI::dbBegin (con)

				tryCatch ({

					sInsert <- paste0 ("{fn teradata_require_fastload}{fn teradata_read_csv(", csvFileName,")}INSERT INTO ", sTableName, " (?, ?)")
					cat (paste0 (sInsert, "\n"))
					DBI::dbExecute (con, sInsert)

					sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
					cat (paste0 (sRequest, "\n"))
					print (DBI::dbGetQuery (con, sRequest), right = FALSE)

					sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
					cat (paste0 (sRequest, "\n"))
					print (DBI::dbGetQuery (con, sRequest), right = FALSE)

					sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_logon_sequence_number}", sInsert)
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
				print (DBI::dbGetQuery (con, sRequest), right = TRUE, row.names = FALSE)

			}, finally = {

				sRequest <- paste0 ("DROP TABLE ", sTableName)
				cat (paste0 (sRequest, "\n"))
				DBI::dbExecute (con, sRequest)

			}) # end finally

		}, finally = {

			cat (paste0 ("file.remove(", csvFileName, ")\n"))
			file.remove(csvFileName)

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
