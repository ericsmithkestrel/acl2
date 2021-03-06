; Centaur Books -- Recommended CCL Configuration
; Copyright (C) 2008-2012 Centaur Technology
;
; Contact:
;   Centaur Technology Formal Verification Group
;   7600-C N. Capital of Texas Highway, Suite 300, Austin, TX 78731, USA.
;   http://www.centtech.com/
;
; License: (An MIT/X11-style license)
;
;   Permission is hereby granted, free of charge, to any person obtaining a
;   copy of this software and associated documentation files (the "Software"),
;   to deal in the Software without restriction, including without limitation
;   the rights to use, copy, modify, merge, publish, distribute, sublicense,
;   and/or sell copies of the Software, and to permit persons to whom the
;   Software is furnished to do so, subject to the following conditions:
;
;   The above copyright notice and this permission notice shall be included in
;   all copies or substantial portions of the Software.
;
;   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;   DEALINGS IN THE SOFTWARE.


; This file can be given to CCL to rebuild it with new memory settings.
; Typical usage is:
;
;    - Download CCL from SVN
;    - Rebuild CCL from Sources, i.e., (rebuild-ccl :full t), (quit), as
;      explained in the CCL manual, Chapter 2.2
;    - Then, while still in your CCL directory:
;        ./lx86cl64 -n < [...]/acl2/books/centaur/ccl-config.lsp
;
; This should clobber your existing lx86cl64 image and replace it with a new
; one that has larger default stack sizes and better garbage collection
; settings for doing proofs using ACL2(h) and the Centaur Books.
;
; Afterward, you can verify that your image has been modified by looking at the
; value of ccl::*initial-listener-default-control-stack-size*; it should now be
; much larger.

(in-package :ccl)

; Disable ephemeral garbage colelction because it seems to be unacceptably slow
; for ACL2(h).
(egc nil)

; Turn on verbose garbage collection
(gc-verbose t t)

; Set up default stack sizes.  You can override these later with the -Z option
; but only all together.  If we are running on a 32-bit platform (e.g., a
; 32-bit PowerPC Apple computer) we set the stack size more modestly.  If we
; are on a 64-bit platform, we set the stack sizes to large values.
;
; These stack sizes apply to the first (initial) Lisp listener thread, where
; the bulk of ACL2 computations take place.

; WARNING: This setting of stack size values only takes effect after starting a
; new Lisp process.  The typical ACL2 procedure is to save an executable using
; save-exec after doing these assignments, which will then take effect when you
; invoke the new executable.

(let ((stack-size (if (< most-positive-fixnum (expt 2 34))
                      (expt 2 23)
                    (expt 2 28))))

; See WARNING above.

  (setq *initial-listener-default-control-stack-size* stack-size)
  (setq *initial-listener-default-value-stack-size*   stack-size)

  ;; The temp stack probably doesn't need to be as large as the others.  When
  ;; CCL comes out of the box, it's half the size of the others.
  (setq *initial-listener-default-temp-stack-size* (floor stack-size 2)))

; Set up the garbage collector to wait until 1 GB has been allocated on a
; 32-bit system, or 2 GB on a 64-bit system.
(set-lisp-heap-gc-threshold (if (< most-positive-fixnum (expt 2 34))
                                (expt 2 30)
                              (expt 2 31)))

(use-lisp-heap-gc-threshold)

; [Bob]: These control the saving of DEFUN bodies.  This is turned off by Matt
; in ACL2 because it slows down the ACL2 regression by 8%.  We now do the same.
(setq *save-definitions* nil)
(setq *fasl-save-definitions* nil)

; [Bob]: This makes CCL exit on Ctrl+D, which is really convenient.  Please do
; not remove it.
(setq *quit-on-eof* t)

(save-application *heap-image-name*)

(quit)

