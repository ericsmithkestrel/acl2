; Ethereum Library -- Nibbles
;
; Copyright (C) 2018 Kestrel Institute (http://www.kestrel.edu)
;
; License: A 3-clause BSD license. See the LICENSE file distributed with ACL2.
;
; Author: Alessandro Coglio (coglio@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ETHEREUM")

(include-book "kestrel/utilities/fixbytes/defbytelist" :dir :system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defxdoc nibbles
  :parents (basics)
  :short "Nibbles."
  :long
  (xdoc::topp
   "[YP:C] describes @($\\mathbb{Y}$) as the set of nibbles,
    which consist of 4 bits."))

(fty::defbyte 4
  :type nibble
  :pred nibblep
  :parents (nibbles)
  :description "nibbles")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defxdoc nibble-arrays
  :parents (basics)
  :short "Nibble arrays."
  :long
  (xdoc::topp
   "[YP] does not use any specific symbol for nibble arrays
    (unlike for byte arrays),
    but nibble arrays are used in [YP],
    e.g. @($y$) [YP:(190), YP:(191)] turns map keys as byte arrays
    into map keys as nibble arrays.
    We use true lists of @(see nibbles)
    to model nibble arrays in our Ethereum model,
    analogously to our model of
    <see topic='@(url byte-arrays)'>byte arrays</see>."))

(fty::defbytelist nibble
  :pred nibble-listp
  :parents (nibble-arrays))
