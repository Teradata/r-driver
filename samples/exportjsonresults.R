# Copyright 2026 by Teradata Corporation. All Rights Reserved.
# TERADATA CORPORATION CONFIDENTIAL AND TRADE SECRET

# This sample program demonstrates how a multi-statement request writes multiple JSON files.

options (warn = 2)
options (warning.length = 8000L)
options (width = 1000)

main <- function () {
	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")
	tryCatch ({
		asFileNames <- c ("dataR.json", "dataR_1.json", "dataR_2.json")
		DBI::dbExecute (con, "create volatile table voltab (c1 integer, c2 varchar(100)) on commit preserve rows")
		tryCatch ({
			DBI::dbExecute (con, "insert into voltab values (?, ?)", data.frame (c1 = c (1, 2, 3), c2 = c ("abc", NA, "xyz")))
			sRequest <- paste0 ("{fn teradata_write_json(", asFileNames [[1]], ")}select * from voltab where c1 < 3 order by 1;select * from voltab where c1 >= 3 order by 1;select 123 as col1, 'abc' as col2")
			DBI::dbExecute (con, sRequest)
			for (sFileName in asFileNames) {
				cat (paste0 ("\nread ", sFileName, "\n"))
				cat (readLines (sFileName, warn = FALSE), sep = "\n")
				cat ("\n")
			}
		}, finally = {
			for (sFileName in asFileNames) if (file.exists (sFileName)) file.remove (sFileName)
		})
	}, finally = {
		DBI::dbDisconnect (con)
	})
	invisible (TRUE)
}

withCallingHandlers (main (), error = function (e) {
	cat (conditionMessage (e), "\n")
})
