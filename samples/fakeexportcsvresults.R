# Copyright 2021 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to export the results from a multi-statement request into
# multiple CSV files and obtain info on each statement using fake_result_sets escape function.

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

		sRequest <- paste0 ("{fn teradata_write_csv(",  csvFileName, ")}{fn teradata_fake_result_sets}select * from voltab where c1 < 5 order by 1;select * from voltab where c1 >= 5 order by 1;select 'abc' as col1, '12' as col2")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({

			# When using fake_result_sets escape function, two csv files are produced for each statement in the SQL request
			listFileNames <- list ("dataR.csv" , "dataR_1.csv", "dataR_2.csv", "dataR_3.csv", "dataR_4.csv", "dataR_5.csv")

			cat ("\n=== Two csv files produced by each statement in the SQL request ===\n")
			nResult <- 1
			nFile <- 1
			for (csvFileName in listFileNames) {

				df <- read.csv (file=csvFileName, sep=",", header=TRUE)

				# The fake result set is returned prior to the real result set
				if (nFile %% 2 == 1) {
					cat ("\n --- Fake result set ", nResult, "---\n")
					cat (paste0 ("Column ", c (1 : length (df)), " ", format (names (df), justify = "left"), " = ", format (df)), sep = "\n")
				} else {
					cat ("\n --- Real result set ", nResult, "---\n")
					print (df, right = TRUE, row.names = FALSE)
					nResult <- nResult + 1
				}

				nFile <- nFile + 1
			}
		}, finally = {
			for (csvFileName in listFileNames) {
				file.remove(csvFileName)
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
