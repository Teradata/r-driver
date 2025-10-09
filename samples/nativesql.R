# Copyright 2025 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to call the teradatasql::nativeSQL method.

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		cat (paste0 ("{fn teradata_driver_version}   = ", teradatasql::nativeSQL (con, "{fn teradata_driver_version}"), "\n"))
		cat (paste0 ("{fn teradata_database_version} = ", teradatasql::nativeSQL (con, "{fn teradata_database_version}"), "\n"))
		cat (paste0 ("{fn teradata_session_number}   = ", teradatasql::nativeSQL (con, "{fn teradata_session_number}"), "\n"))

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
