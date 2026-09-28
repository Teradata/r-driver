# Copyright 2026 by Teradata Corporation. All Rights Reserved.
# TERADATA CORPORATION CONFIDENTIAL AND TRADE SECRET

# This sample program demonstrates how to FastExport into a JSONL file.

options (warn = 2)
options (warning.length = 8000L)
options (width = 1000)

main <- function () {
	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")
	tryCatch ({
		sTableName <- "FastExportJSONL"
		sFileName <- "dataR.jsonl"

		sRequest <- paste0 ("create table ", sTableName, " (c1 integer, c2 varchar(10))")
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({
			sInsert <- paste0 ("insert into ", sTableName, " values (?, ?)")
			cat (paste0 (sInsert, "\n"))
			DBI::dbExecute (con, sInsert, data.frame (c1 = c (1, 2, 3), c2 = c (NA, "abc", "xyz")))

			sRequest <- paste0 ("{fn teradata_try_fastexport}{fn teradata_write_jsonl(", sFileName, ")}select * from ", sTableName, " order by 1")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			cat (paste0 ("\nread ", sFileName, "\n"))
			cat (readLines (sFileName, warn = FALSE), sep = "\n")
			cat ("\n")
		}, finally = {
			if (file.exists (sFileName)) file.remove (sFileName)
			DBI::dbExecute (con, paste0 ("drop table ", sTableName))
		})
	}, finally = {
		DBI::dbDisconnect (con)
	})
	invisible (TRUE)
}

withCallingHandlers (main (), error = function (e) {
	cat (conditionMessage (e), "\n")
})
