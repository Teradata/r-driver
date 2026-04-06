# Copyright 2026 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert a batch using a parquet file

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "jdbc2000ek2", user = "guest", password = "please")

	tryCatch ({

		# Create Parquet file with sample data
		parquetFileName <- "dataBatchR.parquet"
		cat (paste0 ("Creating Parquet file: ", parquetFileName, "\n"))

		df <- data.frame (
			c1 = c (1, 2, 3, 4, 5, 6, 7, 8, 9),
			c2 = c ("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9")
		)
		print(df, right = TRUE, row.names = FALSE)

		# Write Parquet file using arrow package
		arrow::write_parquet (df, parquetFileName) #, use_dictionary = FALSE)
		cat ("Parquet file created successfully\n")

		tryCatch ({

			sRequest <- paste0 ("create volatile table voltab (c1 INTEGER, c2 VARCHAR(10)) on commit preserve rows")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			sInsert <- paste0 ("{fn teradata_read_parquet(", parquetFileName,")} INSERT INTO voltab (?, ?)")
			cat (paste0 (sInsert, "\n"))
			DBI::dbExecute (con, sInsert)

		}, finally = {
			cat (paste0 ("file.remove(", parquetFileName, ")\n"))
			file.remove(parquetFileName)

		})

		sRequest <- paste0 ("SELECT * FROM voltab ORDER BY 1")
		cat (paste0 (sRequest, "\n"))
		print (DBI::dbGetQuery (con, sRequest), right = TRUE, row.names = FALSE)

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
