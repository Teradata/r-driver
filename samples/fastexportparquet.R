# Copyright 2026 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to FastExport into a Parquet file.

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	readParquetFile <- function (sFileName) {
		cat (paste0 ("Reading Parquet file ", sFileName, "\n"))
		df <- arrow::read_parquet (sFileName)
		nRows <- nrow (df)
		for (i in seq_len (nRows)) {
			cat (paste0 ("Row ", i, ":\n"))
			for (col in names (df)) {
				val <- df [[col]] [[i]]
				cat (paste0 ("  ", formatC (col, width = 20L, flag = "-"), " = ", formatParquetValue (val), "\n"))
			}
		}
		cat (paste0 ("Row count: ", nRows, "\n"))
	}

	formatParquetValue <- function (val) {
		if (is.null (val) || (length (val) == 1L && is.na (val))) return ("NULL")
		if (is.raw (val)) return (paste0 ("0x", toupper (paste (format (val), collapse = ""))))
		s <- as.character (val)
		stripped <- trimws (s)
		if (nchar (stripped) > 0L && substr (stripped, 1L, 1L) %in% c ("{", "[")) {
			if (requireNamespace ("jsonlite", quietly = TRUE)) {
				result <- tryCatch ({
					formatted <- trimws (jsonlite::prettify (stripped), which = "right")
					indent    <- strrep (" ", 25L)
					gsub ("\n", paste0 ("\n", indent), formatted)
				}, error = function (e) NULL)
				if (!is.null (result)) return (result)
			}
		}
		s
	}

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "FastExportParquet"

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
				c1 = c (1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L),
				c2 = c (NA, "x2", "x3", "x4", NA, "x6", "x7", "x8", NA)
			))

			parquetFileName <- "dataR.parquet"

			sSelect <- paste0 ("{fn teradata_require_fastexport}{fn teradata_write_parquet(", parquetFileName, ")}SELECT * FROM ", sTableName, " ORDER BY 1")
			cat (paste0 ("\n", sSelect, "\n"))
			res <- DBI::dbSendQuery (con, sSelect, immediate = TRUE)

			tryCatch ({

				readParquetFile (parquetFileName)

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

				cat (paste0 ("\nfile.remove(", parquetFileName, ")\n"))
				file.remove (parquetFileName)
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
