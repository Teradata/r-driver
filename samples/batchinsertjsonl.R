# Copyright 2026 by Teradata Corporation. All Rights Reserved.

# This sample program demonstrates how to insert a batch using a JSONL file

options (warn = 2)
options (warning.length = 8000L)
options (width = 1000)

main <- function () {

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = "jdbc2000ek2", user = "guest", password = "please")

	tryCatch ({

		jsonlFileName <- "dataBatchR.jsonl"
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

			sRequest <- "create volatile table voltab (c1 INTEGER NOT NULL, c2 VARCHAR(10), c3 VECTOR) on commit preserve rows"
			cat (paste0 (sRequest, "\n"))
			DBI::dbExecute (con, sRequest)

			sInsert <- paste0 ("{fn teradata_read_jsonl(", jsonlFileName,")} INSERT INTO voltab (c1, c2, c3) VALUES (?, ?, ?)")
			cat (paste0 (sInsert, "\n"))
			DBI::dbExecute (con, sInsert)

		}, finally = {
			cat (paste0 ("file.remove(", jsonlFileName, ")\n"))
			file.remove (jsonlFileName)
		})

		sRequest <- "SELECT c1, c2, c3 FROM voltab ORDER BY 1"
		cat (paste0 (sRequest, "\n"))
		df <- DBI::dbGetQuery (con, sRequest)
		df$c3 <- lapply (df$c3, function (x) readBin (x, what = "double", n = length (x) / 8L, size = 8L, endian = "little"))
		print (df, right = TRUE, row.names = FALSE)

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
