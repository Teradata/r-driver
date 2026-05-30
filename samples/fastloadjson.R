# Copyright 2026 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to FastLoad a JSON file.
# It also illustrates dual treatment of a nested JSON object: the raw JSON
# string is stored verbatim in the "address" column, while the flattened
# sub-field "city" is stored in a separate column.

options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "whomooz", user = "guest", password = "please")

	tryCatch ({

		sTableName <- "FastLoadJSON"

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

		# Each record has three top-level keys:
		#   id      -- scalar integer
		#   name    -- scalar string
		#   address -- nested object; its raw JSON string maps to the "address" column
		#              and its sub-field "city" maps to the "city" column.
		sJSONData <- paste0 (
			'[',
			'{"id":1,"name":"Alice","address":{"city":"Boston"}},',
			'{"id":2,"name":"Bob","address":{"city":"Austin"}},',
			'{"id":3,"name":"Carol","address":{"city":"Chicago"}},',
			'{"id":4,"name":"Dave","address":{"city":"Denver"}},',
			'{"id":5,"name":"Erin","address":{"city":"Eugene"}},',
			'{"id":6,"name":"Frank","address":{"city":"Fresno"}},',
			'{"id":7,"name":"Grace","address":{"city":"Houston"}},',
			'{"id":8,"name":"Hank","address":{"city":"Irvine"}},',
			'{"id":9,"name":"Iris","address":{"city":"Jacksonville"}}',
			']')

		jsonFileName <- "dataR.json"
		cat (paste0 ("Writing ", jsonFileName, "\n"))
		writeLines (sJSONData, jsonFileName, useBytes = TRUE)

		tryCatch ({

			sRequest <- paste0 ("CREATE TABLE ", sTableName, " (id INTEGER, name VARCHAR(20), address VARCHAR(200), city VARCHAR(20)) UNIQUE PRIMARY INDEX (id)")
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			tryCatch ({

				cat ("DBI::dbBegin\n")
				DBI::dbBegin (con)

				tryCatch ({

					sInsert <- paste0 (
						"{fn teradata_require_fastload}",
						"{fn teradata_read_json(", jsonFileName, ")}",
						"INSERT INTO ", sTableName, " (id, name, address, city) VALUES (?, ?, ?, ?)")
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

				}) # end finally

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_warnings}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("{fn teradata_nativesql}{fn teradata_get_errors}", sInsert)
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = FALSE)

				sRequest <- paste0 ("SELECT id, name, address, city FROM ", sTableName, " ORDER BY 1")
				cat (paste0 (sRequest, "\n"))
				print (DBI::dbGetQuery (con, sRequest), right = TRUE, row.names = FALSE)

			}, finally = {

				sRequest <- paste0 ("DROP TABLE ", sTableName)
				cat (paste0 (sRequest, "\n"))
				tryCatch ({
					DBI::dbExecute (con, sRequest)
				}, error = function (e) {
					cat (paste0 ("Ignoring ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
				})

			}) # end finally

		}, finally = {
			cat (paste0 ("file.remove(", jsonFileName, ")\n"))
			tryCatch ({
				file.remove (jsonFileName)
			}, error = function (e) {
				cat (paste0 ("file.remove failed: ", e, "\n"))
			})
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
