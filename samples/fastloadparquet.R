# Copyright 2026 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to FastLoad a Parquet file.

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "jdbc2000ek2", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "FastLoadParquet"

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

		# Create Parquet file with sample data
		parquetFileName <- "dataR.parquet"
		cat (paste0 ("Creating Parquet file: ", parquetFileName, "\n"))

		df <- data.frame (
			c1 = c (1, 2, 3, 4, 5, 6, 7, 8, 9),
			c2 = c ("test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8", "test9"),
			stringsAsFactors = FALSE
		)
		print(df, right = TRUE, row.names = FALSE)

		# Write Parquet file using arrow package
		arrow::write_parquet (df, parquetFileName, use_dictionary = FALSE)
		cat ("Parquet file created successfully\n")

		tryCatch ({

			sRequest <- paste0 ("CREATE TABLE ", sTableName, " (c1 INTEGER, c2 VARCHAR(10))")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			tryCatch ({

				cat ("DBI::dbBegin\n")
				DBI::dbBegin (con)

				tryCatch ({

					sInsert <- paste0 ("{fn teradata_require_fastload}{fn teradata_read_parquet(", parquetFileName,")}INSERT INTO ", sTableName, " (?, ?)")
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
				tryCatch ({
					DBI::dbExecute (con, sRequest)
				}, error = function (e) {
					cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
				})

			}) # end finally

		}, finally = {
			cat (paste0 ("file.remove(", parquetFileName, ")\n"))
			tryCatch ({
				file.remove(parquetFileName)
			}, error = function (e) {
				cat (paste0 ("file.remove failed: ", e, "\n"))
			})

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
