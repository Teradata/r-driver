# Copyright 2021 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to export the results from a multi-statement request into multiple CSV files.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		df <- data.frame (
			c1 = c (1, 2, 3, 4, 5, 6, 7, 8, 9),
			c2 = c ("", "ABC", "DEF", "MNO", "" ,"PQR", "UVW", "XYZ", "")
		)

		csvFileName <- "dataR.csv"

		sRequest <- paste0 ("create volatile table voltab (c1 INTEGER NOT NULL, c2 VARCHAR(10)) on commit preserve rows")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		sInsert <- "INSERT INTO voltab (?, ?)"
		cat (paste0 (sInsert, "\n"))
		DBI::dbExecute (con, sInsert, df)

		sRequest <- paste0 ("{fn teradata_write_csv(",  csvFileName, ")}select * from voltab where c1 < 5 order by 1;select * from voltab where c1 >= 5 order by 1;select 'abc' as col1, '12' as col2")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({

			listFileNames <- list ("dataR.csv" , "dataR_1.csv", "dataR_2.csv")

			for (csvFileName in listFileNames) {

				cat (paste0 ("\nread ", csvFileName, "\n"))
				print (read.csv (file=csvFileName, sep=",", header=TRUE), right = TRUE, row.names = FALSE)
			}
		}, finally = {
			for (csvFileName in listFileNames) {
				file.remove (csvFileName)
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
