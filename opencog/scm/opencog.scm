;
; Main OpenCog guile module
;
; When this module is loaded from the guile prompt, it sets up all of
; the opencog infrastructure, including a default atomspace.
;
; To use, say this from the guile prompt:
; (use-modules (opencog))
;
;
; This should result in a utf8 locale being used!
; See https://github.com/opencog/opencog/issues/937
(setlocale LC_CTYPE "")
(setlocale LC_NUMERIC "C")

(define-module (opencog))

(use-modules (opencog as-config))

(load-extension (string-append opencog-ext-path-smob "libsmob") "opencog_guile_init")

; List everything to be exported from the C++ code i.e. from libsmob,
; as otherwise guile generates warnings about "possibly unbound variable"
; when these are touched in the various scm files.
(export
cog-arity
cog-atom
cog-atom?
cog-atom-less?
cog-atomspace
cog-atomspace?
cog-atomspace-clear
cog-atomspace-cow!
cog-atomspace-cow?
cog-atomspace-env
cog-atomspace-readonly?
cog-atomspace-ro!
cog-atomspace-rw!
cog-atomspace-uuid
cog-confidence
cog-count
cog-count-atoms
cog-delete!
cog-delete-recursive!
cog-extract!
cog-extract-recursive!
cog-get-subtypes
cog-get-types
cog-handle
cog-inc-count!
cog-incoming-by-type
cog-incoming-set
cog-incoming-size
cog-incoming-size-by-type
cog-inc-value!
cog-keys
cog-link
cog-link?
cog-map-type
cog-mean
cog-name
cog-new-atom
cog-new-atomspace
cog-new-link
cog-new-node
cog-new-value
cog-node
cog-node?
cog-number
cog-outgoing-atom
cog-outgoing-by-type
cog-outgoing-set
cog-set-atomspace!
cog-set-tv!
cog-set-value!
cog-subtype?
cog-tv
cog-tv-confidence
cog-tv-count
cog-tv-mean
cog-tv-merge
cog-tv-merge-hi-conf
cog-type
cog-type->int
cog-value
cog-value?
cog-value->list
cog-value-ref
)

; Create a global to hold the atomspace ... to (try to) prevent guile
; GC from collecting it.  Unfortunately, there appears to be a GC bug
; in guile-2.1 that causes this to be collected, anyway.  Its as if
; guile forgets about this ... how? why? I don't get it.
;
; In various bad scenarios, the cogserver creates it's own atomspace,
; before the code here runs.  We want to avoid creating a second
; atomspace as a result. The below tries to avoid problems by simply
; grabbing the existing atomspace, if there already is one.
;
; FIXME: Both of the above-described problems might no longer exist.
; I'm not sure. The below is simple and painless, I'm leaving it for
; now.

(define-public cog-initial-as (cog-atomspace))
(define-public my-as (cog-atomspace))
(if (nil? cog-initial-as)
	(begin
		(set! cog-initial-as (cog-new-atomspace))
		; Initialize a default atomspace, just to keep things sane...
		(cog-set-atomspace! cog-initial-as)))

; Renamed functions
(define-public (cog-as ATOM) "See cog-atomspace" (cog-atomspace ATOM))
(define-public (cog-delete ATOM) "See cog-delete!" (cog-delete! ATOM))
(define-public (cog-delete-recursive ATOM)
	"See cog-delete-recursive!" (cog-delete-recursive! ATOM))
(define-public (cog-extract ATOM) "See cog-extract!" (cog-extract! ATOM))
(define-public (cog-extract-recursive ATOM)
	"See cog-extract-recursive!" (cog-extract-recursive! ATOM))

; Load core atom types.
(include-from-path "opencog/base/core_types.scm")

; Load other grunge too.
; Some of these things could possibly be turned into modules ...?
; ATTENTION: if you add a file here, then be sure to ALSO add it to
; ../opencog/guile/SchemeSmob.cc SchemeSmob::module_init() circa line 260

(include-from-path "opencog/base/core-docs.scm")
(include-from-path "opencog/base/utilities.scm")
(include-from-path "opencog/base/atom-cache.scm")
(include-from-path "opencog/base/apply.scm")
(include-from-path "opencog/base/tv.scm")
(include-from-path "opencog/base/types.scm")
(include-from-path "opencog/base/file-utils.scm")
(include-from-path "opencog/base/debug-trace.scm")

; Obsolete functions
(define-public (cog-undefined-handle) "obsolete function" '())
