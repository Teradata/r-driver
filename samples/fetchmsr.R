# Copyright 2020 by Teradata Corporation. All rights reserved.

# This sample program demonstrates fetching results from a multi-statement request.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		DBI::dbExecute (con, "create volatile table voltab1 (c1 integer, c2 varchar(100)) on commit preserve rows")
		DBI::dbExecute (con, "insert into voltab1 values (1, 'abc')")
		DBI::dbExecute (con, "insert into voltab1 values (2, 'def')")

		res <- DBI::dbSendQuery (con,
			"select * from voltab1 order by 1 ; insert into voltab1 values (3, 'ghi') ; select * from voltab1 order by 1")

		tryCatch ({

			cat (" --- Result from first statement (select) ---\n")
			df <- DBI::dbFetch (res)
			print (df, right = FALSE)
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))

			cat (" --- Result from second statement (insert) ---\n")
			df <- DBI::dbFetch (res)
			print (df, right = FALSE)
			bAvail <- teradatasql::dbNextResult (res)
			cat (paste0 ("Another result available? ", bAvail, "\n"))

			cat (" --- Result from third statement (select) ---\n")
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
