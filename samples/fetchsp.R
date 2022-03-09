# Copyright 2020 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates fetching results from a stored procedure.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sProcName <- "TestProc"

		cat (" --- Stored procedure with no output parameters and no dynamic result set ---\n")

		# Trailing semicolon is required for replace procedure, unlike almost all other SQL statements.
		sRequest <- paste0 ("replace procedure ", sProcName, " () begin end ;")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({

			sRequest <- paste0 ("{call ", sProcName, "}")
			cat (paste0 (sRequest, "\n"))
			res <- DBI::dbSendQuery (con, sRequest)

			tryCatch ({

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

			}, finally = {
				DBI::dbClearResult (res)
			})

			cat (" --- Stored procedure with output parameters but no dynamic result set ---\n")

			sRequest <- paste0 ("replace procedure ", sProcName, " (in p1 integer, inout p2 integer, out p3 integer)",
				" begin",
				" set p2 = p1 + p2 ;",
				" set p3 = 100 ;",
				" end ;")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			sRequest <- paste0 ("{call ", sProcName, " (?, ?, ?)}")
			cat (paste0 (sRequest, "\n"))
			res <- DBI::dbSendQuery (con, sRequest, data.frame (1L, 2L))

			tryCatch ({

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

			}, finally = {
				DBI::dbClearResult (res)
			})

			cat (" --- Stored procedure with no output parameters but returning dynamic result sets ---\n")

			sRequest <- paste0 ("replace procedure ", sProcName, " ()",
				" dynamic result sets 2",
				" begin",
				" declare cur1 cursor with return for select 123 ;",
				" declare cur2 cursor with return for select 456 ;",
				" open cur1 ;",
				" open cur2 ;",
				" end ;")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			sRequest <- paste0 ("{call ", sProcName, "}")
			cat (paste0 (sRequest, "\n"))
			res <- DBI::dbSendQuery (con, sRequest)

			tryCatch ({

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

			}, finally = {
				DBI::dbClearResult (res)
			})

			cat (" --- Stored procedure with output parameters and dynamic result sets ---\n")

			sRequest <- paste0 ("replace procedure ", sProcName, " (in p1 integer, inout p2 integer, out p3 integer)",
				" dynamic result sets 2",
				" begin",
				" declare cur1 cursor with return for select 123 ;",
				" declare cur2 cursor with return for select 456 ;",
				" open cur1 ;",
				" open cur2 ;",
				" set p2 = p1 + p2 ;",
				" set p3 = 100 ;",
				" end ;")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			sRequest <- paste0 ("{call ", sProcName, " (?, ?, ?)}")
			cat (paste0 (sRequest, "\n"))
			res <- DBI::dbSendQuery (con, sRequest, data.frame (1L, 2L))

			tryCatch ({

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

				df <- DBI::dbFetch (res)
				print (df, right = FALSE)
				bAvail <- teradatasql::dbNextResult (res)
				cat (paste0 ("Another result available? ", bAvail, "\n"))

			}, finally = {
				DBI::dbClearResult (res)
			})
		}, finally = {

			sRequest <- paste0 ("drop procedure ", sProcName)
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
