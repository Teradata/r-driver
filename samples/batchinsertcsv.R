# Copyright 2021 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert a batch request using a CSV file

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		df <- data.frame (
			c1 = c ("1", "2", "3", "4", "5", "6", "7", "8", "9"),
			c2 = c ("", "ABC", "DEF", "MNO", "" ,"PQR", "UVW", "XYZ", "")
		)

		csvFileName <- "dataR.csv"
		cat (paste0 ("write ", csvFileName, "\n"))
		write.csv(df, csvFileName, quote = FALSE, row.names = FALSE)

		tryCatch ({

			sRequest <- paste0 ("create volatile table voltab (c1 INTEGER NOT NULL, c2 VARCHAR(10)) on commit preserve rows")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			sInsert <- paste0 ("{fn teradata_read_csv(", csvFileName,")} INSERT INTO voltab (?, ?)")
			cat (paste0 (sInsert, "\n"))
			DBI::dbExecute (con, sInsert)

		}, finally = {
			cat (paste0 ("file.remove(", csvFileName, ")\n"))
			file.remove(csvFileName)

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
