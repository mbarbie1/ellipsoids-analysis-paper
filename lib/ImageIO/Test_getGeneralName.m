regexString = 'W-[W][ww]_F[ff]_C[cc]_T[tt]_Z[zzz]'
subStruct.name = {'W', 'w', 'f', 'c', 't', 'z'}
subStruct.value = {'E', 6, 0, 1, 0, 3}
subStruct.type = {'string', 'int', 'int', 'int', 'int', 'int'}

name = getGeneralName(subStruct, regexString)
