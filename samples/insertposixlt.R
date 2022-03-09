# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert R POSIXlt values into a temporary table using the DBI::dbWriteTable method.
# This sample program demonstrates how to print the DDL of the table created by the DBI::dbWriteTable method.
# This sample program demonstrates how to prepare a query of the table and print the result set column metadata without
# executing the query.
# This sample program demonstrates how to query the table using the DBI::dbGetQuery method and print the result.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), '{"host":"whomooz","user":"guest","password":"please"}')

	tryCatch ({

		df <- data.frame (
			c1 = c ("2001-11-12 12:34:56", "2001-11-12 12:34:56.123", "2001-11-12 12:34:56.123456", NA),
			c2 = c ("2001-11-12 12:34:56", "2001-11-12 12:34:56.123", "2001-11-12 12:34:56.123456", NA),
			stringsAsFactors = FALSE) # constructors below require a character vector not factors

		# The data.frame constructor mishandles POSIXlt vectors, so the POSIXlt vectors must be specified after construction.
		df$c1 <- as.POSIXlt (df$c1)
		df$c2 <- as.POSIXlt (df$c2)

		# Omit the zone and gmtoff names for TIMESTAMP without time zone.
		df$c1$zone <- NULL
		df$c1$gmtoff <- NULL

		# Provide the zone and gmtoff names for TIMESTAMP WITH TIME ZONE.
		# The zone and gmtoff names must be added in the following order if not already present
		df$c2$zone <- ""
		df$c2$gmtoff <- c (
			20700L, # +05:45 Nepal
			-12600L, # -03:30 Newfoundland
			-18000L, # -05:00 Eastern Standard Time
			NA
		)

		sTableName <- "voltab"
		DBI::dbWriteTable (con, sTableName, df, temporary = TRUE)

		df <- DBI::dbGetQuery (con, paste0 ("show table ", sTableName))
		cat (gsub ("\r", "\n", df [1, 1]), "\n\n")

		sQuery <- paste0 ("{fn teradata_posixlt_on}select * from ", sTableName)

		# specify immediate = FALSE to prepare but not execute
		res <- DBI::dbSendQuery (con, sQuery, immediate = FALSE)
		tryCatch ({
			print (DBI::dbColumnInfo (res), right = FALSE) # obtain result set column metadata from prepared statement
		}, finally = {
			DBI::dbClearResult (res)
		})

		cat ("\n")
		print (DBI::dbGetQuery (con, sQuery), right = FALSE)

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
