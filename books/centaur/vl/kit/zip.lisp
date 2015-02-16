; VL Verilog Toolkit
; Copyright (C) 2008-2015 Centaur Technology
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
;
; Original author: Jared Davis <jared@centtech.com>

(in-package "VL")
(include-book "zipformat")
(include-book "../loader/top")
(include-book "centaur/getopt/top" :dir :system)
(include-book "std/io/read-file-characters" :dir :system)
(include-book "progutils")
(include-book "oslib/catpath" :dir :system)
(include-book "oslib/date" :dir :system)
(local (include-book "../util/arithmetic"))
(local (include-book "../util/osets"))

(defoptions vl-zip-opts
  :parents (vl-zip)
  :short "Options for running @('vl zip')."
  :tag :vl-model-opts

  ((help        booleanp
                :alias #\h
                "Show a brief usage message and exit."
                :rule-classes :type-prescription)

   (readme      booleanp
                "Show a more elaborate README and exit."
                :rule-classes :type-prescription)

   (name        stringp
                :alias #\n
                :argname "NAME"
                "Default is \"design\".  Should be a short name that identifies
                 the project that this zip file is parsing.  This controls how
                 the file will be presented in the \"Choose Model\" screen in
                 the Module Browser."
                :default "design"
                :rule-classes :type-prescription)

   (output      stringp
                :alias #\o
                :argname "FILE"
                "Default is \"design.vlzip\".  Where to write the collected up
                 modules.  Typically this should have a .vlzip extension."
                :default "design.vlzip"
                :rule-classes :type-prescription)

   (start-files string-listp
                "The list of files to parse. (Not options; this is the rest of
                 the command line, hence :hide t)"
                :hide t)

   (search-path string-listp
                :longname "search"
                :alias #\s
                :argname "DIR"
                "Control the search path for finding modules.  You can give
                 this switch multiple times, to set up multiple search paths in
                 priority order."
                :parser getopt::parse-string
                :merge acl2::rcons)

   (include-dirs string-listp
                 :longname "incdir"
                 :alias #\I
                 :argname "DIR"
                 "Control the list of directories for `include files.  You can
                  give this switch multiple times.  By default, we look only in
                  the current directory."
                 :parser getopt::parse-string
                 :merge acl2::rcons
                 :default '("."))

   (search-exts string-listp
                :longname "searchext"
                :argname "EXT"
                "Control the search extensions for finding modules.  You can
                 give this switch multiple times.  By default we just look for
                 files named \"foo.sv\" and \"foo.v\" in the --search
                 directories.  If you have Verilog files with different
                 extensions, this won't work, so you can add these extensions
                 here."
                :parser getopt::parse-string
                :merge acl2::rcons
                :default '("sv" "v"))

   (defines     string-listp
                :longname "define"
                :alias #\D
                :argname "VAR"
                "Set up definitions to use before parsing begins.  Equivalent
                 to putting `define VAR 1 at the top of your Verilog file.
                 You can give this option multiple times."
                :parser getopt::parse-string
                :merge acl2::cons)

   (edition     vl-edition-p
                :argname "EDITION"
                "Which edition of the Verilog standard to implement?
                 Default: \"SystemVerilog\" (IEEE 1800-2012).  You can
                 alternately use \"Verilog\" for IEEE 1364-2005, i.e.,
                 Verilog-2005."
                :default :system-verilog-2012)

   (strict      booleanp
                :rule-classes :type-prescription
                "Disable VL extensions to Verilog.")

   (mem         posp
                :alias #\m
                :argname "GB"
                "How much memory to try to use.  Default: 4 GB.  Raising this
                 may improve performance by avoiding garbage collection.  To
                 avoid swapping, keep this below (physical_memory - 2 GB)."
                :default 4
                :rule-classes :type-prescription)
   ))


(defconst *vl-zip-help* (str::cat "
vl zip:  Parse Verilog files and write it out as a .vlzip file.

Example:  vl zip engine.v wrapper.v core.v \\
              --search ./simlibs \\
              --search ./baselibs \\
              --output my-design.vlzip

Usage:    vl zip [OPTIONS] file.v [file2.v ...]

Options:" *nls* *nls* *vl-zip-opts-usage* *nls*))

(define vl-zip-main ((opts vl-zip-opts-p)
                     &key (state 'state))

  (b* (((vl-zip-opts opts) opts)

       (loadconfig (make-vl-loadconfig
                    :edition       opts.edition
                    :strictp       opts.strict
                    :start-files   opts.start-files
                    :search-path   opts.search-path
                    :search-exts   opts.search-exts
                    :include-dirs  opts.include-dirs
                    :defines       (vl-make-initial-defines opts.defines)
                    :filemapp      t))

       ((mv result state) (vl-load loadconfig))
       ((vl-loadresult result) result)
       ((mv date state) (oslib::date))
       ((mv ltime state) (oslib::universal-time))
       (zip (make-vl-zip :name    opts.name
                         :syntax  *vl-current-syntax-version*
                         :date    date
                         :ltime   ltime
                         :design  result.design
                         :filemap result.filemap
                         :defines result.defines))
       (- (cw "Writing output file ~x0~%" opts.output))
       (state (cwtime (vl-write-zip opts.output zip)))
       (- (cw "All done.")))
    state))

(defconsts (*vl-zip-readme* state)
  (b* (((mv contents state) (acl2::read-file-characters "zip.readme" state))
       ((when (stringp contents))
        (raise contents)
        (mv "" state)))
    (mv (implode contents) state)))

(define vl-zip-top ((argv string-listp) &key (state 'state))
  :parents (kit)
  :short "The @('vl zip') command."
  (b* (((mv errmsg opts start-files)
        (parse-vl-zip-opts argv))
       ((when errmsg)
        (die "~@0~%" errmsg)
        state)
       (opts (change-vl-zip-opts opts
                                 :start-files start-files))
       ((vl-zip-opts opts) opts)

       ((when opts.help)
        (vl-cw-ps-seq (vl-print *vl-zip-help*))
        (exit-ok)
        state)

       ((when opts.readme)
        (vl-cw-ps-seq (vl-print *vl-zip-readme*))
        (exit-ok)
        state)

       ((unless (consp opts.start-files))
        (die "No files to process.")
        state)

       (- (cw "VL Zip Configuration:~%"))

       (- (cw " - start files: ~x0~%" opts.start-files))
       (state (must-be-regular-files! opts.start-files))

       (- (cw " - search path: ~x0~%" opts.search-path))
       (state (must-be-directories! opts.search-path))

       (- (cw " - include directories: ~x0~%" opts.include-dirs))
       (state (must-be-directories! opts.include-dirs))

       (- (and opts.defines (cw "; defines: ~x0~%" opts.defines)))

       (- (cw " - output file: ~x0~%" opts.output))

       (- (cw "; Soft heap size ceiling: ~x0 GB~%" opts.mem))
       (- (acl2::set-max-mem ;; newline to appease cert.pl's scanner
           (* (expt 2 30) opts.mem)))

       (state (vl-zip-main opts)))
    (exit-ok)
    state))


