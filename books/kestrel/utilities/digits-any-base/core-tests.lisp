; Representation of Natural Numbers as Digits in Arbitrary Bases -- Tests
;
; Copyright (C) 2018 Kestrel Institute (http://www.kestrel.edu)
;
; License: A 3-clause BSD license. See the LICENSE file distributed with ACL2.
;
; Author: Alessandro Coglio (coglio@kestrel.edu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package "ACL2")

(include-book "core")
(include-book "kestrel/utilities/testing" :dir :system)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert! (not (dab-basep 0)))

(assert! (not (dab-basep 1)))

(assert! (dab-basep 2))

(assert! (dab-basep 8))

(assert! (dab-basep 10))

(assert! (dab-basep 16))

(assert! (dab-basep 60))

(assert! (not (dab-basep "10")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defthm dab-base-fix-test1
  (equal (dab-base-fix 0) 2))

(defthm dab-base-fix-test2
  (equal (dab-base-fix 1) 2))

(defthm dab-base-fix-test3
  (equal (dab-base-fix "10") 2))

(assert-equal (dab-base-fix 2) 2)

(assert-equal (dab-base-fix 8) 8)

(assert-equal (dab-base-fix 10) 10)

(assert-equal (dab-base-fix 16) 16)

(assert-equal (dab-base-fix 60) 60)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert! (not (dab-digitp 10 #\8)))

(assert! (not (dab-digitp 2 -1)))

(assert! (dab-digitp 10 8))

(assert! (dab-digitp 256 255))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defthm dab-digit-fix-test1
  (equal (dab-digit-fix 10 #\8) 0))

(defthm dab-digit-fix-test2
  (equal (dab-digit-fix 2 -1) 0))

(assert-equal (dab-digit-fix 10 8) 8)

(assert-equal (dab-digit-fix 256 255) 255)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert! (not (dab-digit-listp 12 5)))

(assert! (not (dab-digit-listp 16 '(10 11 "12"))))

(assert! (not (dab-digit-listp 20 '(4 0 20 10 -1))))

(assert! (dab-digit-listp 10 nil))

(assert! (dab-digit-listp 10 '(6 4 3 0)))

(assert! (dab-digit-listp 2 '(1 1 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defthm dab-digit-list-fix-test1
  (equal (dab-digit-list-fix 12 5) nil))

(defthm dab-digit-list-fix-test2
  (equal (dab-digit-list-fix 16 '(10 11 "12")) '(10 11 0)))

(defthm dab-digit-list-fix-test3
  (equal (dab-digit-list-fix 20 '(4 0 20 10 -1)) '(4 0 0 10 0)))

(assert-equal (dab-digit-list-fix 10 nil) nil)

(assert-equal (dab-digit-list-fix 10 '(6 4 3 0)) '(6 4 3 0))

(assert-equal (dab-digit-list-fix 2 '(1 1 0)) '(1 1 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (lendian=>nat 10 nil) 0)

(assert-equal (lendian=>nat 10 '(3 6 4)) 463)

(assert-equal (lendian=>nat 2 '(1 0 1 1)) 13)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (nat=>lendian* 10 0) nil)

(assert-equal (nat=>lendian* 10 86373) '(3 7 3 6 8))

(assert-equal (nat=>lendian* 16 240) '(0 15))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (nat=>lendian+ 10 0) '(0))

(assert-equal (nat=>lendian+ 10 86373) '(3 7 3 6 8))

(assert-equal (nat=>lendian+ 16 240) '(0 15))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (nat=>lendian 10 5 0) '(0 0 0 0 0))

(assert-equal (nat=>lendian 10 5 86373) '(3 7 3 6 8))

(assert-equal (nat=>lendian 16 4 240) '(0 15 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (bendian=>nat 10 nil) 0)

(assert-equal (bendian=>nat 10 '(4 6 3)) 463)

(assert-equal (bendian=>nat 2 '(1 1 0 1)) 13)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (nat=>bendian* 10 0) nil)

(assert-equal (nat=>bendian* 10 86373) '(8 6 3 7 3))

(assert-equal (nat=>bendian* 16 240) '(15 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (nat=>bendian+ 10 0) '(0))

(assert-equal (nat=>bendian+ 10 86373) '(8 6 3 7 3))

(assert-equal (nat=>bendian+ 16 240) '(15 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (nat=>bendian 10 5 0) '(0 0 0 0 0))

(assert-equal (nat=>bendian 10 5 86373) '(8 6 3 7 3))

(assert-equal (nat=>bendian 16 4 240) '(0 0 15 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (trim-bendian* '(0 0 8 7 5)) '(8 7 5))

(assert-equal (trim-bendian* '(8 7 5)) '(8 7 5))

(assert-equal (trim-bendian* '(8 0 0)) '(8 0 0))

(assert-equal (trim-bendian* '(0 0)) nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (trim-lendian* '(1 1 0)) '(1 1))

(assert-equal (trim-lendian* '(0 1)) '(0 1))

(assert-equal (trim-lendian* '(0 0)) nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (trim-bendian+ '(0 0 8 7 5)) '(8 7 5))

(assert-equal (trim-bendian+ '(8 7 5)) '(8 7 5))

(assert-equal (trim-bendian+ '(8 0 0)) '(8 0 0))

(assert-equal (trim-bendian+ '(0 0)) '(0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(assert-equal (trim-lendian+ '(1 1 0)) '(1 1))

(assert-equal (trim-lendian+ '(0 1)) '(0 1))

(assert-equal (trim-lendian+ '(0 0)) '(0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; test DEFTHM-DAB-RETURN-TYPES:

(defun hexdigitp (x) ; = (DAB-DIGITP 16 X)
  (declare (xargs :guard t))
  (integer-range-p 0 16 x))

(std::deflist hexdigit-listp (x) ; = (DAB-DIGIT-LISTP 16 X) -- see below
  (hexdigitp x)
  :true-listp t
  :elementp-of-nil nil)

(defthmd equality ; equality theorem
  (equal (dab-digit-listp 16 x)
         (hexdigit-listp x))
  :hints (("Goal" :in-theory (enable dab-digit-listp dab-digitp))))

(defmacro check-redundant-theorems () ; check generated theorems
  '(must-be-redundant
    (progn
      (defthm hexdigit-listp-of-nat=>bendian*
        (hexdigit-listp (nat=>bendian* 16 nat)))
      (defthm hexdigit-listp-of-nat=>bendian+
        (hexdigit-listp (nat=>bendian+ 16 nat)))
      (defthm hexdigit-listp-of-nat=>bendian
        (hexdigit-listp (nat=>bendian 16 width nat)))
      (defthm hexdigit-listp-of-nat=>lendian*
        (hexdigit-listp (nat=>lendian* 16 nat)))
      (defthm hexdigit-listp-of-nat=>lendian+
        (hexdigit-listp (nat=>lendian+ 16 nat)))
      (defthm hexdigit-listp-of-nat=>lendian
        (hexdigit-listp (nat=>lendian 16 width nat))))))

(must-succeed*
 (defthm-dab-return-types equality hexdigit-listp-of)
 (check-redundant-theorems))

(must-succeed*
 (defthm-dab-return-types equality hexdigit-listp-of
   :topic nat-hexdigits-return-types)
 (check-redundant-theorems))

(must-succeed*
 (defthm-dab-return-types equality hexdigit-listp-of
   :topic nat-hexdigits-return-types
   :parents (digits-any-base))
 (check-redundant-theorems))

(must-succeed*
 (defthm-dab-return-types equality hexdigit-listp-of
   :topic nat-hexdigits-return-types
   :parents (digits-any-base)
   :short "Additional return type theorems.")
 (check-redundant-theorems))

(must-succeed*
 (defthm-dab-return-types equality hexdigit-listp-of
   :topic nat-hexdigits-return-types
   :short "Additional return type theorems.")
 (check-redundant-theorems))

(must-succeed*
 (defthm-dab-return-types equality hexdigit-listp-of
   :topic nat-hexdigits-return-types
   :parents (digits-any-base)
   :short "Additional return type theorems."
   :long "<p>These are for hexadecimal digits.</p>")
 (check-redundant-theorems))

(must-succeed*
 (defthm-dab-return-types equality hexdigit-listp-of
   :topic nat-hexdigits-return-types
   :short "Additional return type theorems."
   :long "<p>These are for hexadecimal digits.</p>")
 (check-redundant-theorems))
