//
//  dbg.h
//  Stomt Framework
//
//  Created by Leonardo Cascianelli on 09/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//


//You shouldn't really touch this file.

#ifndef Stomt_Framework_dbg_h
#define Stomt_Framework_dbg_h

#ifndef __DBG__
#define _warn(M,...)
#define _err(M,...) goto error;
#define _info(M,...)
#define __check(O,M,...)
#else
#define _warn(M,...) fprintf(stderr, "[!?] " M "\n", ##__VA_ARGS__)
#define _err(M,...) {fprintf(stderr, "[!!] " M "\n", ##__VA_ARGS__); errno=0; goto error;}
#define _info(M,...) fprintf(stderr, "[@] " M "\n", ##__VA_ARGS__)
#define __check(O,M,...) if(!O) _err(M,...)
#endif

#endif
