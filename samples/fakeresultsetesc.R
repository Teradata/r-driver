# Copyright 2020 by Teradata Corporation. All rights reserved.

# This sample program demonstrates the behavior of the fake_result_sets escape function.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		DBI::dbExecute (con, "create volatile table voltab1 (c1 integer, c2 varchar(100)) on commit preserve rows")
		DBI::dbExecute (con, "insert into voltab1 values (1, 'abc')")
		DBI::dbExecute (con, "insert into voltab1 values (2, 'def')")

		DBI::dbExecute (con, "create volatile table voltab2 (c1 integer, c2 varchar(100)) on commit preserve rows")
		DBI::dbExecute (con, "insert into voltab2 values (3, 'ghi')")
		DBI::dbExecute (con, "insert into voltab2 values (4, 'jkl')")
		DBI::dbExecute (con, "insert into voltab2 values (5, 'mno')")

		DBI::dbExecute (con, "create volatile table voltab3 (c1 integer, c2 varchar(100)) on commit preserve rows")
		DBI::dbExecute (con, "insert into voltab3 values (6, 'pqr')")
		DBI::dbExecute (con, "insert into voltab3 values (7, 'stu')")
		DBI::dbExecute (con, "insert into voltab3 values (8, 'vwx')")
		DBI::dbExecute (con, "insert into voltab3 values (9, 'yz')")

		res <- DBI::dbSendQuery (con, "{fn teradata_fake_result_sets}select * from voltab1 order by 1")

		tryCatch ({

			cat ("=== Two result sets produced by a single-statement SQL request that returns one result set ===\n")
			cat (" --- Fake result set ---\n")
			df <- DBI::dbFetch (res)
			cat (paste0 ("Column ", c (1 : length (df)), " ", format (names (df), justify = "left"), " = ", format (df)), sep = "\n")
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))
			cat (" --- Real result set ---\n")
			df <- DBI::dbFetch (res)
			print (df, right = FALSE)
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))
			cat ("\n")

		}, finally = {

			DBI::dbClearResult (res)

		})

		res <- DBI::dbSendQuery (con, "{fn teradata_fake_result_sets}select * from voltab2 order by 1 ; select * from voltab3 order by 1")

		tryCatch ({

			cat ("=== Four result sets produced by a multi-statement SQL request that returns two result sets ===\n")
			cat (" --- Fake result set ---\n")
			df <- DBI::dbFetch (res)
			cat (paste0 ("Column ", c (1 : length (df)), " ", format (names (df), justify = "left"), " = ", format (df)), sep = "\n")
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))
			cat (" --- Real result set ---\n")
			df <- DBI::dbFetch (res)
			print (df, right = FALSE)
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))
			cat (" --- Fake result set ---\n")
			df <- DBI::dbFetch (res)
			cat (paste0 ("Column ", c (1 : length (df)), " ", format (names (df), justify = "left"), " = ", format (df)), sep = "\n")
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))
			cat (" --- Real result set ---\n")
			df <- DBI::dbFetch (res)
			print (df, right = FALSE)
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))

		}, finally = {

			DBI::dbClearResult (res)

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
