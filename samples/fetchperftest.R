# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to fetch a large result set containing many rows.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

nTableRowCount <- 100000L
anFetchRowCounts <- c (10L, 50L, 100L, 500L, 1000L, 2000L, 5000L, 10000L)

insertRows <- function (con, sTableName, nRemainingRowCount) {

	nMaxInsertRowCount <- 70000L # sys_calendar.calendar contains 73414 rows

	repeat {

		sSQL <- paste0 ("select zeroifnull(max(c1)) from ", sTableName)
		cat (paste0 (sSQL, "\n"))
		df <- DBI::dbGetQuery (con, sSQL)
		nCurrentMax <- df [1, 1]

		nRowCount <- min (nRemainingRowCount, nMaxInsertRowCount)
		sSQL <- paste0 ("insert into ", sTableName, " (c1) select c1 + ", nCurrentMax, " from (select row_number() over (order by calendar_date) as c1 from sys_calendar.calendar qualify c1 <= ", nRowCount, ") dt")
		cat (paste0 (sSQL, "\n"))
		DBI::dbExecute (con, sSQL)

		if (nRemainingRowCount <= nMaxInsertRowCount) { break }
		nRemainingRowCount <- nRemainingRowCount - nMaxInsertRowCount

	} # end repeat

} # end insertRows

fetchPerfTest <- function (con, sTableName, nFetchRowCount) {

	sSQL <- paste0 ("select * from ", sTableName, " order by 1")
	cat (paste0 (sSQL, "\n"))

	res <- DBI::dbSendQuery (con, sSQL)
	tryCatch ({
		cat (paste0 ("Fetching ", nFetchRowCount, " rows at a time\n"))

		dTotalStartTime <- Sys.time ()
		nFetchedRowCount <- 0L

		repeat {
			df <- DBI::dbFetch (res, n = nFetchRowCount)
			if (nrow (df) == 0) { break }
			nFetchedRowCount <- nFetchedRowCount + nrow (df)
		}

		dTotalElapsedTime <- as.double (Sys.time () - dTotalStartTime)
		cat (paste0 ("Fetched ", nFetchedRowCount, " total rows (", nFetchRowCount, " rows at a time) in ", dTotalElapsedTime, " seconds, throughput = ", nFetchedRowCount / dTotalElapsedTime, " rows/sec\n"))

	}, finally = {

		DBI::dbClearResult (res)

	}) # end finally

} # end fetchPerfTest

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "voltab"

		DBI::dbCreateTable (con, sTableName, c (c1 = "integer", c2 = "varchar(100)"), temporary = TRUE)

		insertRows (con, sTableName, nTableRowCount)

		sSQL <- paste0 ("update ", sTableName, " set c2 = 'The number is ' || cast(c1 as varchar(100))")
		cat (paste0 (sSQL, "\n"))
		DBI::dbExecute (con, sSQL)

		for (nFetchRowCount in anFetchRowCounts) { fetchPerfTest (con, sTableName, nFetchRowCount) }

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
