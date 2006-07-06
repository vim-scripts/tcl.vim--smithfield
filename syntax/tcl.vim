" Vim syntax file for Tcl/tk language
" Language:	Tcl
" Maintained:	SM Smithfield <m_smithfield@yahoo.com>
" Last Change:	07/06/2006 (17:30:24)
" Filenames:    *.tcl
" Version:      0.1

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif"

" Options:
"   To set option uncomment the line after the description

" Minimal highlighting, no keywords
" let tcl_highlight = 0
" keyword highlighting
" let tcl_highlight = 1
" Predicate highlighting
let tcl_highlight = 2
    

" -------------------------
" Basics:
" -------------------------
syn region tclWord1      contained start=+[^\[#{}"\]]\&\S+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tclStuff
syn region tclWord0      contained start=+[^\[#{}"\]]\&\S+ end=+\s\|$+ contains=@tclWord0Cluster skipwhite nextgroup=@tclWord1Cluster
syn region tclQuotes     contained extend keepend matchgroup=tclQuotes start=+\(\\\)\@<!"+ end=+"+ skip=+\\"+ contains=@tclQuotesCluster
syn region tclBrackets   contained extend keepend excludenl matchgroup=tclBookends start=+\(\\\)\@<!\[+ skip=+\\\s*$\|\\]+ end=+]\|$+ contains=@tclCommandCluster
syn region tclBraces     contained extend keepend excludenl matchgroup=tclBookends start=+\(\\\)\@<!{+  skip=+$\|\\}+ end=+}+ contains=@tclCommandCluster
syn region tclFoldBraces contained extend keepend excludenl fold matchgroup=tclBookends start=+\(\\\)\@<!{+  skip=+$\|\\}+ end=+}+ contains=@tclCommandCluster
syn match  tclSemiColon  contained ";\s*" skipwhite nextgroup=@tclCommandCluster
syn region tclComment    contained extend oneline start=+^\s*\#+ end="$" contains=tclTodo
syn region tclComment    contained extend oneline start=+;\s*\#+hs=s+1  end="$" contains=tclTodo
syn region tclCommand	 contains=@tclCommandCluster start="[^;]\&." skip="\\$" end=";\|$" skipnl 



" -------------------------
" Clusters:
" -------------------------
syn cluster tcltkKeywords      contains=@tclKeywords,@tkKeywords
syn cluster tclKeywords        contains=tclKeyword,tclException,tclConditional,tclRepeat,tclLabel,tclMagicName
syn cluster tkKeywords         contains=tkKeyword,tkReserved,tkWidget,tkDialog
" ------------------
syn cluster tclBits            contains=tclBraces,tclBrackets,tclComment,tclExpand,tclLContinue,tclNumber,tclQuotes,tclSpecial,tkColor,tkEvent,tclSemiColon
syn cluster tclStuff           contains=@tclBits,tclVariable,tkBindSubstGroup
syn cluster tclWord0Cluster    contains=@tclStuff,@tcltkKeywords
syn cluster tclWord1Cluster    contains=tclWord1,tclSecondary,tkWidgetCmds,tkWidgetCreate,tclConditional,@tclStuff
syn cluster tclQuotesCluster   contains=tclSpecial,tclLContinue

if exists("tcl_highlight")
    if tcl_highlight == 2
	syn cluster tclCommandCluster contains=@tclBits,tclPrimary,tclWord0
    elseif tcl_highlight == 1
	" TODO: add the tk words
	syn keyword tclKeyword        contained after array binary clock dict encoding exec fconfigure fcopy file fileevent glob history info interp lsearch lsort memory open package puts read regexp regsub return seek socket source string subst switch trace unload unset update
	syn keyword tclKeyword	      contained if elseif else then for while foreach break continue default catch error expr proc method constructor
	syn cluster tclCommandCluster contains=@tclBits,@tcltkKeywords
    elseif tcl_highlight == 0
	syn cluster tclCommandCluster contains=@tclBits
    endif
endif



" -------------------------
" Syntax: Tcl
" -------------------------
syn keyword tclKeyword        contained append auto_execok auto_import auto_load auto_mkindex auto_qualify auto_reset cd close concat eof eval exit fblocked flush format gets global http incr join lappend lassign lindex linsert list llength load lrange lrepeat lreplace lset namespace parray pid pkg_mkIndex proc pwd registry rename return scan set split tclLog tcl_endOfWord tcl_findLibrary tcl_startOfNextWord tcl_startOfPreviousWord tcl_wordBreakAfter tcl_wordBreakBefore tell time unknown uplevel upvar variable vwait
syn keyword tclMagicName      contained argc argv argv0 auto_index auto_oldpath auto_path env errorCode errorInfo tcl_interactive tcl_libpath tcl_library tlc_patchlevel tcl_pkgPath tcl_platform tcl_precision tcl_rcFileName tcl_rcRsrcName tcl_traceCompile tcl_traceExec tcl_version
" ------------------
syn keyword tkKeyword         contained bell bind clipboard console consoleinterp event focus grid pack place tkwait winfo wm
syn keyword tkKeyword         contained bindtags destroy lower option raise send tk tkerror tkwait tk_bisque tk_focusNext tk_focusPrev tk_focusFollowsMouse tk_popup tk_setPalette tk_textCut tk_TextCopy tk_textPaste
syn keyword tkDialog          contained chooseColor tk_chooseColor tk_chooseDirectory tk_dialog tk_getOpenFile tkDialog tk_getSaveFile tk_messageBox
syn keyword tkReserved        contained tk_library tk_strictMotif tk_version
syn keyword tkWidget          contained button canvas checkbutton entry frame image label labelframe listbox menu menubutton message panedwindow radiobutton scale scrollbar spinbox toplevel skipwhite nextgroup=tkWidgetPredicate
syn keyword tkWidget          contained table skipwhite nextgroup=tkWidgetPredicate

" CONDITIONALS
syn keyword tclPrimary        contained if skipwhite nextgroup=tclIfCommentStart,tclExpression,@tclStuff
syn keyword tclConditional    contained elseif skipwhite nextgroup=tclExpression,@tclStuff
syn keyword tclConditional    contained else then

" REPEAT
syn keyword tclRepeat         contained for skipwhite nextgroup=tclForStart,@tclStuff
syn match tclForStart         contained "\s*{.\{-}}" contains=@tclCommandCluster skipwhite nextgroup=tclExpression,@tclStuff
syn keyword tclRepeat         contained while skipwhite nextgroup=tclExpression,@tclStuff
syn keyword tclRepeat         contained foreach break continue
syn keyword tclLabel          contained default
syn keyword tclException      contained catch error

" EXPRESSION - that presumes to be an expression, occurs in expr, conditional, loops, etc...
syn keyword tclPrimary        contained expr skipwhite nextgroup=tclExpression
syn region tclExpression      contained keepend extend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclMaths,@tclStuff
syn region tclExpression      contained keepend extend excludenl matchgroup=tclBookends start=+\s*\(\\\)\@<!{+  end=+}+ skip=+$\|\\$\|\\}+ contains=tclMaths,@tclStuff
syn keyword tclMaths          contained abs acos asin atan atan2 ceil cos cosh double exp floor fmod hypot int log log10 pow rand round sin sinh sqrt srand tan tanh wide
syn keyword tclMaths          contained ne eq in ni
syn match tclMaths            contained "[()^%~<>!=+*\-|&?:/]"

" IF - permits use of if{0} {} commenting idiom
syn region tclIfComment contained extend keepend excludenl matchgroup=Comment start=+\(\\\)\@<!{+  skip=+$\|\\}+ end=+}+ contains=tclIfComment
syn match tclIfCommentStart  contained extend excludenl "\s*{0}" skipwhite nextgroup=tclIfComment

" PROC - proc name hilite AND folding
syn keyword tclPrimary contained proc method constructor skipwhite nextgroup=tclProcName
syn match tclProcName  contained "\S\+" skipwhite nextgroup=tclProcArgs
syn region tclProcArgs contained extend keepend excludenl matchgroup=tclBookends start=+\(\\\)\@<!{+  skip=+$\|\\}+ end=+}+ contains=tclProcArgs skipwhite nextgroup=tclFoldBraces


" -------------------------
" Syntax: Tcl Bits
" -------------------------
syn keyword tclTodo        contained TODO
syn match tkEvent          contained "<\S\+>"
syn match tkEvent          contained "<<.\+>>"
syn match tkColor          contained "#[0-9A-Fa-f]\{6}\|#[0-9A-Fa-f]\{3}"
syn match tclNumber        contained "\<\d\+\(u\=l\=\|lu\|f\)\>"
syn match tclNumber        contained "\<\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match tclNumber        contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match tclNumber        contained "\<\d\+e[-+]\=\d\+[fl]\=\>"
syn match tclNumber        contained "0x[0-9a-f]\+\(u\=l\=\|lu\)\>"
syn match tclVariable      contained extend "${[^}]*}"
syn match tclVariable      contained "$\(\(::\)\?\([[:alnum:]_.]*::\)*\)\h[a-zA-Z0-9_.]*"
syn match tclVariable      contained "$\(\(::\)\?\([[:alnum:]_.]*::\)*\)\h[a-zA-Z0-9_.]*\(\((\([[:alnum:]_.]*::\)*\)\a[a-zA-Z0-9_.]*)\)\?"
syn match tclSpecial       contained "\\\d\d\d\=\|\\."
syn match tclLContinue     contained "\\\s*$"
syn match tclExpand        contained extend "{expand}"


" -------------------------
" Syntax: Tcl Keyword Predicates
" -------------------------
syn keyword tclPrimary contained puts read skipwhite nextgroup=tclPutsPred
syn match tclPutsOptsGroup contained "-\a\+" contains=tclPutsOpts
syn keyword tclPutsOpts contained nonewline
syn region tclPutsPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclPutsOptsGroup,@tclStuff

syn keyword tclPrimary contained return skipwhite nextgroup=tclReturnPred
syn match tclReturnOptsGroup contained "-\a\+" contains=tclReturnOpts
syn keyword tclReturnOpts contained code errorcode errorinfo level options
syn region tclReturnPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclReturnOptsGroup,@tclStuff

syn keyword tclPrimary contained source skipwhite nextgroup=tclSourcePred
syn match tclSourceOptsGroup contained "-\a\+" contains=tclSourceOpts
syn keyword tclSourceOpts contained encoding
syn region tclSourcePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclSourceOptsGroup,@tclStuff

syn keyword tclPrimary contained after skipwhite nextgroup=tclAfterPred
syn keyword tclAfterCmds contained cancel idle info
syn region tclAfterPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclAfterCmds,@tclStuff

syn keyword tclPrimary contained array skipwhite nextgroup=tclArrayPred
syn keyword tclArrayCmds contained anymore donesearch exists get nextelement set size startsearch statistics unset
syn region tclArrayPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclArrayCmds,@tclStuff
syn match tclArrayNamesOptsGroup contained "-\a\+" contains=tclArrayNamesOpts
syn keyword tclArrayNamesOpts contained exact glob regexp
syn region tclArrayNamesPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclArrayNamesOptsGroup,@tclStuff
syn keyword tclArrayCmds contained names skipwhite nextgroup=tclArrayNamesPred

syn keyword tclPrimary contained binary skipwhite nextgroup=tclBinaryPred
syn keyword tclBinaryCmds contained format scan
syn region tclBinaryPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclBinaryCmds,@tclStuff

syn keyword tclPrimary contained encoding skipwhite nextgroup=tclEncodingPred
syn keyword tclEncodingCmds contained convertfrom convertto names system
syn region tclEncodingPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclEncodingCmds,@tclStuff

syn keyword tclPrimary contained info skipwhite nextgroup=tclInfoPred
syn keyword tclInfoCmds contained args body cmdcount commands complete default exists functions globals hostname level library loaded locals nameofexecutable patchlevel procs script sharedlibextension tclversion vars
syn region tclInfoPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInfoCmds,@tclStuff

syn keyword tclPrimary contained memory skipwhite nextgroup=tclMemoryPred
syn keyword tclMemoryCmds contained active break info init onexit tag trace validate
syn region tclMemoryPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclMemoryCmds,@tclStuff

syn keyword tclPrimary contained update skipwhite nextgroup=tclUpdatePred
syn keyword tclUpdateCmds contained idletasks
syn region tclUpdatePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclUpdateCmds,@tclStuff

syn keyword tclPrimary contained exec skipwhite nextgroup=tclExecPred
syn match tclExecOptsGroup contained "-\a\+" contains=tclExecOpts
syn keyword tclExecOpts contained keepnewline
syn region tclExecPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclExecOptsGroup,@tclStuff

syn keyword tclPrimary contained glob skipwhite nextgroup=tclGlobPred
syn match tclGlobOptsGroup contained "-\a\+" contains=tclGlobOpts
syn keyword tclGlobOpts contained directory join nocomplain path tails types
syn region tclGlobPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclGlobOptsGroup,@tclStuff

syn keyword tclPrimary contained regexp skipwhite nextgroup=tclRegexpPred
syn match tclRegexpOptsGroup contained "-\a\+" contains=tclRegexpOpts
syn keyword tclRegexpOpts contained about expanded indicies line linestop lineanchor nocase all inline start
syn region tclRegexpPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclRegexpOptsGroup,@tclStuff

syn keyword tclPrimary contained regsub skipwhite nextgroup=tclRegsubPred
syn match tclRegsubOptsGroup contained "-\a\+" contains=tclRegsubOpts
syn keyword tclRegsubOpts contained all expanded line linestop nocase start
syn region tclRegsubPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclRegsubOptsGroup,@tclStuff

syn keyword tclPrimary contained switch skipwhite nextgroup=tclSwitchPred
syn match tclSwitchOptsGroup contained "-\a\+" contains=tclSwitchOpts
syn keyword tclSwitchOpts contained exact glob regexp nocase matchvar indexvar
syn region tclSwitchPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclSwitchOptsGroup,@tclStuff

syn keyword tclPrimary contained unload skipwhite nextgroup=tclUnloadPred
syn match tclUnloadOptsGroup contained "-\a\+" contains=tclUnloadOpts
syn keyword tclUnloadOpts contained nocomplain keeplibrary
syn region tclUnloadPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclUnloadOptsGroup,@tclStuff

syn keyword tclPrimary contained unset skipwhite nextgroup=tclUnsetPred
syn match tclUnsetOptsGroup contained "-\a\+" contains=tclUnsetOpts
syn keyword tclUnsetOpts contained nocomplain
syn region tclUnsetPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclUnsetOptsGroup,@tclStuff

syn keyword tclPrimary contained subst skipwhite nextgroup=tclSubstPred
syn match tclSubstOptsGroup contained "-\a\+" contains=tclSubstOpts
syn keyword tclSubstOpts contained nocommands novariables nobackslashes
syn region tclSubstPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclSubstOptsGroup,@tclStuff

syn keyword tclPrimary contained lsearch skipwhite nextgroup=tclLsearchPred
syn match tclLsearchOptsGroup contained "-\a\+" contains=tclLsearchOpts
syn keyword tclLsearchOpts contained exact glob regexp sorted all inline not ascii dictionary integer nocase real decreasing increasing subindices
syn region tclLsearchPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclLsearchOptsGroup,@tclStuff
syn keyword tclLsearchOpts contained start index

syn keyword tclPrimary contained lsort skipwhite nextgroup=tclLsortPred
syn match tclLsortOptsGroup contained "-\a\+" contains=tclLsortOpts
syn keyword tclLsortOpts contained ascii dictionary integer real increasing decreasing indicies nocase unique
syn region tclLsortPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclLsortOptsGroup,@tclStuff
syn keyword tclLsortOpts contained command index

syn keyword tclPrimary contained fconfigure skipwhite nextgroup=tclFconfigurePred
syn match tclFconfigureOptsGroup contained "-\a\+" contains=tclFconfigureOpts
syn keyword tclFconfigureOpts contained blocking buffering buffersize encoding eofchar
syn region tclFconfigurePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFconfigureOptsGroup,@tclStuff
syn keyword tclFconfigureOpts contained translation

syn keyword tclPrimary contained fcopy skipwhite nextgroup=tclFcopyPred
syn match tclFcopyOptsGroup contained "-\a\+" contains=tclFcopyOpts
syn keyword tclFcopyOpts contained size command
syn region tclFcopyPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFcopyOptsGroup,@tclStuff

syn keyword tclPrimary contained socket skipwhite nextgroup=tclSocketPred
syn match tclSocketOptsGroup contained "-\a\+" contains=tclSocketOpts
syn keyword tclSocketOpts contained server myaddr myport async myaddr error sockname peername
syn region tclSocketPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclSocketOptsGroup,@tclStuff

syn keyword tclPrimary contained fileevent skipwhite nextgroup=tclFileeventPred
syn keyword tclFileeventCmds contained readable writable
syn region tclFileeventPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFileeventCmds,@tclStuff

syn keyword tclPrimary contained open skipwhite nextgroup=tclOpenPred
syn match tclOpenOptsGroup contained "-\a\+" contains=tclOpenOpts
syn keyword tclOpenOpts contained mode handshake queue timeout ttycontrol ttystatus xchar pollinterval sysbuffer lasterror
syn region tclOpenPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclOpenOptsGroup,@tclStuff

syn keyword tclPrimary contained seek skipwhite nextgroup=tclSeekPred
syn keyword tclSeekCmds contained start current end
syn region tclSeekPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclSeekCmds,@tclStuff

syn keyword tclPrimary contained clock skipwhite nextgroup=tclClockPred
syn keyword tclClockCmds contained microseconds milliseconds seconds
syn region tclClockPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclClockCmds,@tclStuff
syn match tclClockAddOptsGroup contained "-\a\+" contains=tclClockAddOpts
syn keyword tclClockAddOpts contained base format gmt locale timezone
syn region tclClockAddPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclClockAddOptsGroup,@tclStuff
syn keyword tclClockCmds contained add clicks format scan skipwhite nextgroup=tclClockAddPred

syn keyword tclPrimary contained dict skipwhite nextgroup=tclDictPred
syn keyword tclDictCmds contained append create exists for get incr info keys lappend merge remove replace set size unset update values with
syn region tclDictPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclDictCmds,@tclStuff
syn match tclDictFilterOptsGroup contained "-\a\+" contains=tclDictFilterOpts
syn keyword tclDictFilterOpts contained key script value
syn region tclDictFilterPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclDictFilterOptsGroup,@tclStuff
syn keyword tclDictCmds contained filter skipwhite nextgroup=tclDictFilterPred

syn keyword tclPrimary contained file skipwhite nextgroup=tclFilePred
syn keyword tclFileCmds contained channels dirname executable exists extension isdirectory isfile join link lstat mkdir mtime nativename normalize owned pathtype readable readlink rootname separator size split stat system tail volumes writable
syn region tclFilePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFileCmds,@tclStuff
syn match tclFileAtimeOptsGroup contained "-\a\+" contains=tclFileAtimeOpts
syn keyword tclFileAtimeOpts contained time
syn region tclFileAtimePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFileAtimeOptsGroup,@tclStuff
syn keyword tclFileCmds contained atime skipwhite nextgroup=tclFileAtimePred
syn match tclFileCopyOptsGroup contained "-\a\+" contains=tclFileCopyOpts
syn keyword tclFileCopyOpts contained force
syn region tclFileCopyPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclFileCopyOptsGroup,@tclStuff
syn keyword tclFileCmds contained copy delete rename skipwhite nextgroup=tclFileCopyPred
syn match tclFileAttributesOptsGroup contained "-\a\+" contains=tclFileAttributesOpts
syn keyword tclFileAttributesOpts contained group owner permissions readonly archive hidden longname shortname system creator rsrclength
syn region tclFileAttributesPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFileAttributesOptsGroup,@tclStuff
syn keyword tclFileCmds contained attributes skipwhite nextgroup=tclFileAttributesPred

syn keyword tclPrimary contained history skipwhite nextgroup=tclHistoryPred
syn keyword tclHistoryCmds contained change clear event info keep nextid redo
syn region tclHistoryPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclHistoryCmds,@tclStuff
syn keyword tclHistoryAddCmds contained exec
syn region tclHistoryAddPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclHistoryAddCmds,@tclStuff
syn keyword tclHistoryCmds contained add skipwhite nextgroup=tclHistoryAddPred

syn keyword tclPrimary contained package skipwhite nextgroup=tclPackagePred
syn keyword tclPackageCmds contained forget ifneeded names provide unknown vcompare versions vsatisfies
syn region tclPackagePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclPackageCmds,@tclStuff
syn match tclPackagePresentOptsGroup contained "-\a\+" contains=tclPackagePresentOpts
syn keyword tclPackagePresentOpts contained exact
syn region tclPackagePresentPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclPackagePresentOptsGroup,@tclStuff
syn keyword tclPackageCmds contained present require skipwhite nextgroup=tclPackagePresentPred


syn keyword tclPrimary contained string skipwhite nextgroup=tclStringPred
syn keyword tclStringCmds contained bytelength first index last length range repeat replace tolower totitle toupper trim trimleft trimright wordend wordstart
syn region tclStringPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringCmds,@tclStuff
syn match tclStringCompareOptsGroup contained "-\a\+" contains=tclStringCompareOpts
syn keyword tclStringCompareOpts contained nocase length
syn region tclStringComparePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringCompareOptsGroup,@tclStuff
syn keyword tclStringCmds contained compare equal skipwhite nextgroup=tclStringComparePred
syn match tclStringMapOptsGroup contained "-\a\+" contains=tclStringMapOpts
syn keyword tclStringMapOpts contained nocase
syn region tclStringMapPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringMapOptsGroup,@tclStuff
syn keyword tclStringCmds contained map match skipwhite nextgroup=tclStringMapPred
syn match tclStringIsClassOptsGroup contained "-\a\+" contains=tclStringIsClassOpts
syn keyword tclStringIsClassOpts contained strict failindex
syn region tclStringIsClassPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringIsClassOptsGroup,@tclStuff
syn keyword tclStringIsClass contained alnum alpha ascii boolean control digit double false graph integer lower print punct space true upper wideinteger wordchar xdigit skipwhite nextgroup=tclStringIsClassPred
syn region tclStringIsPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringIsClass,@tclStuff
syn keyword tclStringCmds contained is skipwhite nextgroup=tclStringIsPred

syn keyword tclPrimary contained trace skipwhite nextgroup=tclTracePred
syn keyword tclTraceCmds contained variable vdelete vinfo
syn region tclTracePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmds,@tclStuff
syn keyword tclTraceAddCommandCmds contained rename trace
syn region tclTraceAddCommandPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceAddCommandCmds,@tclStuff
syn keyword tclTraceAddCmds contained command skipwhite nextgroup=tclTraceAddCommandPred
syn region tclTraceAddPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceAddCmds,@tclStuff
syn keyword tclTraceCmds contained add remove info skipwhite nextgroup=tclTraceAddPred
syn keyword tclTraceAddExecutionCmds contained enter leave enterstep leavestep
syn region tclTraceAddExecutionPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceAddExecutionCmds,@tclStuff
syn keyword tclTraceAddCmds contained execution skipwhite nextgroup=tclTraceAddExecutionPred
syn keyword tclTraceAddVariableCmds contained array read write unset
syn region tclTraceAddVariablePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceAddVariableCmds,@tclStuff
syn keyword tclTraceAddCmds contained variable skipwhite nextgroup=tclTraceAddVariablePred

syn keyword tclPrimary                        contained namespace skipwhite nextgroup=tclNamespacePred
syn keyword tclNamespaceCmds                  contained children code current delete eval exists forget inscope origin parent path qualifiers tail
syn region tclNamespacePred                   contained keepend fold start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceCmds,@tclStuff
syn match tclNamespaceExportOptsGroup         contained "-\a\+" contains=tclNamespaceExportOpts
syn keyword tclNamespaceExportOpts            contained clear force command variable
syn region tclNamespaceExportPred             contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceExportOptsGroup,@tclStuff
syn keyword tclNamespaceCmds                  contained export import which skipwhite nextgroup=tclNamespaceExportPred
syn match tclNamespaceEnsembleExistsOptsGroup contained "-\a\+" contains=tclNamespaceEnsembleExistsOpts
syn keyword tclNamespaceEnsembleExistsOpts    contained map prefixes subcommands unknown command namespace
syn region tclNamespaceEnsembleExistsPred     contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceEnsembleExistsOptsGroup,@tclStuff
syn keyword tclNamespaceEnsembleCmds          contained exists create configure skipwhite nextgroup=tclNamespaceEnsembleExistsPred
syn region tclNamespaceEnsemblePred           contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceEnsembleCmds,@tclStuff
syn keyword tclNamespaceCmds                  contained ensemble skipwhite nextgroup=tclNamespaceEnsemblePred
hi link tclNamespaceCmds		tclSubcommand 
hi link tclNamespaceExportOpts          tclOption     
hi link tclNamespaceEnsembleExistsOpts  tclOption 
hi link tclNamespaceEnsembleCmds        tclEnsemble 


syn keyword tclPrimary contained proc method skipwhite nextgroup=tclProcName
syn keyword tclPrimary contained constructor skipwhite nextgroup=tclProcArgs
syn match tclProcName  contained "\S\+" skipwhite nextgroup=tclProcArgs
syn region tclProcArgs contained extend keepend excludenl matchgroup=tclBookends start=+\(\\\)\@<!{+  skip=+$\|\\}+ end=+}+ contains=tclProcArgs skipwhite nextgroup=tclFoldBraces


syn keyword tclPrimary contained interp skipwhite nextgroup=tclInterpPred
syn keyword tclInterpCmds contained alias aliases bgerror delete eval exists expose hide hidden issafe marktrusted recursionlimit share slaves target transfer
syn region tclInterpPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpCmds,@tclStuff
syn match tclInterpCreateOptsGroup contained "-\a\+" contains=tclInterpCreateOpts
syn keyword tclInterpCreateOpts contained safe
syn region tclInterpCreatePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpCreateOptsGroup,@tclStuff
syn keyword tclInterpCmds contained create skipwhite nextgroup=tclInterpCreatePred
syn match tclInterpInvokehiddenOptsGroup contained "-\a\+" contains=tclInterpInvokehiddenOpts
syn keyword tclInterpInvokehiddenOpts contained namespace global
syn region tclInterpInvokehiddenPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpInvokehiddenOptsGroup,@tclStuff
syn keyword tclInterpCmds contained invokehidden skipwhite nextgroup=tclInterpInvokehiddenPred
syn match tclInterpLimitOptsGroup contained "-\a\+" contains=tclInterpLimitOpts
syn keyword tclInterpLimitOpts contained command granularity milliseconds seconds value
syn region tclInterpLimitPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpLimitOptsGroup,@tclStuff
syn keyword tclInterpCmds contained limit skipwhite nextgroup=tclInterpLimitPred
syn keyword tclSecondary contained aliases alias bgerror eval expose hide hidden issafe marktrusted recursionlimit
syn match tclInterpSubInvokehiddenOptsGroup contained "-\a\+" contains=tclInterpSubInvokehiddenOpts
syn keyword tclInterpSubInvokehiddenOpts contained namespace global
syn region tclInterpSubInvokehiddenPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpSubInvokehiddenOptsGroup,@tclStuff
syn keyword tclSecondary contained invokehidden skipwhite nextgroup=tclInterpSubInvokehiddenPred
syn match tclInterpSubLimitOptsGroup contained "-\a\+" contains=tclInterpSubLimitOpts
syn keyword tclInterpSubLimitOpts contained command granularity milliseconds seconds value
syn region tclInterpSubLimitPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpSubLimitOptsGroup,@tclStuff
syn keyword tclSecondary contained limit skipwhite nextgroup=tclInterpSubLimitPred

syn keyword tclPrimary contained bell skipwhite nextgroup=tkBellPred
syn match tkBellOptsGroup contained "-\a\+" contains=tkBellOpts
syn keyword tkBellOpts contained nice displayof
syn region tkBellPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkBellOptsGroup,@tclStuff

syn keyword tclPrimary contained clipboard skipwhite nextgroup=tkClipboardPred
syn match tkClipboardClearOptsGroup contained "-\a\+" contains=tkClipboardClearOpts
syn keyword tkClipboardClearOpts contained displayof format type
syn region tkClipboardClearPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkClipboardClearOptsGroup,@tclStuff
syn keyword tkClipboardCmds contained clear append get skipwhite nextgroup=tkClipboardClearPred
syn region tkClipboardPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkClipboardCmds,@tclStuff

syn keyword tclPrimary contained console consoleinterp skipwhite nextgroup=tkConsolePred
syn keyword tkConsoleCmds contained eval hide show title record
syn region tkConsolePred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkConsoleCmds,@tclStuff

syn keyword tclPrimary contained focus skipwhite nextgroup=tkFocusPred
syn match tkFocusOptsGroup contained "-\a\+" contains=tkFocusOpts
syn keyword tkFocusOpts contained displayof force lastfor
syn region tkFocusPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkFocusOptsGroup,@tclStuff

syn keyword tclPrimary contained tkwait skipwhite nextgroup=tkTkwaitPred
syn keyword tkTkwaitCmds contained variable visibility window
syn region tkTkwaitPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkTkwaitCmds,@tclStuff

syn keyword tclPrimary contained winfo skipwhite nextgroup=tkWinfoPred
syn keyword tkWinfoCmds contained containing interps pathname visualscells children class colormapfull depth exists fpixels geom[etry] height id ismapped manager name parent pixels pointerx pointerxy pointery reqheight reqwidth rgb rootx rooty screen screencells screendepth screenheight screenmmheight screenmmwidth screenvisual screenwidth server toplevel viewable visual visualid vrootheight vrootwidth vrootx vrooty width x y
syn region tkWinfoPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWinfoCmds,@tclStuff
syn match tkWinfoAtomOptsGroup contained "-\a\+" contains=tkWinfoAtomOpts
syn keyword tkWinfoAtomOpts contained displayof includeids
syn region tkWinfoAtomPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWinfoAtomOptsGroup,@tclStuff
syn keyword tkWinfoCmds contained atom atomname containing interps pathname visualsavailable skipwhite nextgroup=tkWinfoAtomPred

syn keyword tclPrimary contained wm skipwhite nextgroup=tkWmPred
syn keyword tkWmCmds contained aspect attributes attributes attributes client colormapwindows command deiconify focusmodel frame geom[etry] grid group iconbitmap iconify iconmask iconname iconphoto iconposition iconwindow maxsize minsize overrideredirect positionfrom protocol resizable sizefrom stackorder state title transient withdraw
syn region tkWmPred contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWmCmds,@tclStuff

" -------------------------
" Syntax: tk words with no recipes
" -------------------------
syn keyword tkWidgetMenu	contained cascade separator command checkbutton radiobutton
syn keyword tkWidgetCmds        contained activate addtag bbox canvasx canvasy clone coords curselection dchars delete delta deselect dtag entrycget entryconfigure find flash focus fraction get gettags icursor identify index insert invoke lower move moveto nearest panecget paneconfigure panes post postcascade postscript proxy raise replace sash scale see set toggle type unpost validate yposition
syn keyword tkWidgetCmds        contained conf[igure] cget skipwhite nextgroup=tkWidgetPredicate
syn keyword tkWidgetCmds        contained add skipwhite nextgroup=tkWidgetAddPredicate
syn region tkWidgetPredicate    contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetOptsGroup,@tclStuff
syn region tkWidgetAddPredicate contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetMenu,tkWidgetOptsGroup,@tclStuff
" these come from various widgets, their predicate spaces are a superset of everything required
syn keyword tkWidgetCmds           contained scan skipwhite nextgroup=tkWidgetScanPredicate
syn region tkWidgetScanPredicate   contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkBindSubstGroup,tkScanCmds,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds           contained select skipwhite nextgroup=tkWidgetSelectPredicate
syn region tkWidgetSelectPredicate contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkSelectCmds,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds           contained scroll skipwhite nextgroup=tkWidgetScrollPredicate
syn region tkWidgetScrollPredicate contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkScrollCmds,tkScrollbarElems,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds           contained xview yview skipwhite nextgroup=tkWidgetViewPredicate
syn region tkWidgetViewPredicate   contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkViewCmds,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds           contained edit skipwhite nextgroup=tkWidgetEditPredicate
syn region tkWidgetEditPredicate   contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkEditCmds,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds           contained mark skipwhite nextgroup=tkWidgetMarkPredicate
syn region tkWidgetMarkPredicate   contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkMarkCmds,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds           contained peer skipwhite nextgroup=tkWidgetPeerPredicate
syn region tkWidgetPeerPredicate   contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkPeerCmds,tkWidgetOptsGroup,@tclStuff
" terminated switches, needs keeepend
syn keyword tkWidgetCmds             contained search skipwhite nextgroup=tkWidgetSearchPredicate
syn region tkWidgetSearchPredicate   contained excludenl keepend start=+.+ end=+}\|]\|;\|.$\|--+ contains=tkWidgetSearchOptsGroup,@tclStuff
syn match tkWidgetSearchOptsGroup    contained "-\a\+" contains=tkWidgetSearchOpts skipwhite nextgroup=tkWidgetSearchOptsGroup,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetSearchOpts       contained forwards backwards exact regexp nolinestop nocase all overlap elide
syn keyword tkWidgetCmds	     contained selection skipwhite nextgroup=tkWidgetSelectionPredicate
syn region tkWidgetSelectionPredicate contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkSelectionCmds,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds             contained tag skipwhite nextgroup=tkWidgetTagPredicate
syn region tkWidgetTagPredicate      contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkTagCmds,tkWidgetOptsGroup,@tclStuff
syn keyword tkWidgetCmds             contained window skipwhite nextgroup=tkWidgetWindowPredicate
syn region tkWidgetWindowPredicate   contained excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWindowCmds,tkWidgetOptsGroup,@tclStuff

syn keyword tkEditCmds		   contained modified redo reset separator undo
syn keyword tkMarkCmds		   contained gravity names next previous set unset 
syn keyword tkPeerCmds		   contained create names
syn keyword tkScanCmds             contained mark dragto
syn keyword tkSelectCmds           contained adjust anchor clear element from includes item present range set to
syn keyword tkSelectionCmds        contained anchor clear includes set
syn keyword tkScrollCmds           contained units pages
syn keyword tkScrollbarElems       contained arrow1 arrow2 slider trough1 trough2
syn keyword tkTagCmds	           contained add bind cget configure delete lower names nextrange prevrange raise ranges remove
syn keyword tkViewCmds             contained moveto scroll
syn keyword tkWidgetOpts           contained accelerator activebackground activeborderwidth activeforeground anchor background bd bg bitmap borderwidth columnbreak command compound cursor disabledforeground exportselection fg font foreground hidemargin highlightbackground highlightcolor highlightthickness image indicatoron insertbackground insertborderwidth insertofftime insertontime insertwidth jump justify label menu offvalue onvalue orient padx pady relief repeatdelay repeatinterval selectbackground selectborderwidth selectcolor selectforeground selectimage setgrid state takefocus text textvar[iable] troughcolor underline value variable wraplength xscrollcommand yscrollcommand
syn keyword tkWidgetOpts           contained activerelief activestyle aspect background bigincrement buttonbackground buttoncursor buttondownrelief buttonuprelief class closeenough colormap command confine container default digits direction disabledbackground disabledforeground elementborderwidth format from handlepad handlesize height increment indicatoron invalidcommand invcmd justify label labelanchor labelwidget length listvariable menu offrelief offvalue onvalue opaqueresize overrelief postcommand readonlybackground resolution sashcursor sashpad sashrelief sashwidth screen scrollregion selectcolor selectimage selectmode show showhandle showvalue sliderlength sliderrelief state tearoff tearoffcommand tickinterval title to tristateimage tristatevalue type use validate validatecommand value values variable vcmd visual width wrap xscrollincrement yscrollincrement
syn keyword tkWindowCmds	   contained cget configure create names
syn match tkWidgetOptsGroup        contained "-\a\+" contains=tkWidgetOpts

hi link tkEditCmds	tclSubcommand
hi link tkMarkCmds	tclSubcommand
hi link tkPeerCmds	tclSubcommand
hi link tkSelectionCmds	tclSubcommand
hi link tkTagCmds	tclSubcommand
hi link tkWidgetSearchOpts tclOption
hi link tkViewCmds	tclSubcommand
hi link tkWindowCmds	tclSubcommand

hi link tkScanCmds       tclSubcommand 
hi link tkSelectCmds     tclSubcommand 
hi link tkScrollCmds     tclSubcommand 
hi link tkScrollbarElems tclOption     
hi link tkWidgetMenu     tclEnsemble   

syn keyword tkKeyword      contained bind skipwhite nextgroup=tkBindPredicate
syn keyword tkWidgetCmds   contained bind skipwhite nextgroup=tkBindPredicate
syn region tkBindPredicate contained keepend extend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkBindTag
syn region tkBindTag       contained start="." end="\s" skipwhite nextgroup=tkBindSeq contains=@tclStuff
syn region tkBindSeq       contained start="." end="\s" skipwhite nextgroup=tkBindScript contains=tkEvent
syn region tkBindScript    contained keepend extend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+                                     contains=@tclCommandCluster,tkBindSubstGroup
syn region tkBindScript    contained keepend extend excludenl matchgroup=tclBookends start=+\s*\(\\\)\@<!{+  end=+}+ skip=+$\|\\$\|\\}+ contains=@tclCommandCluster,tkBindSubstGroup

" To light these in the BindScript they have to be added to tclStuff,
" because they appear in both word0 and word1 positions. To do this correctly
" would mean creating a duplicate command,word0,word1 structure solely for the 
" purpose of adding these values, its interesting that a match, cannot superceed
" in this case
syn match tkBindSubstGroup contained "%%"
syn match tkBindSubstGroup contained "%#"
syn match tkBindSubstGroup contained "%\a" contains=tkBindSubst
syn keyword tkBindSubst    contained a b c d f h i k m o p s t w x y A B D E K N P R S T W X Y
hi link tkBindSubstGroup	tclSpecial
hi link tkBindSubst		tclSpecial

syn keyword tkKeyword       contained grab skipwhite nextgroup=tkGrabPredicate
syn region tkGrabPredicate  contained excludenl keepend start=+.+ end=+}\|]\|;\|.$+ contains=@tkGrabCluster,@tclStuff
syn keyword tkGrabCmds      contained current release set status skipwhite nextgroup=tkGrabOptsGroup
syn match tkGrabOptsGroup   contained "-\a\+" contains=tkGrabOpts
syn keyword tkGrabOpts      contained global
syn cluster tkGrabCluster contains=tkGrabCmds,tkGrabOptsGroup

syn keyword tkKeyword           contained event skipwhite nextgroup=tkEventPredicate,@tclStuff
syn region tkEventPredicate     contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkEventCmds
syn region tkEventCmdsPredicate contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tkEventCluster
syn keyword tkEventCmds         contained add delete generate info skipwhite nextgroup=tkEventCmdsPredicate
syn match tkEventFieldsGroup    contained "-\a\+" contains=tkEventFields
syn keyword tkEventFields       contained above borderwidth button count data delta detail focus height keycode keysym mode override place root rootx rooty sendevent serial state subwindow time warp width when x y
syn keyword tkEventWhen         contained now tail head mark
syn cluster tkEventCluster contains=tkEventCmds,tkEventFieldsGroup,tkEventWhen,@tclStuff
hi link tkEventCmds				tclSubcommand
hi link tkEventFields			tclOption
hi link tkEventWhen				tclString

syn keyword tkKeyword       contained font skipwhite nextgroup=tkFontPredicate
syn region tkFontPredicate  contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+  contains=tkFontCmds,tkFontOptsGroup,@tclStuff
syn keyword tkFontCmds      contained actual configure create delete families measure metrics names
syn match tkFontOptsGroup   contained "-\a\+" contains=tkFontOpts
syn keyword tkFontOpts      contained displayof ascent descent linespace fixed family size weight slant underline overstrike
hi link tkFontCmds          tclSubcommand 
hi link tkFontOpts          tclOption     

syn keyword tkKeyword       contained grid skipwhite nextgroup=tkGridPredicate
syn region tkGridPredicate  contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkGridCmds,tkGridOptsGroup,@tclStuff
syn keyword tkGridCmds      contained bbox columnconfigure forget info location propogate rowconfigure remove size slaves
syn match tkGridOptsGroup   contained "-\a\+" contains=tkGridOpts
syn keyword tkGridOpts      contained column columnspan in ipadx ipady padx pady row rowspan sticky
syn keyword tkGridOpts      contained minsize weight uniform pad
hi link tkGridOpts 	tclOption
hi link tkGridCmds	tclSubcommand

syn keyword tkKeyword           contained option skipwhite nextgroup=tkOptionPredicate
syn region tkOptionPredicate    contained excludenl keepend start=+.+ end=+}\|]\|;\|.$+ contains=tkOptionCmds,@tclStuff
syn keyword tkOptionCmds        contained add clear get readfile

syn keyword tkKeyword           contained pack skipwhite nextgroup=tkPackPredicate
syn region tkPackPredicate      contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkPackCmds,tkPackOptsGroup,@tclStuff
syn keyword tkPackCmds          contained forget info propogate slaves
syn match tkPackOptsGroup       contained "-\a\+" contains=tkPackOpts,@tclStuff
syn keyword tkPackOpts          contained after anchor before expand fill in ipadx ipady padx pady side
hi link tkPackOpts		tclOption
hi link tkPackCmds		tclSubcommand

syn keyword tkKeyword           contained place skipwhite nextgroup=tkPlacePredicate
syn region tkPlacePredicate     contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkPlaceCmds,tkPlaceOptsGroup,@tclStuff
syn keyword tkPlaceCmds         contained forget info slaves
syn match tkPlaceOptsGroup      contained "-\a\+" contains=tkPlaceOpts,@tclStuff
syn keyword tkPlaceOpts         contained anchor bordermode height in relheight relwidth relx rely width x y
hi link tkPlaceOpts		tclOption
hi link tkPlaceCmds		tclSubcommand

syn keyword tkWidget                    contained canvas skipwhite nextgroup=tkCanvasPredicate
syn region tkCanvasPredicate            contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tkCanvasCluster,@tclStuff
syn keyword tkCanvasTagOpts             contained above all below closest enclosed overlapping withtag
syn keyword tkCanvasPsOpts              contained colormap colormode file fontmap height pageanchor pageheight pagewidth pagex pagey rotate width x y
syn keyword tkCanvasItemOpts            contained activebackground activebitmap activedash activefill activeforeground activeimage activeoutline activeoutlinestipple activestipple activewidth anchor arrow arrowshape background bitmap capstyle dash dashoffset disabledbackground disabledbitmap disableddash disabledfill disabledforeground disabledimage disabledoutline disabledoutlinestipple disabledstipple disabledwidth extent fill font foreground height image joinstyle justify offset outline outlinestipple smooth splinesteps start state stipple style tag[s] text width window
syn cluster tkCanvasCluster		contains=tkCanvasItemOpts,tkCanvasTagOpts,tkCanvasPsOpts,tkWidgetOptsGroup
" dicey
syn keyword tkWidgetCreate              contained create skipwhite nextgroup=tkWidgetCreatePredicate
syn region tkWidgetCreatePredicate      contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateCmds
syn match tkWidgetCreateCommonOptsGroup contained "-\a\+" contains=tkWidgetCreateCommonOpts
syn keyword tkWidgetCreateCommonOpts    contained activedash activefill activeoutline activeoutlinestipple activestipple activewidth dash dashoffset disableddash disabledfill disabledoutline disabledoutlinestipple disabledstipple disabledwidth fill offset outline outlinestipple state stipple tag[s] width
syn keyword tkWidgetCreateCmds          contained arc skipwhite nextgroup=tkWidgetCreateArcPred
syn region tkWidgetCreateArcPred        contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateArcOptsGroup,@tclStuff
syn match tkWidgetCreateArcOptsGroup    contained "-\a\+" contains=tkWidgetCreateArcOpts,tkWidgetCreateCommonOpts
syn keyword tkWidgetCreateArcOpts       contained extent start style
syn keyword tkWidgetCreateCmds          contained bitmap skipwhite nextgroup=tkWidgetCreateBitmapPred
syn region tkWidgetCreateBitmapPred     contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateBitmapOptsGroup,@tclStuff
syn match tkWidgetCreateBitmapOptsGroup contained "-\a\+" contains=tkWidgetCreateBitmapOpts,tkWidgetCreateCommonOpts
syn keyword tkWidgetCreateBitmapOpts    contained activebackground activebitmap activeforeground anchor background bitmap disabledbackground disabledbitmap disabledforeground foreground
syn keyword tkWidgetCreateCmds          contained image skipwhite nextgroup=tkWidgetCreateImagePred
syn region tkWidgetCreateImagePred      contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateImageOptsGroup,@tclStuff
syn match tkWidgetCreateImageOptsGroup  contained "-\a\+" contains=tkWidgetCreateImageOpts,tkWidgetCreateCommonOpts
syn keyword tkWidgetCreateImageOpts     contained anchor image activeimage disabledimage
syn keyword tkWidgetCreateCmds          contained line skipwhite nextgroup=tkWidgetCreateLinePred
syn region tkWidgetCreateLinePred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateLineOptsGroup,@tclStuff
syn match tkWidgetCreateLineOptsGroup   contained "-\a\+" contains=tkWidgetCreateLineOpts,tkWidgetCreateCommonOpts
syn keyword tkWidgetCreateLineOpts      contained arrow arrowshape capstyle joinstyle smooth splinesteps
syn keyword tkWidgetCreateCmds          contained oval skipwhite nextgroup=tkWidgetCreateOvalPred
syn region tkWidgetCreateOvalPred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateCommonOptsGroup,@tclStuff
syn keyword tkWidgetCreateCmds          contained poly[gon] skipwhite nextgroup=tkWidgetCreatePolyPred
syn region tkWidgetCreatePolyPred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreatePolyOptsGroup,@tclStuff
syn match tkWidgetCreatePolyOptsGroup   contained "-\a\+" contains=tkWidgetCreatePolyOpts,tkWidgetCreateCommonOpts
syn keyword tkWidgetCreatePolyOpts      contained joinstyle smooth splinesteps
syn keyword tkWidgetCreateCmds          contained rect[angle] skipwhite nextgroup=tkWidgetCreateRectPred
syn region tkWidgetCreateRectPred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateCommonOptsGroup,@tclStuff
syn keyword tkWidgetCreateCmds          contained text skipwhite nextgroup=tkWidgetCreateTextPred
syn region tkWidgetCreateTextPred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateTextOptsGroup,@tclStuff
syn match tkWidgetCreateTextOptsGroup   contained "-\a\+" contains=tkWidgetCreateTextOpts,tkWidgetCreateCommonOpts
syn keyword tkWidgetCreateTextOpts      contained anchor font justify text width
syn keyword tkWidgetCreateCmds          contained window skipwhite nextgroup=tkWidgetCreateWinPred
syn region tkWidgetCreateWinPred        contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateWinOptsGroup,@tclStuff
syn match tkWidgetCreateWinOptsGroup    contained "-\a\+" contains=tkWidgetCreateWinOpts,tkWidgetCreateCommonOpts
syn keyword tkWidgetCreateWinOpts       contained anchor height width window
syn keyword tkWidgetCmds                contained itemconfig[ure] itemcget skipwhite nextgroup=tkCanvasItemConfigurePred
syn region tkCanvasItemConfigurePred    contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreateArcOpts,tkWidgetCreateBitmapOpts,tkWidgetCreateCommonOpts,tkWidgetCreateImageOpts,tkWidgetCreateLineOpts,tkWidgetCreateOvalOpts,tkWidgetCreatePolyOpts,tkWidgetCreateRectOpts,tkWidgetCreateTextOpts,tkWidgetCreateWinOpts,@tclStuff

hi link tkWidgetCreate           tclSubcommand 
hi link tkCanvasPsOpts           tclOption     
hi link tkCanvasTagOpts          tclOption     
hi link tkCanvasItemOpts         tclOption     
hi link tkWidgetCreateCmds       tclEnsemble   
hi link tkWidgetCreateArcOpts    tclOption     
hi link tkWidgetCreateBitmapOpts tclOption     
hi link tkWidgetCreateCommonOpts tclOption     
hi link tkWidgetCreateImageOpts  tclOption     
hi link tkWidgetCreateLineOpts   tclOption     
hi link tkWidgetCreateOvalOpts   tclOption     
hi link tkWidgetCreatePolyOpts   tclOption     
hi link tkWidgetCreateRectOpts   tclOption     
hi link tkWidgetCreateTextOpts   tclOption     
hi link tkWidgetCreateWinOpts    tclOption     

" , includes -  bitmap photo
syn keyword tkWidget                   contained image skipwhite nextgroup=tkWidgetImagePred
syn region tkWidgetImagePred           contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkImageCmds,tkWidgetCreate,@tclStuff
syn keyword tkImageCmds                contained delete inuse names type types 
syn keyword tkImageCmds                contained anchor height width window

" create bitmap starts in canvas, this appends
syn keyword tkWidgetCreateBitmapOpts   contained background data file foreground maskdata maskfile
syn keyword tkWidgetCreateCmds         contained photo skipwhite nextgroup=tkWidgetCreatePhotoPred
syn region tkWidgetCreatePhotoPred     contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetCreatePhotoOptsGroup,@tclStuff
syn match tkWidgetCreatePhotoOptsGroup contained "-\a\+" contains=tkWidgetCreatePhotoOpts
syn keyword tkWidgetCreatePhotoOpts    contained data format file gamma height palette width
hi link tkWidgetCreatePhotoOpts tclOption
hi link tkImageCmds tclSubcommand

" Syntax: from photo
syn keyword tkWidgetCmds               contained blank
syn keyword tkWidgetCmds               contained copy skipwhite nextgroup=tkWidgetImageCopyPred
syn region tkWidgetImageCopyPred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetImageCopyOptsGroup,@tclStuff
syn match tkWidgetImageCopyOptsGroup   contained "-\a\+" contains=tkWidgetImageCopyOpts
syn keyword tkWidgetImageCopyOpts      contained from to shrink zoom subsample compositingrule
syn keyword tkWidgetCmds               contained data skipwhite nextgroup=tkWidgetImageDataPred
syn region tkWidgetImageDataPred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetImageDataOptsGroup,@tclStuff
syn match tkWidgetImageDataOptsGroup   contained "-\a\+" contains=tkWidgetImageDataOpts
syn keyword tkWidgetImageDataOpts      contained background format from grayscale
syn keyword tkWidgetCmds               contained put skipwhite nextgroup=tkWidgetImagePutPred
syn region tkWidgetImagePutPred        contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetImagePutOptsGroup,@tclStuff
syn match tkWidgetImagePutOptsGroup    contained "-\a\+" contains=tkWidgetImagePutOpts
syn keyword tkWidgetImagePutOpts       contained format to
syn keyword tkWidgetCmds               contained read skipwhite nextgroup=tkWidgetImageReadPred
syn region tkWidgetImageReadPred       contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetImageReadOptsGroup,@tclStuff
syn match tkWidgetImageReadOptsGroup   contained "-\a\+" contains=tkWidgetImageReadOpts
syn keyword tkWidgetImageReadOpts      contained format from shrink to
syn keyword tkWidgetCmds               contained redither
syn keyword tkWidgetCmds               contained transparency skipwhite nextgroup=tkWidgetImageTransPred
syn region tkWidgetImageTransPred      contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetImageTransOptsGroup,@tclStuff
syn match tkWidgetImageTransOptsGroup  contained "-\a\+" contains=tkWidgetImageTransOpts
syn keyword tkWidgetImageTransOpts     contained get set
syn keyword tkWidgetCmds               contained write skipwhite nextgroup=tkWidgetImageWritePred
syn region tkWidgetImageWritePred      contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tkWidgetImageWriteOptsGroup,@tclStuff
syn match tkWidgetImageWriteOptsGroup  contained "-\a\+" contains=tkWidgetImageWriteOpts
syn keyword tkWidgetImageWriteOpts     contained background format from grayscale
hi link tkWidgetImageCopyOpts tclOption
hi link tkWidgetImageDataOpts tclOption
hi link tkWidgetImagePutOpts tclOption
hi link tkWidgetImageReadOpts tclOption
hi link tkWidgetImageTransOpts tclOption
hi link tkWidgetImageWriteOpts tclOption

syn keyword tkWidget		contained text skipwhite nextgroup=tkTextPredicate
syn keyword tkKeyword		contained tk_textCopy tk_textCut tk_textPaste
syn region tkTextPredicate	contained keepend excludenl start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tkTextCluster,@tclStuff
" this is how you 'subclass' an OptsGroup
syn match tkTextWidgetOptsGroup contained "-\a\+" contains=tkTextWidgetOpts,tkWidgetOpts
syn keyword tkTextWidgetOpts    contained autoseparators blockcursor endline inactiveselectionbackground maxundo spacing1 spacing2 spacing3 startline tabs undo wrap
syn cluster tkTextCluster	contains=tkTextWidgetOptsGroup
hi link tkTextWidgetOpts tclOption

syn keyword tkWidget           contained listbox skipwhite nextgroup=tkWidgetPredicate


" -------------------------
" Highlights: Basic
" -------------------------
" hi link tclCommand     Normal
" hi link tclBraces      Normal
" hi link tclBrackets    Normal
" hi link tclPredicate   Normal
" hi link tclWord1       Normal
" hi link tclWord0       Normal
hi link tclLContinue     WarningMsg
hi link tclBookends      Title
hi link tclQuotes        String
hi link tclNumber        Number
hi link tclKeyword       Statement
hi link tclRepeat        Repeat
hi link tclLabel         Label
hi link tclException     Exception
hi link tclConditional   Conditional
hi link tclComment       Comment
hi link tclIfComment      Comment
hi link tclIfCommentStart Comment
hi link tclSpecial       Special
hi link tclTodo          Todo
hi link tclVariable      Identifier
hi link tclPrimary       Statement
hi link tclSecondary     Special
hi link tclSubcommand    Special
hi link tclOption        Type
hi link tclEnsemble      PreProc
hi link tclMaths         Special
hi link tclExpand        Underlined
" ------------------
hi link tkWidgetCmds     tclSubcommand
hi link tkWidgetOpts     tclOption
" ------------------
hi link tclMagicName     tclKeyword
hi link tkKeyword        tclKeyword
hi link tkReserved       tclKeyword
hi link tkWidget         tclOption
hi link tkDialog         tclKeyword
hi link tkColor          Title
hi link tkEvent          tclQuotes
hi link tclProcName      tclBookends


" -------------------------
" Highlights: Extended
" -------------------------
hi link tclAfterCmds tclSubcommand
hi link tclArrayCmds tclSubcommand
hi link tclArrayNamesOpts tclOption
hi link tclBinaryCmds tclSubcommand
hi link tclClockAddOpts tclOption
hi link tclClockCmds tclSubcommand
hi link tclDictCmds tclSubcommand
hi link tclDictFilterOpts tclOption
hi link tclEncodingCmds tclSubcommand
hi link tclExecOpts tclOption
hi link tclFconfigureOpts tclOption
hi link tclFcopyOpts tclOption
hi link tclFileAtimeOpts tclOption
hi link tclFileAttributesOpts tclOption
hi link tclFileCmds tclSubcommand
hi link tclFileCopyOpts tclOption
hi link tclFileeventCmds tclSubcommand
hi link tclGlobOpts tclOption
hi link tclHistoryAddCmds tclSubcommand
hi link tclHistoryCmds tclSubcommand
hi link tclInfoCmds tclSubcommand
hi link tclInterpCmds tclSubcommand
hi link tclInterpCreateOpts tclOption
hi link tclInterpInvokehiddenOpts tclOption
hi link tclInterpLimitOpts tclOption
hi link tclInterpSubInvokehiddenOpts tclOption
hi link tclInterpSubLimitOpts tclOption
hi link tclLsearchOpts tclOption
hi link tclLsortOpts tclOption
hi link tclMemoryCmds tclSubcommand
hi link tclOpenOpts tclOption
hi link tclPackageCmds tclSubcommand
hi link tclPackagePresentOpts tclOption
hi link tclPutsOpts tclOption
hi link tclRegexpOpts tclOption
hi link tclRegsubOpts tclOption
hi link tclReturnOpts tclOption
hi link tclSeekCmds tclSubcommand
hi link tclSocketOpts tclOption
hi link tclSourceOpts tclOption
hi link tclStringCmds tclSubcommand
hi link tclStringCompareOpts tclOption
hi link tclStringIsClass tclEnsemble
hi link tclStringIsClassOpts tclOption
hi link tclStringMapOpts tclOption
hi link tclSubstOpts tclOption
hi link tclSwitchOpts tclOption
hi link tclTraceAddCmds tclSubcommand
hi link tclTraceAddCommandCmds tclSubcommand
hi link tclTraceAddExecutionCmds tclSubcommand
hi link tclTraceAddVariableCmds tclSubcommand
hi link tclTraceCmds tclSubcommand
hi link tclUnloadOpts tclOption
hi link tclUnsetOpts tclOption
hi link tclUpdateCmds tclSubcommand
hi link tkBellOpts tclOption
hi link tkClipboardClearOpts tclOption
hi link tkClipboardCmds tclSubcommand
hi link tkConsoleCmds tclSubcommand
hi link tkFocusOpts tclOption
hi link tkTkwaitCmds tclSubcommand
hi link tkWinfoAtomOpts tclOption
hi link tkWinfoCmds tclSubcommand
hi link tkWmCmds tclSubcommand

" -------------------------
" Hoodage:
" -------------------------
:sy sync minlines=60
let b:current_syntax = "tcl"
" -------------------------


" -------------------------

" vim:foldmethod=marker
