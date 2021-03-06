; String Utilities -- Conversions between Strings and Character Codes
;
; Copyright (C) 2018 Kestrel Institute (http://www.kestrel.edu)
;
; License: A 3-clause BSD license. See the LICENSE file distributed with ACL2.
;
; Author: Alessandro Coglio (coglio@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(include-book "std/strings/coerce" :dir :system)

(include-book "chars-codes")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defxdoc string-codelist-conversions
  :parents (string-utilities)
  :short "Conversions between strings and lists of character codes.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define nats=>string ((nats (unsigned-byte-listp 8 nats)))
  :returns (string stringp)
  :parents (string-codelist-conversions)
  :short "Convert a true list of natural numbers below 256
          to the corresponding string."
  (implode (nats=>chars nats))
  ///

  (defrule nth-of-explode-of-nats=>string
    (equal (nth i (explode (nats=>string nats)))
           (if (< (nfix i) (len nats))
               (code-char (nth i nats))
             nil)))

  (defrule len-of-explode-of-nats=>string
    (equal (len (explode (nats=>string nats)))
           (len nats))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define string=>nats ((string stringp))
  :returns (nats (unsigned-byte-listp 8 nats))
  :parents (string-codelist-conversions)
  :short "Convert a string
          to the corresponding true list of natural numbers below 256."
  (chars=>nats (explode string))
  ///

  (more-returns
   (nats nat-listp
         :name nat-listp-of-string=>nats))

  (defrule len-of-string=>nats
    (implies (stringp string)
             (equal (len (string=>nats string))
                    (length string)))))
