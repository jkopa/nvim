if exists("b:current_syntax")
    finish
endif

syn match fmetaComment "//.*$"
syn match fmetaDirective "@\(table\|table_gen_enum\|table_gen_data\|embed_binary\)\>"
syn keyword fmetaKeyword from
syn match fmetaTableName "\<\u\w*\>\ze\s*:"
syn region fmetaString start=+"+ end=+"+ skip=+\\"+
syn match fmetaNumber "\<\d\+\>"
syn match fmetaConstant "\<VK_\w\+\>"
syn match fmetaConstant "\<[A-Z][A-Z0-9_]\{2,}\>"

hi def link fmetaComment Comment
hi def link fmetaDirective PreProc
hi def link fmetaKeyword Keyword
hi def link fmetaTableName Type
hi def link fmetaString String
hi def link fmetaNumber Number
hi def link fmetaConstant Constant

let b:current_syntax = "fmeta"
