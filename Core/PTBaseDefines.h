//
//  PTBaseDefines.h
//  PTKit
//
//  Created by LeeHu on 14/12/2.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#ifndef PTKit_PTBaseDefines_h
#define PTKit_PTBaseDefines_h

#ifdef __cplusplus
# define PT_EXTERN_C_BEGIN extern "C" {
# define PT_EXTERN_C_END   }
#else
# define PT_EXTERN_C_BEGIN
# define PT_EXTERN_C_END
#endif

#ifdef __GNUC__
# define PT_GNUC(major, minor) \
(__GNUC__ > (major) || (__GNUC__ == (major) && __GNUC_MINOR__ >= (minor)))
#else
# define PT_GNUC(major, minor) 0
#endif


#ifndef PT_INLINE
# if defined (__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define PT_INLINE static inline
# elif defined (__MWERKS__) || defined (__cplusplus)
#  define PT_INLINE static inline
# elif PT_GNUC (3, 0)
#  define PT_INLINE static __inline__ __attribute__ ((always_inline))
# else
#  define PT_INLINE static
# endif
#endif

#ifndef PT_HIDDEN
# if PT_GNUC (4,0)
#  define PT_HIDDEN __attribute__ ((visibility ("hidden")))
# else
#  define PT_HIDDEN /* no hidden */
# endif
#endif

#ifndef PT_PURE
# if PT_GNUC (3, 0)
#  define PT_PURE __attribute__ ((pure))
# else
#  define PT_PURE /* no pure */
# endif
#endif


#ifndef PT_CONST
# if PT_GNUC (3, 0)
#  define PT_CONST __attribute__ ((const))
# else
#  define PT_CONST /* no const */
# endif
#endif

#ifndef PT_WARN_UNUSED
# if PT_GNUC (3, 4)
#  define PT_WARN_UNUSED __attribute__ ((warn_unused_result))
# else
#  define PT_WARN_UNUSED /* no warn_unused */
# endif
#endif

#ifndef PT_WARN_DEPRECATED
# define PT_WARN_DEPRECATED 1
#endif

#ifndef PT_DEPRECATED
# if PT_GNUC (3, 0) && PT_WARN_DEPRECATED
#  define PT_DEPRECATED __attribute__ ((deprecated))
# else
#  define PT_DEPRECATED
# endif
#endif





#endif

