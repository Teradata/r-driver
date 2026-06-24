# Copyright 2026 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to FastLoad a JSONL file

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "FastLoadJSONL"

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName)
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName, "_ERR_1")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		tryCatch ({
			sRequest <- paste0 ("DROP TABLE ", sTableName, "_ERR_2")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)
		}, error = function (e) {
			cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
		})

		jsonlFileName <- "dataR.jsonl"
		cat (paste0 ("Writing ", jsonlFileName, "\n"))

		lines <- c (
			'{"c1":1,"c2":"x1","c3":[0.10,-0.20,0.30]}',
			'{"c2":"x2","c1":2,"c3":[0.20,-0.40,0.60]}',
			'{"c3":[0.30,-0.60,0.90],"c1":3,"c2":"x3"}',
			'{"c1":4,"c2":"x4","c3":[0.40,-0.80,1.20]}',
			'{"c1":5,"c2":null,"c3":[0.50,-1.00,1.50]}',
			'{"c1":6,"c2":"x6","c3":[0.60,-1.20,1.80]}',
			'{"c1":7,"c2":"x7","c3":[0.70,-1.40,2.10]}',
			'{"c1":8,"c2":"x8","c3":[0.80,-1.60,2.40]}',
			'{"c1":9,"c2":"x9","c3":[0.90,-1.80,2.70]}'
		)
		writeLines (lines, jsonlFileName, useBytes = TRUE)

		tryCatch ({

			sRequest <- paste0 ("CREATE TABLE ", sTableName, " (c1 INTEGER NOT NULL, c2 VARCHAR(10), c3 VECTOR) UNIQUE PRIMARY INDEX (c1)")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			tryCatch ({

				cat ("DBI::dbBegin\n")
				DBI::dbBegin (con)

				tryCatch ({

					sInsert <- paste0 (
						"{fn teradata_require_fastload}",
						"{fn teradata_read_jsonl(", jsonlFileName, ")}",
						"INSERT INTO ", sTableName, " (c1, c2, c3) VALUES (?, ?, ?)")
					cat (paste0 (sInsert, "\n"))
					DBI::dbExecute (con, sInsert)

					sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
					cat (paste0 (sRequest, "\n"))
					print (DBI::dbGetQuery (con, sRequest), right = FALSE)

					sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
					cat (paste0 (sRequest, "\n"))
					print (DBI::dbGetQuery (con, sRequest), right = FALSE)

					sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_logon_sequence_number}", sInsert)
					cat (paste0 (sRequest, "\n"))
					print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				}, finally = {
					cat ("DBI::dbCommit\n")
					DBI::dbCommit (con)
				})

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("SELECT c1, c2, c3 FROM ", sTableName, " ORDER BY 1")
				cat (paste0 (sRequest, "\n"))
				df <- DBI::dbGetQuery (con, sRequest)
				df$c3 <- lapply (df$c3, function (x) readBin (x, what = "double", n = length (x) / 8L, size = 8L, endian = "little"))
				print (df, right = TRUE, row.names = FALSE)

			}, finally = {
				sRequest <- paste0 ("DROP TABLE ", sTableName)
				cat (paste0 (sRequest, "\n"))
				tryCatch ({
					DBI::dbExecute (con, sRequest)
				}, error = function (e) {
					cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
				})
			})

		}, finally = {
			cat (paste0 ("file.remove(", jsonlFileName, ")\n"))
			tryCatch ({
				file.remove (jsonlFileName)
			}, error = function (e) {
				cat (paste0 ("file.remove failed: ", e, "\n"))
			})
		})

		invisible (TRUE)

	}, finally = {
		DBI::dbDisconnect (con)
	})

} # end main

withCallingHandlers (main (), error = function (e) {
	listStackFrames <- head (tail (sys.calls (), -1), -2)
	nStackFrameCount <- length (listStackFrames)
	cat (paste0 ("[", 1 : nStackFrameCount, "/", nStackFrameCount, "] ", listStackFrames, "\n\n", collapse = ""))
})
