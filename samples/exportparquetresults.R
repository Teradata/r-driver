# Copyright 2026 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to export the results from a multi-statement request into multiple Parquet files.

options (warn = 2) # convert warnings to errors
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

		df <- data.frame (
			c1 = c (1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L),
			c2 = c ("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9")
		)

		sRequest <- "create volatile table voltab (c1 INTEGER NOT NULL, c2 VARCHAR(10)) on commit preserve rows"
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		sInsert <- "INSERT INTO voltab (?, ?)"
		cat (paste0 (sInsert, "\n"))
		DBI::dbExecute (con, sInsert, df)

		parquetFileName <- "dataR.parquet"

		sRequest <- paste0 ("{fn teradata_write_parquet(", parquetFileName, ")}select * from voltab where c1 < 5 order by 1;select * from voltab where c1 >= 5 order by 1;select 'abc' as col1, '12' as col2")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({

			listFileNames <- list ("dataR.parquet", "dataR_1.parquet", "dataR_2.parquet")

			for (sFileName in listFileNames) {
				readParquetFile (sFileName)
			}

		}, finally = {
			for (sFileName in listFileNames) {
				cat (paste0 ("file.remove(", sFileName, ")\n"))
				file.remove (sFileName)
			}
		})

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
