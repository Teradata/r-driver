# Copyright 2026 by Teradata Corporation. All Rights Reserved.
# TERADATA CORPORATION CONFIDENTIAL AND TRADE SECRET

# This sample program demonstrates fake multi-statement results written to JSONL files.

# Run "Rscript -e \"install.packages('jsonlite')\"" to install the jsonlite package

options (warn = 2)
options (warning.length = 8000L)
options (width = 1000)

main <- function () {
	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")
	tryCatch ({
		asFileNames <- c ("dataR.jsonl", "dataR_1.jsonl", "dataR_2.jsonl", "dataR_3.jsonl", "dataR_4.jsonl", "dataR_5.jsonl")

		sRequest <- "create volatile table voltab (c1 integer, c2 varchar(100)) on commit preserve rows"
		cat (paste0 (sRequest, "\n"))
		DBI::dbExecute (con, sRequest)

		tryCatch ({
			sInsert <- "insert into voltab values (?, ?)"
			cat (paste0 (sInsert, "\n"))
			DBI::dbExecute (con, sInsert, data.frame (c1 = c (1, 2, 3), c2 = c ("abc", NA, "xyz")))

			sRequest <- paste0 ("{fn teradata_write_jsonl(", asFileNames [[1]], ")}{fn teradata_fake_result_sets}select * from voltab where c1 < 3 order by 1;select * from voltab where c1 >= 3 order by 1;select 123 as col1, 'abc' as col2")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			for (sFileName in asFileNames) {
				cat (paste0 ("\nread ", sFileName, "\n"))
				aRows <- lapply (readLines (sFileName, warn = FALSE), function (sLine) jsonlite::fromJSON (sLine, simplifyVector = FALSE))
				for (i in seq_along (aRows)) {
					for (sCol in c ("ColumnMetadata", "ParameterMetadata")) {
						oVal <- aRows [[i]] [[sCol]]
						if (! is.null (oVal) && is.character (oVal)) {
							oParsed <- tryCatch (jsonlite::fromJSON (oVal, simplifyVector = FALSE), error = function (e) NULL)
							if (! is.null (oParsed)) aRows [[i]] [[sCol]] <- oParsed
						}
					}
				}
				cat (jsonlite::toJSON (aRows, auto_unbox = TRUE, pretty = TRUE, null = "null"), sep = "\n")
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
