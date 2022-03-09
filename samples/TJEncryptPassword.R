# Copyright 2020 by Teradata Corporation. All Rights Reserved.
#
#   File:       TJEncryptPassword.R
#   Purpose:    Encrypts a password, saves the encryption key in one file, and saves the encrypted password in a second file
#
#               This program accepts eight command-line arguments:
#
#                 1. Transformation - Specifies the transformation in the form Algorithm/Mode/Padding.
#                                     Example: AES/CBC/NoPadding
#
#                 2. KeySizeInBits  - Specifies the algorithm key size, which governs the encryption strength.
#                                     Example: 256
#
#                 3. MAC            - Specifies the message authentication code (MAC) algorithm HmacSHA1 or HmacSHA256.
#                                     Example: HmacSHA256
#
#                 4. PasswordEncryptionKeyFileName - Specifies a filename in the current directory, a relative pathname, or an absolute pathname.
#                                     The file is created by this program. If the file already exists, it will be overwritten by the new file.
#                                     Example: PassKey.properties
#
#                 5. EncryptedPasswordFileName - Specifies a filename in the current directory, a relative pathname, or an absolute pathname.
#                                     The filename or pathname that must differ from the PasswordEncryptionKeyFileName.
#                                     The file is created by this program. If the file already exists, it will be overwritten by the new file.
#                                     Example: EncPass.properties
#
#                 6. Hostname       - Specifies the Teradata Database hostname.
#                                     Example: whomooz
#
#                 7. Username       - Specifies the Teradata Database username.
#                                     Example: guest
#
#                 8. Password       - Specifies the Teradata Database password to be encrypted.
#                                     Unicode characters in the password can be specified with the backslash uXXXX escape sequence.
#                                     Example: please
#
#               Overview
#               --------
#
#               Stored Password Protection enables an application to provide a connection password in encrypted form to
#               the Teradata SQL Driver for R.
#
#               An encrypted password may be specified in the following contexts:
#                 * A login password specified as the "password" connection parameter.
#                 * A login password specified within the "logdata" connection parameter.
#
#               If the password, however specified, begins with the prefix "ENCRYPTED_PASSWORD(" then the specified password must follow this format:
#
#                 ENCRYPTED_PASSWORD(file:PasswordEncryptionKeyFileName,file:EncryptedPasswordFileName)
#
#               Each filename must be preceded by the "file:"" prefix.
#               The PasswordEncryptionKeyFileName must be separated from the EncryptedPasswordFileName by a single comma.
#               The PasswordEncryptionKeyFileName specifies the name of a properties file that contains the password encryption key and associated information.
#               The EncryptedPasswordFileName specifies the name of a properties file that contains the encrypted password and associated information.
#               The two files are described below.
#
#               Stored Password Protection is offered by the Teradata JDBC Driver and the Teradata SQL Driver for R.
#               The same file format is used by both drivers.
#
#               This program works in conjunction with Stored Password Protection offered by the Teradata JDBC Driver and the
#               Teradata SQL Driver for R. This program creates the files containing the password encryption key and encrypted password,
#               which can be subsequently specified via the "ENCRYPTED_PASSWORD(" syntax.
#
#               You are not required to use this program to create the files containing the password encryption key and encrypted password.
#               You can develop your own software to create the necessary files.
#               The only requirement is that the files must match the format expected by the Teradata SQL Driver for R, which is documented below.
#
#               This program encrypts the password and then immediately decrypts the password, in order to verify that the password can be
#               successfully decrypted. This program mimics the password decryption of the Teradata SQL Driver for R, and is intended
#               to openly illustrate its operation and enable scrutiny by the community.
#
#               The encrypted password is only as safe as the two files. You are responsible for restricting access to the files containing
#               the password encryption key and encrypted password. If an attacker obtains both files, the password can be decrypted.
#               The operating system file permissions for the two files should be as limited and restrictive as possible, to ensure that
#               only the intended operating system userid has access to the files.
#
#               The two files can be kept on separate physical volumes, to reduce the risk that both files might be lost at the same time.
#               If either or both of the files are located on a network volume, then an encrypted wire protocol can be used to access the
#               network volume, such as sshfs, encrypted NFSv4, or encrypted SMB 3.0.
#
#               Example Commands
#               ----------------
#
#               This program uses the Teradata SQL Driver for R to log on to the specified Teradata Database using the encrypted
#               password, so the Teradata SQL Driver for R must have been installed with the following command.
#
#               Rscript -e "install.packages('teradatasql',repos=c('https://teradata-download.s3.amazonaws.com','https://cloud.r-project.org'))"
#
#               The following commands assume this program file is located in the current directory.
#               When the Teradata SQL Driver for R is installed, the sample programs are placed in the teradatasql/samples
#               directory under your R library directory.
#               Change your current directory to the teradatasql/samples directory under your R library directory.
#
#               The following example command illustrates using a 256-bit AES key, and using the HmacSHA256 algorithm.
#
#               Rscript TJEncryptPassword.R AES/CBC/NoPadding 256 HmacSHA256 PassKey.properties EncPass.properties whomooz guest please
#
#               Password Encryption Key File Format
#               -----------------------------------
#
#               You are not required to use the TJEncryptPassword program to create the files containing the password encryption key and
#               encrypted password. You can develop your own software to create the necessary files, but the files must match the format
#               expected by the Teradata SQL Driver for R.
#
#               The password encryption key file is a text file in Java Properties file format, using the ISO 8859-1 character encoding.
#
#               The file must contain the following string properties:
#
#                 version=1
#
#                       The version number must be 1.
#                       This property is required.
#
#                 transformation=TransformationName
#
#                       Specifies the transformation in the form Algorithm/Mode/Padding.
#                       This property is required.
#                       Example: AES/CBC/NoPadding
#
#                 algorithm=AlgorithmName
#
#                       This value must correspond to the Algorithm portion of the transformation.
#                       This property is required.
#                       Example: AES
#
#                 match=MatchValue
#
#                       The password encryption key and encrypted password files must contain the same match value.
#                       The match values are compared to ensure that the two specified files are related to each other,
#                       serving as a "sanity check" to help avoid configuration errors.
#                       This property is required.
#
#                       This program uses a timestamp as a shared match value, but a timestamp is not required.
#                       Any shared string can serve as a match value. The timestamp is not related in any way to
#                       the encryption of the password, and the timestamp cannot be used to decrypt the password.
#
#                 key=HexDigits
#
#                       This value is the password encryption key, encoded as hex digits.
#                       This property is required.
#
#                 mac=MACAlgorithmName
#
#                       Specifies the message authentication code (MAC) algorithm HmacSHA1 or HmacSHA256.
#                       Stored Password Protection performs Encrypt-then-MAC for protection from a padding oracle attack.
#                       This property is required.
#
#                 mackey=HexDigits
#
#                       This value is the MAC key, encoded as hex digits.
#                       This property is required.
#
#               Encrypted Password File Format
#               ------------------------------
#
#               The encrypted password file is a text file in Java Properties file format, using the ISO 8859-1 character encoding.
#
#               The file must contain the following string properties:
#
#                 version=1
#
#                       The version number must be 1.
#                       This property is required.
#
#                 match=MatchValue
#
#                       The password encryption key and encrypted password files must contain the same match value.
#                       The match values are compared to ensure that the two specified files are related to each other,
#                       serving as a "sanity check" to help avoid configuration errors.
#                       This property is required.
#
#                       This program uses a timestamp as a shared match value, but a timestamp is not required.
#                       Any shared string can serve as a match value. The timestamp is not related in any way to
#                       the encryption of the password, and the timestamp cannot be used to decrypt the password.
#
#                 password=HexDigits
#
#                       This value is the encrypted password, encoded as hex digits.
#                       This property is required.
#
#                 params=HexDigits
#
#                       This value contains the cipher algorithm parameters, if any, encoded as hex digits.
#                       Some ciphers need algorithm parameters that cannot be derived from the key, such as an initialization vector.
#                       This property is optional, depending on whether the cipher algorithm has associated parameters.
#
#                       While this value is technically optional, an initialization vector is required by all three
#                       block cipher modes CBC, CFB, and OFB that are supported by the Teradata SQL Driver for R.
#                       ECB (Electronic Codebook) does not require params, but ECB is not supported by the Teradata SQL Driver for R.
#
#                 hash=HexDigits
#
#                       This value is the expected message authentication code (MAC), encoded as hex digits.
#                       After encryption, the expected MAC is calculated using the ciphertext, transformation name, and algorithm parameters if any.
#                       Before decryption, the Teradata SQL Driver for R calculates the MAC using the ciphertext, transformation name,
#                       and algorithm parameters, if any, and verifies that the calculated MAC matches the expected MAC.
#                       If the calculated MAC differs from the expected MAC, then either or both of the files may have been tampered with.
#                       This property is required.
#
#               Transformation, Key Size, and MAC
#               ---------------------------------
#
#               A transformation is a string that describes the set of operations to be performed on the given input, to produce transformed output.
#               A transformation specifies the name of a cryptographic algorithm such as DES or AES, followed by a feedback mode and padding scheme.
#
#               The Teradata SQL Driver for R supports the following transformations and key sizes.
#               However, this program only supports AES with CBC or CFB, as indicated by asterisks below.
#
#                  DES/CBC/NoPadding          64
#                  DES/CBC/PKCS5Padding       64
#                  DES/CFB/NoPadding          64
#                  DES/CFB/PKCS5Padding       64
#                  DES/OFB/NoPadding          64
#                  DES/OFB/PKCS5Padding       64
#                  DESede/CBC/NoPadding       192
#                  DESede/CBC/PKCS5Padding    192
#                  DESede/CFB/NoPadding       192
#                  DESede/CFB/PKCS5Padding    192
#                  DESede/OFB/NoPadding       192
#                  DESede/OFB/PKCS5Padding    192
#                  AES/CBC/NoPadding          128 *
#                  AES/CBC/NoPadding          192 *
#                  AES/CBC/NoPadding          256 *
#                  AES/CBC/PKCS5Padding       128 *
#                  AES/CBC/PKCS5Padding       192 *
#                  AES/CBC/PKCS5Padding       256 *
#                  AES/CFB/NoPadding          128 *
#                  AES/CFB/NoPadding          192 *
#                  AES/CFB/NoPadding          256 *
#                  AES/CFB/PKCS5Padding       128 *
#                  AES/CFB/PKCS5Padding       192 *
#                  AES/CFB/PKCS5Padding       256 *
#                  AES/OFB/NoPadding          128
#                  AES/OFB/NoPadding          192
#                  AES/OFB/NoPadding          256
#                  AES/OFB/PKCS5Padding       128
#                  AES/OFB/PKCS5Padding       192
#                  AES/OFB/PKCS5Padding       256
#
#               Stored Password Protection uses a symmetric encryption algorithm such as DES or AES, in which the same secret key is used for
#               encryption and decryption of the password. Stored Password Protection does not use an asymmetric encryption algorithm such as RSA,
#               with separate public and private keys.
#
#               CBC (Cipher Block Chaining) is a block cipher encryption mode. With CBC, each ciphertext block is dependent on all plaintext blocks
#               processed up to that point. CBC is suitable for encrypting data whose total byte count exceeds the algorithm's block size, and is
#               therefore suitable for use with Stored Password Protection.
#
#               Stored Password Protection hides the password length in the encrypted password file by extending the length of the UTF8-encoded
#               password with trailing null bytes. The length is extended to the next 512-byte boundary.
#
#               A block cipher with no padding, such as AES/CBC/NoPadding, may only be used to encrypt data whose byte count after extension is
#               a multiple of the algorithm's block size. The 512-byte boundary is compatible with many block ciphers. AES, for example, has a
#               block size of 128 bits (16 bytes), and is therefore compatible with the 512-byte boundary.
#
#               A block cipher with padding, such as AES/CBC/PKCS5Padding, can be used to encrypt data of any length. However, CBC with padding
#               is vulnerable to a "padding oracle attack", so Stored Password Protection performs Encrypt-then-MAC for protection from a padding
#               oracle attack. MAC algorithms HmacSHA1 and HmacSHA256 are supported.
#
#               The Teradata SQL Driver for R does not support block ciphers used as byte-oriented ciphers via modes such as CFB8 or OFB8.
#
#               The strength of the encryption depends on your choice of cipher algorithm and key size.
#
#               AES uses a 128-bit (16 byte), 192-bit (24 byte), or 256-bit (32 byte) key.
#               DESede uses a 192-bit (24 byte) key. The The Teradata SQL Driver for Python does not support a 128-bit (16 byte) key for DESede.
#               DES uses a 64-bit (8 byte) key.
#
#               Sharing Files with the Teradata JDBC Driver
#               -------------------------------------------
#
#               The Teradata SQL Driver for R and the Teradata JDBC Driver can share the files containing the password encryption key and
#               encrypted password, if you use a transformation, key size, and MAC algorithm that is supported by both drivers.
#
#               Recommended choices for compatibility are AES/CBC/NoPadding and HmacSHA256.
#               Use a 256-bit key if your Java environment has the Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files
#               from Oracle.
#               Use a 128-bit key if your Java environment does not have the Unlimited Strength Jurisdiction Policy Files.
#               Use HmacSHA1 for compatibility with JDK 1.4.2.
#
#               File Locations
#               --------------
#
#               For the "ENCRYPTED_PASSWORD(" syntax of the Teradata SQL Driver for R, each filename must be preceded by the file: prefix.
#               The PasswordEncryptionKeyFileName must be separated from the EncryptedPasswordFileName by a single comma.
#               The files can be located in the current directory, specified with a relative path, or specified with an absolute path.
#
#               Example for files in the current directory:
#
#                   ENCRYPTED_PASSWORD(file:JohnDoeKey.properties,file:JohnDoePass.properties)
#
#               Example with relative paths:
#
#                   ENCRYPTED_PASSWORD(file:../dir1/JohnDoeKey.properties,file:../dir2/JohnDoePass.properties)
#
#               Example with absolute paths on Windows:
#
#                   ENCRYPTED_PASSWORD(file:c:/dir1/JohnDoeKey.properties,file:c:/dir2/JohnDoePass.properties)
#
#               Example with absolute paths on Linux:
#
#                   ENCRYPTED_PASSWORD(file:/dir1/JohnDoeKey.properties,file:/dir2/JohnDoePass.properties)

options (warn = 2) # convert warnings to errors
options (warning.length = 8000L)
options (width = 1000)

j2r <- function (sName) { # convert Java names to R names

	if (startsWith (sName, "Hmac")) {
		return (tolower (substr (sName, 5, nchar (sName))))
	}

	return (sName)

} # end j2r

createPasswordEncryptionKeyFile <- function (sTransformation, sAlgorithm, sMode, sPadding, nKeySizeInBits, sMatch, sMac, sPassKeyFileName) {

	nKeySizeInBytes <- nKeySizeInBits %/% 8

	abyKey <- teradatasql::getRandomBytes (teradatasql::TeradataDriver (), nKeySizeInBytes)
	sKeyHexDigits <- paste0 (abyKey, collapse = "")

	nMacBlockSizeInBytes <- 64 # SHA block size is 64 bytes

	abyMacKey <- teradatasql::getRandomBytes (teradatasql::TeradataDriver (), nMacBlockSizeInBytes)
	sMacKeyHexDigits <- paste0 (abyMacKey, collapse = "")

	cat (paste0 (
		"# Teradata SQL Driver password encryption key file\n",
		"version=1\n",
		"transformation=", sTransformation, "\n",
		"algorithm=", sAlgorithm, "\n",
		"match=", sMatch, "\n",
		"key=", sKeyHexDigits, "\n",
		"mac=", sMac, "\n",
		"mackey=", sMacKeyHexDigits, "\n"),
		file = sPassKeyFileName)

	return (list ("abyKey" = abyKey, "abyMacKey" = abyMacKey))

} # end createPasswordEncryptionKeyFile

createEncryptedPasswordFile <- function (sTransformation, sAlgorithm, sMode, sPadding, sMatch, abyKey, sMac, abyMacKey, sEncPassFileName, sPassword) {

	bPadding <- sPadding == "PKCS5Padding"

	nBlockSizeInBytes <- 16 # AES block size is 16 bytes
	abyIV <- teradatasql::getRandomBytes (teradatasql::TeradataDriver (), nBlockSizeInBytes)

	abyASN1EncodedIV <- asn1Encode (abyIV)
	sASN1EncodedIVHexDigits <- paste0 (abyASN1EncodedIV, collapse = "")

	cipher <- digest::AES (abyKey, mode = sMode, IV = abyIV)

	abyPassword <- charToRaw (sPassword)

	nPlaintextByteCount <- (length (abyPassword) %/% 512 + 1) * 512 # zero-pad the password to the next 512-byte boundary

	nTrailerByteCount <- nPlaintextByteCount - length (abyPassword)
	abyPassword <- c (abyPassword, raw (nTrailerByteCount))

	if (bPadding) {
		abyPassword <- addPKCS5Padding (abyPassword, nBlockSizeInBytes)
	}

	abyEncryptedPassword <- cipher$encrypt (abyPassword)
	sEncryptedPasswordHexDigits <- paste (abyEncryptedPassword, collapse="")

	abyContent <- c (abyEncryptedPassword, charToRaw (sTransformation), abyASN1EncodedIV)

	sHashHexDigits <- digest::hmac (abyMacKey, abyContent, algo = j2r (sMac))

	cat (paste0 (
		"# Teradata SQL Driver encrypted password file\n",
		"version=1\n",
		"match=", sMatch, "\n",
		"password=", sEncryptedPasswordHexDigits, "\n",
		"params=", sASN1EncodedIVHexDigits, "\n",
		"hash=", sHashHexDigits, "\n"),
		file = sEncPassFileName)

} # end createEncryptedPasswordFile

loadPropertiesFile <- function (sFileName) {

	asLines <- readLines (sFileName, encoding = "iso-8859-1")
	asLines <- trimws (asLines)
	asLines <- asLines [! startsWith (asLines, "#")]
	mapOutput <- list ()

	for (nLine in seq_along (asLines)) {

			asTokens <- unlist (strsplit (asLines [[nLine]], "="))
			sKey <- trimws (asTokens [[1]])
			sValue <- ifelse (length (asTokens) == 2, trimws (asTokens [[2]]), "")
			mapOutput [[sKey]] <- sValue

	} # end for

	return (mapOutput)

} # end loadPropertiesFile

decryptPassword <- function (sPassKeyFileName, sEncPassFileName) {

	mapPassKey <- loadPropertiesFile (sPassKeyFileName)
	mapEncPass <- loadPropertiesFile (sEncPassFileName)

	if (mapPassKey$version != 1) {
		stop (paste0 ("Unrecognized version ", mapPassKey$version, " in file ", sPassKeyFileName))
	}

	if (mapEncPass$version != 1) {
		stop (paste0 ("Unrecognized version ", mapEncPass$version , " in file ", sEncPassFileName))
	}

	if (mapPassKey$match != mapEncPass$match) {
		stop (paste0 ("Match value differs between files ", sPassKeyFileName, " and ", sEncPassFileName))
	}

	sTransformation  <- mapPassKey$transformation
	sAlgorithm       <- mapPassKey$algorithm
	sKeyHexDigits    <- mapPassKey$key
	sMACAlgorithm    <- mapPassKey$mac
	sMacKeyHexDigits <- mapPassKey$mackey

	asTransformationParts <- unlist (strsplit (sTransformation, "/"))

	sMode      <- asTransformationParts [[2]]
	sPadding   <- asTransformationParts [[3]]

	if (sAlgorithm != asTransformationParts [[1]]) {
		stop (paste0 ("Algorithm differs from transformation in file ", sPassKeyFileName))
	}

	bPadding <- sPadding == "PKCS5Padding"

	# While params is technically optional, an initialization vector is required by all three block
		# cipher modes CBC, CFB, and OFB that are supported by the Teradata SQL Driver for R.
	# ECB does not require params, but ECB is not supported by the Teradata SQL Driver for R.

	sEncryptedPasswordHexDigits <- mapEncPass$password
	sASN1EncodedIVHexDigits     <- mapEncPass$params # required for CBC, CFB, and OFB
	sHashHexDigits              <- mapEncPass$hash

	abyKey               <- hexDigitsToRaw (sKeyHexDigits)
	abyMacKey            <- hexDigitsToRaw (sMacKeyHexDigits)
	abyEncryptedPassword <- hexDigitsToRaw (sEncryptedPasswordHexDigits)
	abyASN1EncodedIV     <- hexDigitsToRaw (sASN1EncodedIVHexDigits)

	abyContent <- c (abyEncryptedPassword, charToRaw (sTransformation), abyASN1EncodedIV)

	hash <- digest::hmac (abyMacKey, abyContent, algo = j2r (sMACAlgorithm))

	if (sHashHexDigits != hash) {
		stop (paste0 ("Hash mismatch indicates possible tampering with file ", sPassKeyFileName, " or ", sEncPassFileName))
	}

	nKeySizeInBytes <- length (abyKey)
	nKeySizeInBits  <- nKeySizeInBytes * 8

	cat (paste0 (sPassKeyFileName, " specifies ", sTransformation, " with ", nKeySizeInBits, "-bit key and ", sMACAlgorithm, "\n"))

	abyIV <- asn1Decode (abyASN1EncodedIV)

	cipher <- digest::AES (abyKey, mode = sMode, IV = abyIV)

	abyPassword <- cipher$decrypt (abyEncryptedPassword, raw = TRUE)

	if (bPadding) {
		abyPassword <- removePKCS5Padding (abyPassword)
	}

	iZeroByte <- match (raw (1), abyPassword)
	abyPassword <- abyPassword [1 : iZeroByte - 1] # remove trailing zero-byte padding

	sPassword <- stringi::stri_encode (abyPassword, from = "UTF-8", to = "UTF-8")

	cat (paste0 ("Decrypted password: ", sPassword, "\n"))

	return (sPassword)

} # end decryptPassword

hexDigitsToRaw <- function (sHexDigits) {

	return (as.raw (strtoi (substring (sHexDigits, seq (1, nchar (sHexDigits), by = 2), seq (2, nchar (sHexDigits), by = 2)), 16)))

} # end hexDigitsToRaw

asn1Encode <- function (abyDigits) {

	return (c (as.raw (4), as.raw (length (abyDigits)), abyDigits))

} # end asn1Encode

asn1Decode <- function (abyEncoded) {

	return (abyEncoded [3 : length (abyEncoded)])

} # end asn1Decode

addPKCS5Padding <- function (abyData, nBlockSize) {

	nPaddedDataLength <- (length (abyData) %/% nBlockSize + 1) * nBlockSize
	nPadCount <- nPaddedDataLength - length (abyData)
	abyPad <- as.raw (seq (nPadCount, nPadCount, length = nPadCount))
	return (c (abyData, abyPad))

} # end addPKCS5Padding

removePKCS5Padding <- function (abyPaddedData) {

	nPadCount <- as.integer (abyPaddedData [length (abyPaddedData)])
	return (abyPaddedData [1 : (length (abyPaddedData) - nPadCount)])

} # end removePKCS5Padding

main <- function () {

	args <- commandArgs (trailingOnly = TRUE)

	if (length (args) != 8) {
		stop ("Parameters: Transformation KeySizeInBits MAC PasswordEncryptionKeyFileName EncryptedPasswordFileName Hostname Username Password\n")
	}

	sTransformation  <- args [1]
	sKeySizeInBits   <- args [2]
	sMac             <- args [3]
	sPassKeyFileName <- args [4]
	sEncPassFileName <- args [5]
	sHostname        <- args [6]
	sUsername        <- args [7]
	sPassword        <- args [8]

	asTransformationParts <- unlist (strsplit (sTransformation, "/"))
	if (length (asTransformationParts) != 3) {
		stop (paste0 ("Invalid transformation ", sTransformation))
	}

	sAlgorithm <- asTransformationParts [1]
	sMode      <- asTransformationParts [2]
	sPadding   <- asTransformationParts [3]

	if (! sAlgorithm %in% c ("AES")) {
		stop (paste0 ("Unknown algorithm ", sAlgorithm))
	}

	if (! sMode %in% c ("CBC", "CFB")) {
		stop (paste0 ("Unknown mode ", sMode))
	}

	if (! sPadding %in% c ("PKCS5Padding", "NoPadding")) {
		stop (paste0 ("Unknown padding ", sPadding))
	}

	if (! sMac %in% c ("HmacSHA1", "HmacSHA256")) {
		stop (paste0 ("Unknown MAC algorithm ", sMac))
	}

	if (sPassword == "") {
		stop ("Password cannot be zero length")
	}

	sPassword <- stringi::stri_unescape_unicode (sPassword) # for backslash uXXXX escape sequences

	nKeySizeInBits <- as.numeric (sKeySizeInBits)

	sMatch <- strftime (Sys.time (),"%Y-%m-%d.%H:%M:%OS3")

	keys <- createPasswordEncryptionKeyFile (sTransformation, sAlgorithm, sMode, sPadding, nKeySizeInBits, sMatch, sMac, sPassKeyFileName)

	createEncryptedPasswordFile (sTransformation, sAlgorithm, sMode, sPadding, sMatch, keys$abyKey, sMac, keys$abyMacKey, sEncPassFileName, sPassword)

	decryptPassword (sPassKeyFileName, sEncPassFileName)

	sPassword <- paste0 ("ENCRYPTED_PASSWORD(file:", sPassKeyFileName, ",file:", sEncPassFileName, ")")

	con <- DBI::dbConnect (teradatasql::TeradataDriver (), host = sHostname, user = sUsername, password = sPassword)

	tryCatch ({

		df <- DBI::dbGetQuery (con, "select user, session")
		print (df)

	}, finally = {

		DBI::dbDisconnect (con)

	}) # end finally

} # end main

withCallingHandlers (main (), error = function (e) {
	listStackFrames <- head (tail (sys.calls (), -1), -2) # omit first one and last two
	nStackFrameCount <- length (listStackFrames)
	cat (paste0 ("[", 1 : nStackFrameCount, "/", nStackFrameCount, "] ", listStackFrames, "\n\n", collapse = ""))
})
